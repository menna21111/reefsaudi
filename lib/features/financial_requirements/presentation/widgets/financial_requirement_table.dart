import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';
import '../../domain/entities/financial_requirement.dart';
import 'table_header.dart';
import 'table_pagination_widget.dart';
import 'table_row_widget.dart';

class FinancialRequirementTable extends StatelessWidget {
  final List<FinancialRequirement> items;
  final Function(FinancialRequirement) onEdit;
  final Function(FinancialRequirement) onDelete;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final bool isPageLoading;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  const FinancialRequirementTable({
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

    return Container(
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 32.w,
              ),
              child: IntrinsicWidth(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const TableHeader(),
                        ...items.asMap().entries.map((entry) {
                          return TableRowWidget(
                            item: entry.value,
                            isEven: entry.key.isEven,
                            onEdit: () => onEdit(entry.value),
                            onDelete: () => onDelete(entry.value),
                          );
                        }),
                      ],
                    ),
                    if (isPageLoading)
                      Positioned.fill(
                        child: Container(
                          color: colors.kInputColor.withValues(alpha: 0.6),
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
          ),
          Divider(
            height: 1,
            color: colors.kBorderColor.withValues(alpha: 0.3),
          ),
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
