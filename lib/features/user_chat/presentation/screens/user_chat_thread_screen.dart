import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../core/network/api_constant.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../quality_management/presentation/utils/open_attachment_file.dart';
import '../../../quality_management/presentation/widgets/quality_request_attachments_table.dart';
import '../cubit/user_chat_thread_cubit.dart';
import '../../data/models/user_chat_models.dart';

class UserChatThreadScreen extends StatefulWidget {
  const UserChatThreadScreen({required this.title, super.key});

  final String title;

  @override
  State<UserChatThreadScreen> createState() => _UserChatThreadScreenState();
}

class _UserChatThreadScreenState extends State<UserChatThreadScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _controller.text;
    _controller.clear();
    context.read<UserChatThreadCubit>().send(text);
  }

  Future<void> _pickAttachment(UserChatAttachmentType type) async {
    String? path;

    if (type == UserChatAttachmentType.image) {
      final file = await _imagePicker.pickImage(source: ImageSource.gallery);
      path = file?.path;
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: type == UserChatAttachmentType.pdf
            ? FileType.custom
            : FileType.any,
        allowedExtensions:
            type == UserChatAttachmentType.pdf ? const ['pdf'] : null,
      );
      path = result?.files.single.path;
    }

    if (!mounted || path == null || path.isEmpty) return;
    await context.read<UserChatThreadCubit>().sendAttachment(
      filePath: path,
      attachmentType: type,
    );
  }

  Future<void> _openAttachment(UserChatMessage msg) async {
    final path = msg.attachmentPath?.trim();
    if (path == null || path.isEmpty) return;

    final fileName = _attachmentFileName(path);
    final lower = fileName.toLowerCase();
    final isImage = msg.attachmentType == UserChatAttachmentType.image ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp');
    final isPdf = msg.attachmentType == UserChatAttachmentType.pdf ||
        lower.endsWith('.pdf');

    final token = await DioHelper.getAccessToken();
    final url = ApiConstants.resolveAttachmentMediaUrl(path, token: token);
    if (!mounted) return;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.unKnownError.tr())),
      );
      return;
    }

    // Images: same in-app viewer as quality request details.
    if (isImage) {
      await Navigator.push(
        context,
        QualityRequestImageViewerScreen.route(
          title: fileName,
          imageUrl: url,
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    List<int>? bytes;
    try {
      final response = await DioHelper.getData(
        url: url,
        responseType: ResponseType.bytes,
      );
      final data = response.data;
      if (data is Uint8List) {
        bytes = data;
      } else if (data is List<int>) {
        bytes = data;
      } else if (data is List) {
        bytes = data.cast<int>();
      }
    } catch (_) {
      bytes = null;
    }

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    if (bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.unKnownError.tr())),
      );
      return;
    }

    final data = Uint8List.fromList(bytes);

    // PDF: in-app viewer (same as request details).
    if (isPdf) {
      await Navigator.push(
        context,
        QualityRequestPdfViewerScreen.route(title: fileName, bytes: data),
      );
      return;
    }

    // docx / xlsx / other → open_filex like request details.
    final result = await openAttachmentWithSystemApp(
      bytes: data,
      fileName: fileName,
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

  String _attachmentFileName(String path) {
    final cleaned = path
        .replaceAll('\\', '/')
        .replaceAll(RegExp(r'[\u200e\u200f\u2068\u2069]'), '')
        .trim();
    final parts = cleaned.split('/').where((p) => p.trim().isNotEmpty).toList();
    final name = parts.isNotEmpty ? parts.last.trim() : 'attachment';
    return name.isEmpty ? 'attachment' : name;
  }

  bool _shouldShowDateHeader(List<UserChatMessage> messages, int index) {
    final current = messages[index].createdAt;
    if (current == null) return false;
    if (index == 0) return true;
    final previous = messages[index - 1].createdAt;
    if (previous == null) return true;
    return !_isSameDay(current, previous);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatMessageTime(DateTime date) {
    final local = date.toLocal();
    return DateFormat('hh:mm a', context.locale.toString()).format(local);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kBgColor,
        elevation: 0,
        foregroundColor: colors.kFontColor,
        title: Text(
          widget.title,
          style: TextStyle(
            color: colors.kFontColor,
            fontWeight: FontWeight.bold,
            fontSize: 17.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<UserChatThreadCubit, UserChatThreadState>(
              listener: (context, state) {
                if (state is UserChatThreadLoaded) {
                  _scrollToEnd();
                  if (state.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error!)),
                    );
                  }
                }
              },
              builder: (context, state) {
                if (state is UserChatThreadLoading ||
                    state is UserChatThreadInitial) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: colors.kPrimaryColor,
                    ),
                  );
                }
                if (state is UserChatThreadError) {
                  return Center(
                    child: TextButton(
                      onPressed: () =>
                          context.read<UserChatThreadCubit>().load(),
                      child: Text('retry'.tr()),
                    ),
                  );
                }
                if (state is! UserChatThreadLoaded) {
                  return const SizedBox.shrink();
                }
                if (state.messages.isEmpty) {
                  return Center(
                    child: Text(
                      'user_chat_no_messages'.tr(),
                      style: TextStyle(color: colors.kGrayColor),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[index];
                    final mine = msg.isMine;
                    final showDateHeader = _shouldShowDateHeader(
                      state.messages,
                      index,
                    );

                    return Column(
                      children: [
                        if (showDateHeader)
                          _ChatDateHeader(date: msg.createdAt!),
                        Align(
                          alignment: mine
                              ? AlignmentDirectional.centerStart
                              : AlignmentDirectional.centerEnd,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 8.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.sizeOf(context).width * 0.78,
                            ),
                            decoration: BoxDecoration(
                              color: mine
                                  ? colors.kPrimaryColor
                                      .withValues(alpha: 0.18)
                                  : colors.kInputColor,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: colors.kBorderColor
                                    .withValues(alpha: 0.35),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (msg.text.isNotEmpty)
                                  Text(
                                    msg.text,
                                    style: TextStyle(
                                      color: colors.kFontColor,
                                      fontSize: 14.sp,
                                      height: 1.35,
                                    ),
                                  ),
                                if (msg.hasAttachment) ...[
                                  if (msg.text.isNotEmpty)
                                    SizedBox(height: 8.h),
                                  InkWell(
                                    onTap: () => _openAttachment(msg),
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.kBgColor
                                            .withValues(alpha: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            switch (msg.attachmentType) {
                                              UserChatAttachmentType.image =>
                                                Icons.image_outlined,
                                              UserChatAttachmentType.pdf =>
                                                Icons
                                                    .picture_as_pdf_outlined,
                                              _ => Icons.attach_file_rounded,
                                            },
                                            size: 18.sp,
                                            color: colors.kPrimaryColor,
                                          ),
                                          SizedBox(width: 6.w),
                                          Flexible(
                                            child: Text(
                                              'user_chat_open_attachment'
                                                  .tr(),
                                              style: TextStyle(
                                                color: colors.kPrimaryColor,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                if (msg.createdAt != null) ...[
                                  SizedBox(height: 6.h),
                                  Align(
                                    alignment:
                                        AlignmentDirectional.centerEnd,
                                    child: Text(
                                      _formatMessageTime(msg.createdAt!),
                                      style: TextStyle(
                                        color: colors.kGrayColor,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 10.h),
              child: Row(
                children: [
                  PopupMenuButton<UserChatAttachmentType>(
                    tooltip: 'user_chat_attach'.tr(),
                    onSelected: _pickAttachment,
                    color: colors.kInputColor,
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: colors.kPrimaryColor,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: UserChatAttachmentType.image,
                        child: Text('user_chat_attachment_image'.tr()),
                      ),
                      PopupMenuItem(
                        value: UserChatAttachmentType.pdf,
                        child: Text('user_chat_attachment_pdf'.tr()),
                      ),
                      PopupMenuItem(
                        value: UserChatAttachmentType.document,
                        child: Text('user_chat_attachment_document'.tr()),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      style: TextStyle(color: colors.kFontColor),
                      decoration: InputDecoration(
                        hintText: 'user_chat_type_message'.tr(),
                        hintStyle: TextStyle(color: colors.kGrayColor),
                        filled: true,
                        fillColor: colors.kInputColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 10.h,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  BlocBuilder<UserChatThreadCubit, UserChatThreadState>(
                    builder: (context, state) {
                      final sending =
                          state is UserChatThreadLoaded && state.sending;
                      return IconButton.filled(
                        onPressed: sending ? null : _send,
                        style: IconButton.styleFrom(
                          backgroundColor: colors.kPrimaryColor,
                          foregroundColor: colors.kWhiteColor,
                        ),
                        icon: sending
                            ? SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.kWhiteColor,
                                ),
                              )
                            : const Icon(Icons.send_rounded),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatDateHeader extends StatelessWidget {
  const _ChatDateHeader({required this.date});

  final DateTime date;

  String _label(BuildContext context) {
    final local = date.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(local.year, local.month, local.day);
    final diff = today.difference(messageDay).inDays;

    if (diff == 0) return 'user_chat_today'.tr();
    if (diff == 1) return 'user_chat_yesterday'.tr();
    return DateFormat('EEEE, d MMMM yyyy', context.locale.toString())
        .format(local);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: colors.kInputColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: colors.kBorderColor.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            _label(context),
            style: TextStyle(
              color: colors.kFontColor.withValues(alpha: 0.75),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
