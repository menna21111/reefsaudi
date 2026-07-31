import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_risk_models.dart';
import '../constants/risk_enums.dart';

/// Visual variants for risk tables.
enum RiskTableVariant {
  /// Global risk management: project + region + response + edit/delete.
  management,

  /// Project-scoped risks: owner + row tap (chevron).
  project,
}

/// Risk data table styled like [FinancialRequirementTable].
class RiskTable extends StatelessWidget {
  const RiskTable({
    super.key,
    required this.risks,
    this.variant = RiskTableVariant.management,
    this.onEdit,
    this.onDelete,
    this.onRowTap,
  });

  final List<ProjectRiskDto> risks;
  final RiskTableVariant variant;
  final ValueChanged<ProjectRiskDto>? onEdit;
  final ValueChanged<ProjectRiskDto>? onDelete;
  final ValueChanged<ProjectRiskDto>? onRowTap;

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '-';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw.split('T').first;
    return DateFormat.yMMMd().format(parsed.toLocal());
  }

  String _label(List<RiskStringOption> options, String? value) {
    final key = RiskEnums.labelForValue(options, value);
    if (key.isEmpty) return '-';
    return key.tr();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (risks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 40.h),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
        ),
        child: Text(
          AppString.noData.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 14.sp,
            fontFamily: 'Almarai',
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 32.w,
          ),
          child: IntrinsicWidth(
            child: Column(
              children: [
                _RiskTableHeader(variant: variant),
                ...risks.asMap().entries.map((entry) {
                  return _RiskTableRow(
                    risk: entry.value,
                    isEven: entry.key.isEven,
                    variant: variant,
                    formatDate: _formatDate,
                    label: _label,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    onRowTap: onRowTap,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RiskTableHeader extends StatelessWidget {
  const _RiskTableHeader({required this.variant});

  final RiskTableVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isProject = variant == RiskTableVariant.project;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.kBorderColor.withValues(alpha: 0.35),
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(16.r),
          topEnd: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          _headerCell(
            colors,
            AppString.riskTitle.tr(),
            width: 200.w,
            align: TextAlign.start,
          ),
          if (!isProject) ...[
            _headerCell(
              colors,
              AppString.projectName.tr(),
              width: 180.w,
              align: TextAlign.start,
            ),
            _headerCell(colors, AppString.region.tr(), width: 100.w),
          ],
          _headerCell(colors, AppString.riskProbability.tr(), width: 120.w),
          _headerCell(colors, AppString.riskImpact.tr(), width: 110.w),
          _headerCell(colors, AppString.riskStatusLabel.tr(), width: 110.w),
          if (!isProject)
            _headerCell(colors, AppString.riskResponseLabel.tr(), width: 110.w),
          _headerCell(
            colors,
            AppString.contingencyPlan.tr(),
            width: 160.w,
            align: TextAlign.start,
          ),
          if (isProject)
            _headerCell(colors, AppString.projectOwner.tr(), width: 130.w),
          _headerCell(colors, AppString.date.tr(), width: 110.w),
          _headerCell(colors, '', width: 80.w),
        ],
      ),
    );
  }

  Widget _headerCell(
    AppColorScheme colors,
    String text, {
    required double width,
    TextAlign align = TextAlign.center,
  }) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: align,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: colors.kGrayColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }
}

class _RiskTableRow extends StatelessWidget {
  const _RiskTableRow({
    required this.risk,
    required this.isEven,
    required this.variant,
    required this.formatDate,
    required this.label,
    this.onEdit,
    this.onDelete,
    this.onRowTap,
  });

  final ProjectRiskDto risk;
  final bool isEven;
  final RiskTableVariant variant;
  final String Function(String?) formatDate;
  final String Function(List<RiskStringOption>, String?) label;
  final ValueChanged<ProjectRiskDto>? onEdit;
  final ValueChanged<ProjectRiskDto>? onDelete;
  final ValueChanged<ProjectRiskDto>? onRowTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isProject = variant == RiskTableVariant.project;
    final statusLabel = label(RiskEnums.riskStatus, risk.riskStatus);
    final probabilityLabel =
        label(RiskEnums.riskProbability, risk.riskProbability);
    final impactLabel = label(RiskEnums.riskImpact, risk.riskImpact);
    final responseLabel = label(RiskEnums.riskResponse, risk.riskResponse);

    final row = Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isEven
            ? colors.kBgColor.withValues(alpha: 0.35)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: colors.kBorderColor.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          _titleCell(colors, risk.title, risk.riskStatus),
          if (!isProject) ...[
            _textCell(
              risk.projectTitle ?? '-',
              180.w,
              colors.kFontColor,
              12.sp,
              align: TextAlign.start,
              bold: true,
            ),
            _textCell(risk.region ?? '-', 100.w, colors.kGrayColor, 11.sp),
          ],
          _badgeCell(
            probabilityLabel,
            120.w,
            _toneForProbability(colors, risk.riskProbability),
          ),
          _badgeCell(
            impactLabel,
            110.w,
            _toneForImpact(colors, risk.riskImpact),
          ),
          _badgeCell(
            statusLabel,
            110.w,
            _toneForStatus(colors, risk.riskStatus),
          ),
          if (!isProject)
            _badgeCell(responseLabel, 110.w, colors.kGrayColor),
          _textCell(
            risk.contingencyPlan.isNotEmpty ? risk.contingencyPlan : '-',
            160.w,
            colors.kGrayColor,
            11.sp,
            align: TextAlign.start,
          ),
          if (isProject)
            _textCell(
              risk.ownerName ?? '-',
              130.w,
              colors.kGrayColor,
              11.sp,
            ),
          _textCell(
            formatDate(risk.riskDate),
            110.w,
            colors.kGrayColor,
            10.sp,
          ),
          _actionsCell(colors, isProject: isProject),
        ],
      ),
    );

    if (onRowTap == null) return row;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onRowTap!(risk),
        child: row,
      ),
    );
  }

  Widget _titleCell(AppColorScheme colors, String title, String status) {
    final tone = _toneForStatus(colors, status);
    return SizedBox(
      width: 200.w,
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 28.h,
            margin: EdgeInsetsDirectional.only(end: 8.w),
            decoration: BoxDecoration(
              color: tone,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.kFontColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Almarai',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textCell(
    String text,
    double width,
    Color color,
    double size, {
    TextAlign align = TextAlign.center,
    bool bold = false,
  }) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: align,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }

  Widget _badgeCell(String text, double width, Color color) {
    return SizedBox(
      width: width,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Almarai',
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionsCell(AppColorScheme colors, {required bool isProject}) {
    if (isProject) {
      return SizedBox(
        width: 80.w,
        child: Icon(
          Icons.chevron_left_rounded,
          color: colors.kGrayColor,
          size: 20.sp,
        ),
      );
    }

    return SizedBox(
      width: 80.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (onEdit != null) ...[
            _actionButton(
              icon: Icons.edit_outlined,
              color: colors.kPrimaryColor,
              onTap: () => onEdit!(risk),
            ),
            SizedBox(width: 8.w),
          ],
          if (onDelete != null)
            _actionButton(
              icon: Icons.delete_outline,
              color: colors.kRedColor,
              onTap: () => onDelete!(risk),
            ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(icon, size: 16.sp, color: color),
      ),
    );
  }

  Color _toneForStatus(AppColorScheme colors, String status) {
    switch (status.trim().toLowerCase()) {
      case 'open':
        return colors.kRedColor;
      case 'pending':
      case 'realized':
        return colors.kGoldColor;
      case 'closed':
        return colors.kPrimaryColor;
      default:
        return colors.kGrayColor;
    }
  }

  Color _toneForProbability(AppColorScheme colors, String value) {
    final v = value.trim().toLowerCase();
    if (v.contains('verylikely') || v.contains('likely')) {
      return colors.kRedColor;
    }
    if (v.contains('may')) return colors.kGoldColor;
    if (v.contains('unlikely') || v.contains('verylow')) {
      return colors.kPrimaryColor;
    }
    return colors.kGrayColor;
  }

  Color _toneForImpact(AppColorScheme colors, String value) {
    final v = value.trim().toLowerCase();
    if (v.contains('certain') || v.contains('likely')) {
      return colors.kRedColor;
    }
    if (v.contains('moderate')) return colors.kGoldColor;
    if (v.contains('unlikely') || v.contains('rare')) {
      return colors.kPrimaryColor;
    }
    return colors.kGrayColor;
  }
}
