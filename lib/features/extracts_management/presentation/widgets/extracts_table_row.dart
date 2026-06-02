import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../domain/models/extract_item.dart';
import 'extract_status_badge.dart';
import 'extracts_table_data_cell.dart';

class ExtractsTableRow extends StatelessWidget {
  final ExtractItem item;
  final bool isEven;

  const ExtractsTableRow({
    super.key,
    required this.item,
    required this.isEven,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isEven
            ? (isDark 
                ? AppColor.kBackgroundColor.withOpacity(0.35)
                : AppColor.kLightSurfaceColor.withOpacity(0.5))
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          ExtractsTableDataCell(
            text: item.sector,
            flex: 2,
            align: TextAlign.right,
            fontWeight: FontWeight.bold,
          ),
          ExtractsTableDataCell(
            text: item.extractNumber,
            flex: 3,
            align: TextAlign.center,
          ),
          ExtractsTableDataCell(
            text: item.value,
            flex: 2,
            align: TextAlign.center,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          Expanded(
            flex: 2,
            child: Center(child: ExtractStatusBadge(status: item.status)),
          ),
          ExtractsTableDataCell(
            text: item.managementStatus,
            flex: 2,
            align: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
