import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reefsaudia/core/utils/app_font.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../risk_management/data/models/project_risk_models.dart';
import '../../../risk_management/presentation/constants/risk_enums.dart';
import '../../../risk_management/presentation/widgets/risk_table.dart';
import '../cubit/project_statistics_cubit.dart';
import '../widgets/project_risk_form_sheet.dart';
import 'project_risk_detail_screen.dart';

class RisksScreen extends StatefulWidget {
  final String projectId;

  const RisksScreen({super.key, required this.projectId});

  @override
  State<RisksScreen> createState() => _RisksScreenState();
}

class _RisksScreenState extends State<RisksScreen> {
  bool isTableView = true;

  String _enumLabel(List<RiskStringOption> options, String value) {
    final key = RiskApiEnums.labelKeyFor(options, value);
    return key.isEmpty ? value : key.tr();
  }

  Color _statusColor(BuildContext context, String status) {
    final colors = context.appColorsRead;
    switch (status.toLowerCase()) {
      case 'open':
        return colors.kRedColor;
      case 'pending':
        return colors.kGoldColor;
      case 'realized':
        return colors.kGoldColor;
      case 'closed':
        return colors.kPrimaryColor;
      default:
        return colors.kGrayColor;
    }
  }

  int _countByStatus(List<ProjectRiskDto> risks, String status) {
    return risks
        .where((r) => r.riskStatus.toLowerCase() == status.toLowerCase())
        .length;
  }

  Future<void> _openDetail(ProjectRiskDto risk) async {
    final deleted = await Navigator.of(context).push<bool>(
      PageTransition(
        child: BlocProvider.value(
          value: context.read<ProjectRisksCubit>(),
          child: ProjectRiskDetailScreen(
            projectId: widget.projectId,
            riskId: risk.id,
            initialRisk: risk,
          ),
        ),
        type: PageTransitionType.rightToLeft,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 200),
      ),
    );
    if (deleted == true && mounted) {
      context.read<ProjectRisksCubit>().load(widget.projectId, silent: true);
    }
  }

  Future<void> _openForm() async {
    final created = await showProjectRiskFormSheet(context);
    if (created == true && mounted) {
      context.read<ProjectRisksCubit>().load(widget.projectId, silent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<ProjectRisksCubit, ProjectRisksState>(
      builder: (context, state) {
        if (state is ProjectRisksLoading || state is ProjectRisksInitial) {
          return Scaffold(
            backgroundColor: colors.kBgColor,
            body: Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            ),
          );
        }

        if (state is ProjectRisksError) {
          return Scaffold(
            backgroundColor: colors.kBgColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: BackButton(color: colors.kFontColor),
            ),
            body: Center(
              child: Text(
                state.message.tr(),
                style: TextStyle(color: colors.kRedColor),
              ),
            ),
          );
        }

        if (state is! ProjectRisksLoaded) {
          return const SizedBox.shrink();
        }

        final risks = state.risks;
        final isBusy = state.isSubmitting || state.isRefreshing;

        return Scaffold(
          backgroundColor: colors.kBgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(color: colors.kFontColor),
            title: RobotoText(
              text: AppString.riskManagement.tr(),
              color: colors.kFontColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
            actions: [
              if (isBusy)
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () => setState(() => isTableView = !isTableView),
                child: Container(
                  margin: EdgeInsets.only(left: 16.w),
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: colors.kInputColor,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: colors.kBorderColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Icon(
                    isTableView ? Icons.grid_view_rounded : Icons.list_rounded,
                    color: colors.kPrimaryColor,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: isBusy ? null : () => _openForm(),
            backgroundColor: colors.kRedColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Icon(Icons.add, color: colors.kFontColor, size: 28.sp),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    _buildSummaryChip(
                      context,
                      AppString.all.tr(),
                      '${risks.length}',
                      colors.kGrayColor,
                    ),
                    SizedBox(width: 8.w),
                    _buildSummaryChip(
                      context,
                      AppString.riskStatusOpen.tr(),
                      '${_countByStatus(risks, 'Open')}',
                      colors.kRedColor,
                    ),
                    SizedBox(width: 8.w),
                    _buildSummaryChip(
                      context,
                      AppString.riskStatusPending.tr(),
                      '${_countByStatus(risks, 'Pending')}',
                      colors.kGoldColor,
                    ),
                    SizedBox(width: 8.w),
                    _buildSummaryChip(
                      context,
                      AppString.riskStatusClosed.tr(),
                      '${_countByStatus(risks, 'Closed')}',
                      colors.kPrimaryColor,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: risks.isEmpty
                    ? Center(
                        child: Text(
                          AppString.noData.tr(),
                          style: TextStyle(
                            color: colors.kGrayColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      )
                    : isTableView
                        ? ListView(
                            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 88.h),
                            children: [
                              RiskTable(
                                risks: risks,
                                variant: RiskTableVariant.project,
                                onRowTap: _openDetail,
                              ),
                            ],
                          )
                        : _buildGridView(context, risks),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryChip(
    BuildContext context,
    String label,
    String count,
    Color color,
  ) {
    final colors = context.appColors;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            RobotoText(
              text: count,
              color: color,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 2.h),
            RobotoText(
              text: label,
              color: colors.kGrayColor,
              fontSize: 10.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context, List<ProjectRiskDto> risks) {
    final colors = context.appColors;

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.1,
      ),
      itemCount: risks.length,
      itemBuilder: (context, index) {
        final risk = risks[index];
        final statusColor = _statusColor(context, risk.riskStatus);
        final statusLabel =
            _enumLabel(RiskApiEnums.riskStatus, risk.riskStatus);
        final probabilityLabel = _enumLabel(
          RiskApiEnums.riskProbability,
          risk.riskProbability,
        );

        return GestureDetector(
          onTap: () => _openDetail(risk),
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: colors.kInputColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: RobotoText(
                        text: statusLabel,
                        color: statusColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.warning_amber_rounded,
                      color: statusColor,
                      size: 18.sp,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                RobotoText(
                  text: risk.title,
                  color: colors.kFontColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  maxLines: 2,
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: RobotoText(
                        text: probabilityLabel,
                        color: statusColor,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: RobotoText(
                        text: risk.ownerName ?? '-',
                        color: colors.kGrayColor,
                        fontSize: 10.sp,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
