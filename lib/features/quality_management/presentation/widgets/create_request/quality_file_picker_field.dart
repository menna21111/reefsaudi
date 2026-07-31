import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';

class QualityFilePickerField extends StatelessWidget {
  const QualityFilePickerField({
    super.key,
    required this.label,
    required this.filePath,
    required this.onPicked,
    this.onClear,
  });

  final String label;
  final String? filePath;
  final ValueChanged<String> onPicked;
  final VoidCallback? onClear;

  static const _imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'heic',
    'heif',
    'bmp',
  };

  bool _isImagePath(String path) {
    final ext = path.split('.').last.toLowerCase();
    return _imageExtensions.contains(ext);
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final path = picked.path;
    if (path.isEmpty || !await File(path).exists()) return;

    onPicked(path);
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
        'txt',
        'zip',
        'rar',
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
        'heic',
        'heif',
        'bmp',
      ],
      withData: false,
    );
    final file = result?.files.single;
    final path = file?.path;
    if (path == null || path.isEmpty || !await File(path).exists()) return;

    onPicked(path);
  }

  Future<void> _showPickerOptions(BuildContext context) async {
    final colors = context.appColorsRead;

    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: colors.kBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.kBorderColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Icon(Icons.image_outlined, color: colors.kPrimaryColor),
                title: Text(
                  AppString.pickImage.tr(),
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    color: colors.kFontColor,
                  ),
                ),
                onTap: () => Navigator.pop(ctx, 'image'),
              ),
              ListTile(
                leading: Icon(
                  Icons.insert_drive_file_outlined,
                  color: colors.kPrimaryColor,
                ),
                title: Text(
                  AppString.pickDocument.tr(),
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    color: colors.kFontColor,
                  ),
                ),
                onTap: () => Navigator.pop(ctx, 'document'),
              ),
            ],
          ),
        ),
      ),
    );

    if (choice == 'image') {
      await _pickImage();
    } else if (choice == 'document') {
      await _pickDocument();
    }
  }

  String get _fileName {
    final path = filePath;
    if (path == null || path.isEmpty) return '';
    return path.split(Platform.pathSeparator).last;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasFile = filePath != null && filePath!.isNotEmpty;
    final isImage = hasFile && _isImagePath(filePath!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 10.h),
        InkWell(
          onTap: () => _showPickerOptions(context),
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
            decoration: BoxDecoration(
              color: colors.kInputColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: colors.kBorderColor.withValues(alpha: 0.45),
              ),
            ),
            child: hasFile
                ? Row(
                    children: [
                      Icon(
                        isImage
                            ? Icons.image_outlined
                            : Icons.insert_drive_file_outlined,
                        color: colors.kPrimaryColor,
                        size: 22.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          _fileName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.kFontColor,
                            fontSize: 13.sp,
                            fontFamily: 'Almarai',
                          ),
                        ),
                      ),
                      if (onClear != null)
                        IconButton(
                          onPressed: onClear,
                          icon: Icon(
                            Icons.close_rounded,
                            color: colors.kGrayColor,
                            size: 20.sp,
                          ),
                        ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(
                        Icons.upload_file_outlined,
                        color: colors.kPrimaryColor,
                        size: 28.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        AppString.selectFile.tr(),
                        style: TextStyle(
                          color: colors.kPrimaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Almarai',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        AppString.imageOrFileHint.tr(),
                        style: TextStyle(
                          color: colors.kGrayColor,
                          fontSize: 12.sp,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
