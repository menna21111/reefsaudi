import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';
import '../../../financial_requirements/domain/entities/financial_requirement.dart';
import '../../../financial_requirements/presentation/widgets/table_pagination_widget.dart';
import 'extracts_table_empty_state.dart';
import 'extracts_table_header.dart';
import 'extracts_table_row.dart';

class ExtractsTable extends StatelessWidget {
  static final double tableMinWidth = ExtractsTableHeader.totalWidth;

  final List<FinancialRequirement> items;
  final void Function(FinancialRequirement item) onEdit;
  final void Function(FinancialRequirement item) onDelete;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final bool isPageLoading;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  const ExtractsTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.isPageLoading,
    required this.onPageChanged,
    required this.onPageSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (items.isEmpty) {
      return const ExtractsTableEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: tableMinWidth.w),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const ExtractsTableHeader(),
                      ...items.asMap().entries.map(
                        (entry) => ExtractsTableRow(
                          item: entry.value,
                          isEven: entry.key.isEven,
                          onEdit: () => onEdit(entry.value),
                          onDelete: () => onDelete(entry.value),
                        ),
                      ),
                    ],
                  ),
                  if (isPageLoading)
                    Positioned.fill(
                      child: Container(
                        color: colors.kInputColor.withOpacity(0.6),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colors.kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: colors.kBorderColor.withOpacity(0.3)),
          TablePaginationWidget(
            currentPage: currentPage,
            totalPages: totalPages,
            pageSize: pageSize,
            totalCount: totalCount,
            hasPreviousPage: hasPreviousPage,
            hasNextPage: hasNextPage,
            isLoading: isPageLoading,
            onPageChanged: onPageChanged,
            onPageSizeChanged: onPageSizeChanged,
          ),
        ],
      ),
    );
  }
}
