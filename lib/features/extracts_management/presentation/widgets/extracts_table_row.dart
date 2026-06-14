import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';
import '../../../financial_requirements/domain/entities/financial_requirement.dart';
import '../../../financial_requirements/presentation/widgets/action_buttons.dart';
import '../../../financial_requirements/presentation/widgets/status_badge.dart';
import 'extracts_table_data_cell.dart';
import 'extracts_table_header.dart';

class ExtractsTableRow extends StatelessWidget {
  final FinancialRequirement item;
  final bool isEven;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExtractsTableRow({
    super.key,
    required this.item,
    required this.isEven,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isEven ? colors.kBgColor.withOpacity(0.35) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: colors.kBorderColor.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          ExtractsTableDataCell(
            text: item.projectName,
            width: ExtractsTableHeader.projectNameWidth.w,
            align: TextAlign.right,
            fontWeight: FontWeight.w600,
            maxLines: 2,
          ),
          ExtractsTableDataCell(
            text: item.sector,
            width: ExtractsTableHeader.sectorWidth.w,
            align: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
          ExtractsTableDataCell(
            text: item.extractNumber,
            width: ExtractsTableHeader.extractNumberWidth.w,
            align: TextAlign.center,
          ),
          ExtractsTableDataCell(
            text: item.extractValue,
            width: ExtractsTableHeader.valueWidth.w,
            align: TextAlign.center,
            color: colors.kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            width: ExtractsTableHeader.statusWidth.w,
            child: StatusBadge(label: item.extractStatus),
          ),
          SizedBox(
            width: ExtractsTableHeader.managementWidth.w,
            child: StatusBadge(label: item.projectManagementStatus),
          ),
          ExtractsTableDataCell(
            text: item.startDate,
            width: ExtractsTableHeader.dateWidth.w,
            align: TextAlign.center,
            color: colors.kGrayColor,
          ),
          ExtractsTableDataCell(
            text: item.endDate,
            width: ExtractsTableHeader.dateWidth.w,
            align: TextAlign.center,
            color: colors.kGrayColor,
          ),
          ActionButtons(onEdit: onEdit, onDelete: onDelete),
        ],
      ),
    );
  }
}
