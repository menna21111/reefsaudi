import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';

class CharterSectionTable extends StatelessWidget {
  const CharterSectionTable({
    super.key,
    required this.title,
    required this.headers,
    required this.rows,
    required this.columnWidths,
    this.totalCount,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.toolbar,
    this.actionHeader,
    this.rowActions,
  });

  final String title;
  final List<String> headers;
  final List<List<String>> rows;
  final List<double> columnWidths;
  final int? totalCount;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final Widget? toolbar;
  final String? actionHeader;
  final List<Widget>? rowActions;

  double get _tableWidth =>
      columnWidths.fold<double>(0, (sum, w) => sum + w.w) +
      (actionHeader != null ? 88.w : 0) +
      28.w;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colors.kPrimaryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Almarai',
                ),
              ),
            ),
            if (totalCount != null)
              Text(
                '${AppString.totalRecords.tr()}: $totalCount',
                style: TextStyle(
                  color: colors.kGrayColor,
                  fontSize: 11.sp,
                  fontFamily: 'Almarai',
                ),
              ),
          ],
        ),
        SizedBox(height: 10.h),
        if (toolbar != null) ...[
          toolbar!,
          SizedBox(height: 10.h),
        ],
        Container(
          decoration: BoxDecoration(
            color: colors.kInputColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildContent(colors),
        ),
      ],
    );
  }

  Widget _buildContent(AppColorScheme colors) {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Center(
          child: CircularProgressIndicator(
            color: colors.kPrimaryColor,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Column(
          children: [
            Text(
              errorMessage!.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.kGrayColor, fontSize: 13.sp),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 12.h),
              TextButton(
                onPressed: onRetry,
                child: Text(AppString.retry.tr()),
              ),
            ],
          ],
        ),
      );
    }

    if (rows.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Center(
          child: Text(
            AppString.noData.tr(),
            style: TextStyle(color: colors.kGrayColor, fontSize: 13.sp),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: _tableWidth,
        child: Column(
          children: [
            _HeaderRow(
              colors: colors,
              headers: [
                ...headers,
                if (actionHeader != null) actionHeader!,
              ],
              columnWidths: [
                ...columnWidths,
                if (actionHeader != null) 88,
              ],
            ),
            ...List.generate(rows.length, (index) {
              final isLast = index == rows.length - 1;
              return _DataRow(
                colors: colors,
                cells: rows[index],
                columnWidths: columnWidths,
                showDivider: !isLast,
                action: rowActions != null && index < rowActions!.length
                    ? rowActions![index]
                    : null,
                showActionColumn: actionHeader != null,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.colors,
    required this.headers,
    required this.columnWidths,
  });

  final AppColorScheme colors;
  final List<String> headers;
  final List<double> columnWidths;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.kDarkGrayColor.withValues(alpha: 0.35),
      ),
      child: Row(
        children: List.generate(
          headers.length,
          (index) => _cell(
            headers[index],
            columnWidths[index].w,
            isHeader: true,
          ),
        ),
      ),
    );
  }

  Widget _cell(String text, double width, {bool isHeader = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          color: isHeader ? colors.kGrayColor : colors.kFontColor,
          fontSize: 11.sp,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.colors,
    required this.cells,
    required this.columnWidths,
    required this.showDivider,
    required this.showActionColumn,
    this.action,
  });

  final AppColorScheme colors;
  final List<String> cells;
  final List<double> columnWidths;
  final bool showDivider;
  final bool showActionColumn;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: colors.kBorderColor.withValues(alpha: 0.2),
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            cells.length,
            (index) => SizedBox(
              width: columnWidths[index].w,
              child: Text(
                cells[index],
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.kFontColor,
                  fontSize: 11.sp,
                  fontWeight: index == 0 ? FontWeight.w600 : FontWeight.normal,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (showActionColumn)
            SizedBox(
              width: 88.w,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: action ?? const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }
}

String formatCharterPercent(double value) {
  if (value == value.roundToDouble()) return '${value.toInt()}%';
  return '${value.toStringAsFixed(1)}%';
}

String formatCharterDate(String? raw) {
  if (raw == null || raw.isEmpty) return '-';
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return raw.split('T').first;
  return DateFormat('dd/MM/yyyy').format(parsed.toLocal());
}

String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
