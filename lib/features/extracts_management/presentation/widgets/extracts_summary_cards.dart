import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';
import '../../../financial_requirements/domain/entities/financial_statement_summary.dart';
import '../../domain/models/financial_requirement_mapper.dart';
import 'extracts_summary_card.dart';

class ExtractsSummaryCards extends StatelessWidget {
  const ExtractsSummaryCards({
    super.key,
    required this.countSummary,
    required this.sumSummary,
    this.isLoading = false,
  });

  final FinancialStatementSummary countSummary;
  final FinancialStatementSummary sumSummary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (isLoading) {
      return SizedBox(
        height: 140.h,
        child: Center(
          child: CircularProgressIndicator(color: colors.kPrimaryColor),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ExtractsSummaryCard(
            title: 'extracts_value'.tr(),
            mainValue: FinancialRequirementMapper.formatCompactAmount(
              sumSummary.totalAmount,
            ),
            disbursedValue: FinancialRequirementMapper.formatCompactAmount(
              sumSummary.paidAmount,
            ),
            inProcessValue: FinancialRequirementMapper.formatCompactAmount(
              sumSummary.inProgressAmount,
            ),
            inProcessColor: colors.kRedColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ExtractsSummaryCard(
            title: 'extracts_count'.tr(),
            mainValue: _formatCount(countSummary.totalAmount),
            disbursedValue: _formatCount(countSummary.paidAmount),
            inProcessValue: _formatCount(countSummary.inProgressAmount),
            inProcessColor: colors.kGoldColor,
          ),
        ),
      ],
    );
  }

  String _formatCount(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(0);
  }
}
