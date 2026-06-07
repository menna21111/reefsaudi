import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

class StatisticsTableColumn {
  final String label;
  final int flex;

  const StatisticsTableColumn({
    required this.label,
    this.flex = 1,
  });
}

class StatisticsTableRow {
  final List<String> cells;
  final Color? highlightColor;

  const StatisticsTableRow({
    required this.cells,
    this.highlightColor,
  });
}

class StatisticsTable extends StatelessWidget {
  final List<StatisticsTableColumn> columns;
  final List<StatisticsTableRow> rows;

  const StatisticsTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: colors.kDarkGrayColor.withOpacity(0.35),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: columns
                  .map(
                    (column) => Expanded(
                      flex: column.flex,
                      child: Text(
                        column.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.kGrayColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          if (rows.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 28.h),
              child: Text(
                '-',
                style: TextStyle(color: colors.kGrayColor, fontSize: 12.sp),
              ),
            )
          else
            ...rows.asMap().entries.map((entry) {
              final row = entry.value;
              final isLast = entry.key == rows.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: List.generate(columns.length, (index) {
                        final cell = index < row.cells.length
                            ? row.cells[index]
                            : '';
                        return Expanded(
                          flex: columns[index].flex,
                          child: Text(
                            cell,
                            textAlign: index == 0
                                ? TextAlign.start
                                : TextAlign.center,
                            style: TextStyle(
                              color: row.highlightColor ?? colors.kWhiteColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colors.kBorderColor.withOpacity(0.25),
                      indent: 14.w,
                      endIndent: 14.w,
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }
}
