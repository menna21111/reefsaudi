import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_color_scheme.dart';
import '../utils/app_string.dart';
import '../utils/app_theme_context.dart';

class MasterDataItem {
  const MasterDataItem({
    required this.id,
    required this.title,
    required this.description,
    this.metaText,
  });

  final String id;
  final String title;
  final String description;
  final String? metaText;
}

class MasterDataTableLayout {
  static const double titleWidth = 220;
  static const double descriptionWidth = 140;
  static const double metaWidth = 90;
  static const double actionsWidth = 120;

  static double columnWidth(double value) => value.w;

  static double minTableWidth({bool showMetaColumn = false}) =>
      columnWidth(titleWidth) +
      columnWidth(descriptionWidth) +
      (showMetaColumn ? columnWidth(metaWidth) : 0) +
      columnWidth(actionsWidth);
}

class MasterDataManagementToolbar extends StatelessWidget {
  const MasterDataManagementToolbar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onAddPressed,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: colors.kInputColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colors.kBorderColor.withValues(alpha: 0.35),
              ),
            ),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                color: colors.kFontColor,
                fontSize: 14.sp,
                fontFamily: 'Almarai',
              ),
              decoration: InputDecoration(
                hintText: AppString.searchPlaceholder.tr(),
                hintStyle: TextStyle(
                  color: colors.kGrayColor,
                  fontSize: 14.sp,
                  fontFamily: 'Almarai',
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colors.kGrayColor,
                  size: 22.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: onAddPressed,
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: colors.kPrimaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.add_rounded,
              color: colors.kWhiteColor,
              size: 22.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class MasterDataManagementTable extends StatelessWidget {
  const MasterDataManagementTable({
    super.key,
    required this.items,
    required this.isLoading,
    required this.onEdit,
    this.onDelete,
    this.onView,
    this.showMetaColumn = false,
    this.showDelete = true,
    this.metaColumnLabelKey = AppString.isFinal,
    this.descriptionColumnLabelKey = AppString.description,
    this.viewTooltipKey = AppString.viewPlan,
  });

  final List<MasterDataItem> items;
  final bool isLoading;
  final ValueChanged<MasterDataItem> onEdit;
  final ValueChanged<MasterDataItem>? onDelete;
  final ValueChanged<MasterDataItem>? onView;
  final bool showMetaColumn;
  final bool showDelete;
  final String metaColumnLabelKey;
  final String descriptionColumnLabelKey;
  final String viewTooltipKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (items.isEmpty && !isLoading) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(vertical: 48.h),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colors.kBorderColor.withValues(alpha: 0.35),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          AppString.noRecordsFound.tr(),
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 14.sp,
            fontFamily: 'Almarai',
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final useExpandedLayout =
            constraints.maxWidth >=
            MasterDataTableLayout.minTableWidth(showMetaColumn: showMetaColumn);

        final table = Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MasterDataTableHeader(
                  colors: colors,
                  useExpandedLayout: useExpandedLayout,
                  showMetaColumn: showMetaColumn,
                  metaColumnLabelKey: metaColumnLabelKey,
                  descriptionColumnLabelKey: descriptionColumnLabelKey,
                ),
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == items.length - 1 && !isLoading;
                  return _MasterDataTableRow(
                    item: item,
                    colors: colors,
                    isLast: isLast,
                    useExpandedLayout: useExpandedLayout,
                    showMetaColumn: showMetaColumn,
                    showDelete: showDelete && onDelete != null,
                    onView: onView == null ? null : () => onView!(item),
                    viewTooltipKey: viewTooltipKey,
                    onEdit: () => onEdit(item),
                    onDelete: onDelete == null ? null : () => onDelete!(item),
                  );
                }),
              ],
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: colors.kInputColor.withValues(alpha: 0.65),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colors.kPrimaryColor,
                    ),
                  ),
                ),
              ),
          ],
        );

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: colors.kInputColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: colors.kBorderColor.withValues(alpha: 0.35),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: useExpandedLayout
              ? table
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: MasterDataTableLayout.minTableWidth(
                      showMetaColumn: showMetaColumn,
                    ),
                    child: table,
                  ),
                ),
        );
      },
    );
  }
}

class _MasterDataTableHeader extends StatelessWidget {
  const _MasterDataTableHeader({
    required this.colors,
    required this.useExpandedLayout,
    required this.showMetaColumn,
    required this.metaColumnLabelKey,
    required this.descriptionColumnLabelKey,
  });

