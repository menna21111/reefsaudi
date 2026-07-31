import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';
import 'quality_request_detail_field.dart';

class QualityRequestDetailFieldsGrid extends StatelessWidget {
  const QualityRequestDetailFieldsGrid({
    super.key,
    required this.fields,
  });

  final List<({String label, String value})> fields;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 720
            ? 3
            : constraints.maxWidth >= 420
                ? 2
                : 1;
        final gap = 12.w;
        final itemWidth = (constraints.maxWidth - (gap * (cols - 1))) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: 4.h,
          children: fields
              .map(
                (field) => SizedBox(
                  width: itemWidth,
                  child: QualityRequestDetailField(
                    label: field.label,
                    value: field.value,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

abstract final class QualityRequestDetailFormatters {
  static String display(String? value) =>
      QualityRequestDetailField.display(value);

  static String date(DateTime? value) {
    if (value == null) return '-';
    if (value.year <= 1970) return '-';
    return DateFormat('dd-MM-yyyy').format(value);
  }

  static String longDate(DateTime? value) {
    if (value == null) return '-';
    if (value.year <= 1970) return '-';
    return DateFormat('MMMM d, yyyy', 'en_US').format(value);
  }
}

class QualityRequestDetailAttachmentLink extends StatelessWidget {
  const QualityRequestDetailAttachmentLink({
    super.key,
    required this.label,
    this.fileName,
    this.onTap,
    this.isLoading = false,
  });

  final String label;
  final String? fileName;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final name = fileName?.trim() ?? '';
    final hasFile = name.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 11.sp,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 6.h),
        if (!hasFile)
          Text(
            '-',
            style: TextStyle(
              color: colors.kFontColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Almarai',
            ),
          )
        else
          InkWell(
            onTap: isLoading ? null : onTap,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.kPrimaryColor,
                      ),
                    )
                  else
                    Icon(
                      Icons.insert_drive_file_outlined,
                      size: 18.sp,
                      color: colors.kPrimaryColor,
                    ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.kPrimaryColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Almarai',
                        decoration: TextDecoration.underline,
                      ),
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
