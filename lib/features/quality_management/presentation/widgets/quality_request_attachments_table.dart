import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../core/network/api_constant.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_request_attachment_models.dart';
import '../cubit/quality_management_cubit.dart';
import '../utils/open_attachment_file.dart';

class QualityRequestImageViewerScreen extends StatelessWidget {
  const QualityRequestImageViewerScreen({
    super.key,
    required this.title,
    this.bytes,
    this.imageUrl,
  }) : assert(bytes != null || imageUrl != null);

  final String title;
  final Uint8List? bytes;
  final String? imageUrl;

  static Route<void> route({
    required String title,
    Uint8List? bytes,
    String? imageUrl,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => QualityRequestImageViewerScreen(
        title: title,
        bytes: bytes,
        imageUrl: imageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: colors.kBgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.kFontColor),
        title: Text(
          title,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Almarai',
          ),
        ),
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: Center(
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.contain,
                  placeholder: (_, _) => CircularProgressIndicator(
                    color: colors.kPrimaryColor,
                  ),
                  errorWidget: (_, _, _) => Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Text(
                      AppString.unKnownError.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.kFontColor),
                    ),
                  ),
                )
              : Image.memory(
                  bytes!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Text(
                      AppString.unKnownError.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.kFontColor),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class QualityRequestPdfViewerScreen extends StatefulWidget {
  const QualityRequestPdfViewerScreen({
    super.key,
    required this.title,
    required this.bytes,
  });

  final String title;
  final Uint8List bytes;

  static Route<void> route({
    required String title,
    required Uint8List bytes,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => QualityRequestPdfViewerScreen(
        title: title,
        bytes: bytes,
      ),
    );
  }

  @override
  State<QualityRequestPdfViewerScreen> createState() =>
      _QualityRequestPdfViewerScreenState();
}

class _QualityRequestPdfViewerScreenState
    extends State<QualityRequestPdfViewerScreen> {
  late final PdfControllerPinch _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = PdfControllerPinch(
      document: PdfDocument.openData(widget.bytes),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kBgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.kFontColor),
        title: Text(
          widget.title,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Almarai',
          ),
        ),
      ),
      body: _error != null
          ? Center(
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.kFontColor),
              ),
            )
          : PdfViewPinch(
              controller: _controller,
              padding: 12,
              onDocumentError: (error) {
                if (!mounted) return;
                setState(() => _error = error.toString());
              },
            ),
    );
  }
}

class QualityRequestAttachmentsTable extends StatefulWidget {
  const QualityRequestAttachmentsTable({
    super.key,
    required this.requestId,
    required this.items,
    this.downloadingAttachmentId,
    this.isDownloading = false,
  });

  final String requestId;
  final List<ProjectRequestAttachmentItem> items;
  final String? downloadingAttachmentId;
  final bool isDownloading;

  @override
  State<QualityRequestAttachmentsTable> createState() =>
      _QualityRequestAttachmentsTableState();
}