  final AppColorScheme colors;
  final bool useExpandedLayout;
  final bool showMetaColumn;
  final String metaColumnLabelKey;
  final String descriptionColumnLabelKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.kBorderColor.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: Row(
        children: [
          _headerCell(
            flex: 4,
            width: MasterDataTableLayout.titleWidth,
            label: AppString.projectTitleLabel.tr(),
            align: TextAlign.start,
          ),
          _headerCell(
            flex: 3,
            width: MasterDataTableLayout.descriptionWidth,
            label: descriptionColumnLabelKey.tr(),
            align: TextAlign.center,
          ),
          if (showMetaColumn)
            _headerCell(
              flex: 2,
              width: MasterDataTableLayout.metaWidth,
              label: metaColumnLabelKey.tr(),
              align: TextAlign.center,
            ),
          _headerCell(
            flex: 2,
            width: MasterDataTableLayout.actionsWidth,
            label: AppString.actions.tr(),
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _headerCell({
    required int flex,
    required double width,
    required String label,
    required TextAlign align,
  }) {
    final style = TextStyle(
      color: colors.kGrayColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'Almarai',
    );

    final child = Text(label, style: style, textAlign: align);

    if (useExpandedLayout) {
      return Expanded(flex: flex, child: child);
    }

    return SizedBox(
      width: MasterDataTableLayout.columnWidth(width),
      child: child,
    );
  }
}

class _MasterDataTableRow extends StatelessWidget {
  const _MasterDataTableRow({
    required this.item,
    required this.colors,
    required this.isLast,
    required this.useExpandedLayout,
    required this.showMetaColumn,
    required this.showDelete,
    required this.viewTooltipKey,
    required this.onEdit,
    this.onDelete,
    this.onView,
  });

  final MasterDataItem item;
  final AppColorScheme colors;
  final bool isLast;
  final bool useExpandedLayout;
  final bool showMetaColumn;
  final bool showDelete;
  final String viewTooltipKey;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: colors.kBorderColor.withValues(alpha: 0.35),
                ),
              ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _titleCell(),
            _descriptionCell(),
            if (showMetaColumn) _metaCell(),
            _actionsCell(),
          ],
        ),
      ),
    );
  }

  Widget _titleCell() {
    final content = Row(
      children: [
        Container(
          width: 4.w,
          margin: EdgeInsetsDirectional.only(
            start: 8.w,
            end: 4.w,
            top: 12.h,
            bottom: 12.h,
          ),
          decoration: BoxDecoration(
            color: colors.kPrimaryColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Text(
              item.title,
              style: TextStyle(
                color: colors.kFontColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Almarai',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );

    if (useExpandedLayout) {
      return Expanded(flex: 4, child: content);
    }

    return SizedBox(
      width: MasterDataTableLayout.columnWidth(
        MasterDataTableLayout.titleWidth,
      ),
      child: content,
    );
  }

  Widget _descriptionCell() {
    final child = Center(
      child: Text(
        item.description.isEmpty ? '—' : item.description,
        style: TextStyle(
          color: colors.kGrayColor,
          fontSize: 12.sp,
          fontFamily: 'Almarai',
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (useExpandedLayout) {
      return Expanded(flex: 3, child: child);
    }

    return SizedBox(
      width: MasterDataTableLayout.columnWidth(
        MasterDataTableLayout.descriptionWidth,
      ),
      child: child,
    );
  }

  Widget _metaCell() {
    final child = Center(
      child: Text(
        item.metaText ?? '—',
        style: TextStyle(
          color: colors.kPrimaryColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Almarai',
        ),
        textAlign: TextAlign.center,
      ),
    );

    if (useExpandedLayout) {
      return Expanded(flex: 2, child: child);
    }

    return SizedBox(
      width: MasterDataTableLayout.columnWidth(MasterDataTableLayout.metaWidth),
      child: child,
    );
  }

  Widget _actionsCell() {
    final child = FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (onView != null) ...[
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: viewTooltipKey.tr(),
              onPressed: onView,
              icon: Icon(
                Icons.account_tree_outlined,
                color: colors.kPrimaryColor,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: AppString.editAction.tr(),
            onPressed: onEdit,
            icon: Icon(
              Icons.edit_outlined,
              color: colors.kGrayColor,
              size: 18.sp,
            ),
          ),
          if (showDelete && onDelete != null) ...[
            SizedBox(width: 8.w),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: AppString.delete.tr(),
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: colors.kRedColor,
                size: 18.sp,
              ),
            ),
          ],
        ],
      ),
    );

    if (useExpandedLayout) {
      return Expanded(flex: 2, child: child);
    }

    return SizedBox(
      width: MasterDataTableLayout.columnWidth(
        MasterDataTableLayout.actionsWidth,
      ),
      child: child,
    );
  }
}
