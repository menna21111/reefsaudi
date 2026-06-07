import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_api_models.dart';
import '../cubit/project_statistics_cubit.dart';
import '../widgets/cash_flow_widget.dart';
import '../widgets/execution_rate_chart_widget.dart';
import '../widgets/executive_summary_widget.dart';
import '../widgets/financial_data_widget.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/project_details_widget.dart';
import '../widgets/project_header_widget.dart';
import '../widgets/project_stages_widget.dart';
import '../widgets/risk_matrix_widget.dart';

class ProjectStatisticsScreen extends StatefulWidget {
  final String projectId;

  const ProjectStatisticsScreen({super.key, required this.projectId});

  @override
  State<ProjectStatisticsScreen> createState() =>
      _ProjectStatisticsScreenState();
}

class _ProjectStatisticsScreenState extends State<ProjectStatisticsScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      10,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      ),
    );
    _animations = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOutCubic))
        .toList();
    _startAnimations();
  }

  void _startAnimations() async {
    for (var i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocProvider(
      create: (_) =>
          sl<ProjectStatisticsCubit>()..load(widget.projectId),
      child: Scaffold(
        backgroundColor: colors.kBgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: colors.kPrimaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<ProjectStatisticsCubit, ProjectStatisticsState>(
          builder: (context, state) {
            if (state is ProjectStatisticsLoading ||
                state is ProjectStatisticsInitial) {
              return Center(
                child: CircularProgressIndicator(color: colors.kPrimaryColor),
              );
            }
            if (state is ProjectStatisticsError) {
              return Center(
                child: Text(
                  state.message.tr(),
                  style: TextStyle(color: colors.kRedColor, fontSize: 16.sp),
                ),
              );
            }
            if (state is! ProjectStatisticsLoaded) {
              return const SizedBox.shrink();
            }

            final bundle = state.bundle;
            final data = bundle.projectData;
            final summary = bundle.executiveSummary;
            final statements = bundle.statements;
            final achievementValues =
                bundle.achievement.map((e) => e.actual.toDouble()).toList();
            final plannedValues =
                bundle.achievement.map((e) => e.planned.toDouble()).toList();
            final topRisk = bundle.risks.isNotEmpty ? bundle.risks.first : null;
            final advancedRisks =
                bundle.risks.where((r) => r.score >= 12).length;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimatedSection(
                    0,
                    ProjectHeaderWidget(
                      category: data.categoryLabel,
                      title: data.projectTitle,
                      status: data.stepTitle,
                      daysRunning: data.finesidDuration,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    1,
                    ProgressIndicatorWidget(
                      progress: summary.completionPercent / 100,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    2,
                    ExecutiveSummaryWidget(
                      summary: summary.executiveSummary?.trim().isNotEmpty == true
                          ? summary.executiveSummary!
                          : summary.achievementTitle,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    3,
                    ProjectStagesWidget(
                      stages: bundle.stages
                          .map(
                            (stage) => StageData(
                              label: stage.title,
                              progress: stage.progressRatio,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    4,
                    ProjectDetailsWidget(
                      status: data.stepStatus,
                      statusColor: 'primary',
                      completionRate: '${summary.completionPercent.toStringAsFixed(1)}%',
                      responsibleParty: data.consultantTitle,
                      startDate: formatApiDate(data.startDate),
                      endDate: formatApiDate(data.endDate),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    5,
                    FinancialDataWidget(
                      totalBudget: statements.budget / 1000000,
                      actualExpenses: statements.disbursedAmount / 1000000,
                      remaining: statements.remainingBudget / 1000000,
                      budgetStatus: statements.pendingAmount > 0
                          ? AppString.delayed.tr()
                          : AppString.inProgress.tr(),
                      budgetStatusColor:
                          statements.pendingAmount > 0 ? 'red' : 'primary',
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    6,
                    RiskMatrixWidget(
                      markerIndex: topRisk?.matrixIndex ?? 0,
                      advancedRisksCount: advancedRisks,
                      highlightTitle: topRisk?.title,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    7,
                    ExecutionRateChartWidget(
                      actualPoints: achievementValues,
                      plannedPoints: plannedValues,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    8,
                    CashFlowWidget(
                      line1Data: achievementValues,
                      line2Data: plannedValues,
                      line3Data: achievementValues
                          .map((v) => v * 0.8)
                          .toList(growable: false),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildAnimatedSection(
                    9,
                    _QcSummaryCard(
                      technical: bundle.qcTechnical,
                      acceptedWork: bundle.qcAcceptedWork,
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(int index, Widget child) {
    return FadeTransition(
      opacity: _animations[index],
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_animations[index]),
        child: child,
      ),
    );
  }
}

class _QcSummaryCard extends StatelessWidget {
  const _QcSummaryCard({
    required this.technical,
    required this.acceptedWork,
  });

  final List<QcCategoryDto> technical;
  final List<QcCategoryDto> acceptedWork;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.qualityManagement.tr(),
            style: TextStyle(
              color: colors.kFontColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          ...technical.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.category} (${AppString.qualityManagement.tr()})',
                      style: TextStyle(color: colors.kGrayColor, fontSize: 11.sp),
                    ),
                  ),
                  Text(
                    '${item.statementsCount}',
                    style: TextStyle(
                      color: colors.kFontColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          ...acceptedWork.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.category} (${AppString.delivered.tr()})',
                      style: TextStyle(color: colors.kGrayColor, fontSize: 11.sp),
                    ),
                  ),
                  Text(
                    '${item.statementsCount}',
                    style: TextStyle(
                      color: colors.kFontColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