class _QualityRequestAttachmentsTableState
    extends State<QualityRequestAttachmentsTable> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProjectRequestAttachmentItem> get _filteredItems {
    if (_query.trim().isEmpty) return widget.items;
    final query = _query.trim().toLowerCase();
    return widget.items.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.parentName.toLowerCase().contains(query);
    }).toList();
  }

  Future<String?> _resolveImageUrl(ProjectRequestAttachmentItem item) async {
    final token = await DioHelper.getAccessToken();
    return ApiConstants.resolveAttachmentMediaUrl(
      item.attachmentPath,
      token: token,
    );
  }

  Future<void> _openAttachment(ProjectRequestAttachmentItem item) async {
    if (item.isImage) {
      final url = await _resolveImageUrl(item);
      if (!mounted) return;
      if (url != null && url.isNotEmpty) {
        await Navigator.push(
          context,
          QualityRequestImageViewerScreen.route(
            title: item.name,
            imageUrl: url,
          ),
        );
        return;
      }
    }

    final cubit = context.read<QualityManagementCubit>();
    final bytes = await cubit.downloadAttachment(item);
    if (!mounted) return;
    if (bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.unKnownError.tr())),
      );
      return;
    }

    final data = Uint8List.fromList(bytes);

    if (item.isPdf) {
      await Navigator.push(
        context,
        QualityRequestPdfViewerScreen.route(
          title: item.name,
          bytes: data,
        ),
      );
      return;
    }

    if (item.isImage) {
      await Navigator.push(
        context,
        QualityRequestImageViewerScreen.route(
          title: item.name,
          bytes: data,
        ),
      );
      return;
    }

    // docx / xlsx / other → system app via open_filex
    final result = await openAttachmentWithSystemApp(
      bytes: data,
      fileName: item.name,
    );
    if (!mounted) return;
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.message.isNotEmpty
                ? result.message
                : AppString.unKnownError.tr(),
          ),
        ),
      );
    }
  }

  String _openHint(ProjectRequestAttachmentItem item) {
    if (item.isPdf) return 'عرض PDF';
    if (item.isImage) return 'عرض الصورة';
    return 'فتح الملف';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final items = _filteredItems;

    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 13.sp,
            fontFamily: 'Almarai',
          ),
          decoration: InputDecoration(
            hintText: AppString.search.tr(),
            prefixIcon: Icon(Icons.search_rounded, color: colors.kGrayColor),
            filled: true,
            fillColor: colors.kBgColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: colors.kBorderColor.withValues(alpha: 0.25),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: colors.kBorderColor.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        if (items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Column(
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  color: colors.kGrayColor.withValues(alpha: 0.6),
                  size: 48.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  AppString.noData.tr(),
                  style: TextStyle(
                    color: colors.kGrayColor,
                    fontSize: 13.sp,
                    fontFamily: 'Almarai',
                  ),
                ),
              ],
            ),
          )
        else
          ...items.map((item) {
            final isLoading = widget.isDownloading &&
                widget.downloadingAttachmentId == item.id;

            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: item.isOpenable && !widget.isDownloading
                      ? () => _openAttachment(item)
                      : null,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Ink(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: colors.kBgColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: colors.kBorderColor.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (item.isImage)
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: _AttachmentImagePreview(
                              item: item,
                              isDownloading: isLoading,
                            ),
                          ),
                        Row(
                          children: [
                            Icon(
                              item.isPdf
                                  ? Icons.picture_as_pdf_rounded
                                  : item.isImage
                                      ? Icons.image_rounded
                                      : Icons.insert_drive_file_outlined,
                              color: item.isPdf
                                  ? colors.kRedColor
                                  : item.isImage
                                      ? colors.kPrimaryColor
                                      : colors.kGrayColor,
                              size: 24.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    item.name,
                                    textAlign: FormLayout.alignOf(context),
                                    textDirection: FormLayout.directionOf(context),
                                    style: TextStyle(
                                      color: colors.kFontColor,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Almarai',
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${AppString.parentFolder.tr()}: ${item.parentName}',
                                    textAlign: FormLayout.alignOf(context),
                                    textDirection: FormLayout.directionOf(context),
                                    style: TextStyle(
                                      color: colors.kGrayColor,
                                      fontSize: 11.sp,
                                      fontFamily: 'Almarai',
                                    ),
                                  ),
                                  Text(
                                    _formatDate(item.date),
                                    textAlign: FormLayout.alignOf(context),
                                    textDirection: FormLayout.directionOf(context),
                                    style: TextStyle(
                                      color: colors.kGrayColor,
                                      fontSize: 11.sp,
                                      fontFamily: 'Almarai',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isLoading)
                              SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.kPrimaryColor,
                                ),
                              )
                            else if (item.isOpenable)
                              Text(
                                _openHint(item),
                                style: TextStyle(
                                  color: colors.kPrimaryColor,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Almarai',
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _AttachmentImagePreview extends StatefulWidget {
  const _AttachmentImagePreview({
    required this.item,
    required this.isDownloading,
  });

  final ProjectRequestAttachmentItem item;
  final bool isDownloading;

  @override
  State<_AttachmentImagePreview> createState() =>
      _AttachmentImagePreviewState();
}

class _AttachmentImagePreviewState extends State<_AttachmentImagePreview> {
  String? _imageUrl;
  bool _failed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUrl();
  }

  @override
  void didUpdateWidget(covariant _AttachmentImagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.attachmentPath != widget.item.attachmentPath) {
      _loadUrl();
    }
  }

  Future<void> _loadUrl() async {
    setState(() {
      _loading = true;
      _failed = false;
      _imageUrl = null;
    });

    final token = await DioHelper.getAccessToken();
    final url = ApiConstants.resolveAttachmentMediaUrl(
      widget.item.attachmentPath,
      token: token,
    );
    if (!mounted) return;

    setState(() {
      _loading = false;
      if (url == null || url.isEmpty) {
        _failed = true;
      } else {
        _imageUrl = url;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (_failed) {
      return Container(
        height: 120.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.25)),
        ),
        child: Icon(
          Icons.broken_image_outlined,
          color: colors.kGrayColor,
          size: 32.sp,
        ),
      );
    }

    if (_loading || _imageUrl == null || widget.isDownloading) {
      return Container(
        height: 120.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.25)),
        ),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colors.kPrimaryColor,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: CachedNetworkImage(
        imageUrl: _imageUrl!,
        height: 160.h,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(
          height: 160.h,
          alignment: Alignment.center,
          color: colors.kInputColor,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colors.kPrimaryColor,
          ),
        ),
        errorWidget: (_, _, _) => Container(
          height: 120.h,
          alignment: Alignment.center,
          color: colors.kInputColor,
          child: Icon(
            Icons.broken_image_outlined,
            color: colors.kGrayColor,
            size: 32.sp,
          ),
        ),
      ),
    );
  }
}
