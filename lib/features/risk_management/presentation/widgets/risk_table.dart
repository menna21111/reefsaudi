import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../data/models/project_risk_models.dart';
import '../constants/risk_enums.dart';

class RiskTable extends StatelessWidget {
  const RiskTable({
    super.key,
    required this.risks,
    required this.colors,
  });

  final List<ProjectRiskDto> risks;
  final AppColorScheme colors;

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '-';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw.split('T').first;
    return DateFormat.yMMMd().format(parsed.toLocal());
  }

  static const _columnWidths = [140.0, 180.0, 90.0, 90.0, 80.0, 90.0, 90.0, 100.0];

  double get _tableWidth {
    final columns = _columnWidths.fold<double>(0, (sum, width) => sum + width.w);
    return columns + 28.w;
  }

  double _tableHeight(int rowCount) {
    const headerHeight = 44.0;
    const rowHeight = 52.0;
    return headerHeight.h + (rowCount * rowHeight.h);
  }

  @override
  Widget build(BuildContext context) {
    if (risks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 40.h),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
        ),
        child: Text(
          AppString.noData.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.kGrayColor, fontSize: 14.sp),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: _tableHeight(risks.length),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: _tableWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderRow(colors: colors, columnWidths: _columnWidths),
                ...risks.map(
                  (risk) => _DataRow(
                    risk: risk,
                    colors: colors,
                    formatDate: _formatDate,
                    columnWidths: _columnWidths,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.colors,
    required this.columnWidths,
  });

  final AppColorScheme colors;
  final List<double> columnWidths;

  @override
  Widget build(BuildContext context) {
    final labels = [
      AppString.riskTitle.tr(),
      AppString.projectName.tr(),
      AppString.region.tr(),
      AppString.riskProbability.tr(),
      AppString.riskImpact.tr(),
      AppString.riskStatusLabel.tr(),
      AppString.riskResponseLabel.tr(),
      AppString.date.tr(),
    ];

    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: colors.kDarkGrayColor.withOpacity(0.35),
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) => _cell(labels[index], columnWidths[index].w, isHeader: true),
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
    required this.risk,
    required this.colors,
    required this.formatDate,
    required this.columnWidths,
  });

  final ProjectRiskDto risk;
  final AppColorScheme colors;
  final String Function(String?) formatDate;
  final List<double> columnWidths;

  @override
  Widget build(BuildContext context) {
    final statusLabel =
        RiskEnums.labelForValue(RiskEnums.riskStatus, risk.riskStatus);
    final probabilityLabel = RiskEnums.labelForValue(
      RiskEnums.riskProbability,
      risk.riskProbability,
    );
    final impactLabel =
        RiskEnums.labelForValue(RiskEnums.riskImpact, risk.riskImpact);
    final responseLabel =
        RiskEnums.labelForValue(RiskEnums.riskResponse, risk.riskResponse);

    final values = [
      risk.title,
      risk.projectTitle ?? '-',
      risk.region ?? '-',
      probabilityLabel.tr(),
      impactLabel.tr(),
      statusLabel.tr(),
      responseLabel.tr(),
      formatDate(risk.riskDate),
    ];

    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.kBorderColor.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: List.generate(
          values.length,
          (index) => _cell(
            values[index],
            columnWidths[index].w,
            bold: index == 0,
            muted: index == values.length - 1,
          ),
        ),
      ),
    );
  }

  Widget _cell(
    String text,
    double width, {
    bool bold = false,
    bool muted = false,
  }) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: muted ? colors.kGrayColor : colors.kFontColor,
          fontSize: 11.sp,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
