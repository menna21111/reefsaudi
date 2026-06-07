import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/global_statistics_models.dart';
import '../cubit/global_statistics_cubit.dart';
import '../widgets/custom_progress_bar.dart';
import '../widgets/saudi_statistics_map.dart';
import '../widgets/statistics_table.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GlobalStatisticsCubit>()..load(),
      child: const _StatisticsView(),
    );
  }
}

class _StatisticsView extends StatelessWidget {
  const _StatisticsView();

  String _formatMoney(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(2)}B';
    }
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    return NumberFormat('#,##0', 'en').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kInputColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppString.statistics.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.kPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<GlobalStatisticsCubit, GlobalStatisticsState>(
        builder: (context, state) {
          if (state is GlobalStatisticsLoading ||
              state is GlobalStatisticsInitial) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is GlobalStatisticsError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.kRedColor, fontSize: 14.sp),
                    ),
                    SizedBox(height: 16.h),
                    FilledButton(
                      onPressed: () =>
                          context.read<GlobalStatisticsCubit>().refresh(),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! GlobalStatisticsLoaded) {
            return const SizedBox.shrink();
          }

          final bundle = state.bundle;
          final general = bundle.general;
          final execution = bundle.execution;
          final cubit = context.read<GlobalStatisticsCubit>();

          final content = RefreshIndicator(
            onRefresh: cubit.refresh,
            color: colors.kPrimaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bundle.selectedRegionTitle != null) ...[
                    _RegionFilterBanner(title: bundle.selectedRegionTitle!),
                    SizedBox(height: 16.h),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: AppString.totalBudget.tr(),
                          value:
                              '${_formatMoney(general.totalBudget)} ${AppString.sar.tr()}',
                          valueColor: colors.kPrimaryColor,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _SummaryCard(
                          title: AppString.totalProjects.tr(),
                          value: '${general.projectsCount}',
                          valueColor: colors.kGoldColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _SectionTitle(title: AppString.regionalDistribution.tr()),
                  SizedBox(height: 12.h),
                  SaudiStatisticsMap(
                    areas: bundle.areas,
                    selectedRegionCode: bundle.selectedRegionCode,
                    onRegionSelected: cubit.selectRegion,
                    onUnknownRegionTapped: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppString.regionHasNoProjects.tr()),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  StatisticsTable(
                    columns: [
                      StatisticsTableColumn(
                        label: AppString.region.tr(),
                        flex: 3,
                      ),
                      StatisticsTableColumn(
                        label: AppString.projects.tr(),
                        flex: 1,
                      ),
                    ],
                    rows: _buildRegionalTableRows(bundle.areas, colors),
                  ),
                  SizedBox(height: 24.h),
                  _SectionTitle(title: AppString.executionSummary.tr()),
                  SizedBox(height: 12.h),
                  StatisticsTable(
                    columns: [
                      StatisticsTableColumn(
                        label: AppString.metric.tr(),
                        flex: 3,
                      ),
                      StatisticsTableColumn(
                        label: AppString.projects.tr(),
                        flex: 1,
                      ),
                      StatisticsTableColumn(
                        label: AppString.completionPercentage.tr(),
                        flex: 2,
                      ),
                    ],
                    rows: _buildExecutionTableRows(execution, colors),
                  ),
                  SizedBox(height: 24.h),
                  _SectionTitle(title: AppString.projectStatus.tr()),
                  SizedBox(height: 12.h),
                  _ProjectStatusCard(execution: execution),
                  SizedBox(height: 24.h),
                  _SectionTitle(title: AppString.performanceOverview.tr()),
                  SizedBox(height: 12.h),
                  _PerformanceCard(execution: execution, colors: colors),
                  SizedBox(height: 24.h),
                  _SectionTitle(title: AppString.financialOverview.tr()),
                  SizedBox(height: 12.h),
                  StatisticsTable(
                    columns: [
                      StatisticsTableColumn(
                        label: AppString.metric.tr(),
                        flex: 2,
                      ),
                      StatisticsTableColumn(
                        label: AppString.amount.tr(),
                        flex: 3,
                      ),
                    ],
                    rows: _buildFinancialTableRows(
                      general,
                      _formatMoney,
                      colors,
                    ),
                  ),
                  if (bundle.selectedRegionId != null) ...[
                    SizedBox(height: 24.h),
                    _SectionTitle(title: AppString.sectorDistribution.tr()),
                    SizedBox(height: 12.h),
                    StatisticsTable(
                      columns: [
                        StatisticsTableColumn(
                          label: AppString.sector.tr(),
                          flex: 3,
                        ),
                        StatisticsTableColumn(
                          label: AppString.projects.tr(),
                          flex: 1,
                        ),
                      ],
                      rows: bundle.sectors
                          .map(
                            (s) => StatisticsTableRow(
                              cells: [s.title, '${s.count}'],
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 24.h),
                    _SectionTitle(title: AppString.qualityManagement.tr()),
                    SizedBox(height: 12.h),
                    StatisticsTable(
                      columns: [
                        StatisticsTableColumn(
                          label: AppString.category.tr(),
                          flex: 3,
                        ),
                        StatisticsTableColumn(
                          label: AppString.statements.tr(),
                          flex: 1,
                        ),
                      ],
                      rows: bundle.qcTechnical
                          .map(
                            (q) => StatisticsTableRow(
                              cells: [q.category, '${q.statementsCount}'],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          );

          if (!state.isRefreshing) return content;

          return Stack(
            children: [
              content,
              Positioned.fill(
                child: Container(
                  color: colors.kBgColor.withOpacity(0.55),
                  child: Center(
                    child: CircularProgressIndicator(color: colors.kPrimaryColor),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<StatisticsTableRow> _buildRegionalTableRows(
    List<AreaProjectDto> areas,
    AppColorScheme colors,
  ) {
    final sorted = List<AreaProjectDto>.from(areas)
      ..sort((a, b) => b.count.compareTo(a.count));

    return sorted
        .map(
          (area) => StatisticsTableRow(
            cells: [area.title, '${area.count}'],
            highlightColor: area.regionCode == null
                ? colors.kGoldColor
                : colors.kWhiteColor,
          ),
        )
        .toList();
  }

  List<StatisticsTableRow> _buildExecutionTableRows(
    ProjectExecutionSummaryDto execution,
    AppColorScheme colors,
  ) {
    return [
      StatisticsTableRow(
        cells: [
          AppString.totalProjects.tr(),
          '${execution.totalProjects}',
          '100%',
        ],
      ),
      StatisticsTableRow(
        cells: [
          AppString.finished.tr(),
          '${execution.finishedProjects}',
          '${execution.finishedPercentage.toStringAsFixed(1)}%',
        ],
        highlightColor: const Color(0xFF6A8EAE),
      ),
      StatisticsTableRow(
        cells: [
          AppString.achievement95Projects.tr(),
          '${execution.achievement95Projects}',
          '${execution.achievement95Percentage.toStringAsFixed(1)}%',
        ],
        highlightColor: colors.kPrimaryColor,
      ),
      StatisticsTableRow(
        cells: [
          AppString.achievement25Projects.tr(),
          '${execution.achievement25Projects}',
          '${execution.achievement25Percentage.toStringAsFixed(1)}%',
        ],
        highlightColor: colors.kGoldColor,
      ),
      if (execution.otherProjects > 0)
        StatisticsTableRow(
          cells: [
            AppString.otherProjects.tr(),
            '${execution.otherProjects}',
            '-',
          ],
          highlightColor: colors.kRedColor,
        ),
    ];
  }

  List<StatisticsTableRow> _buildFinancialTableRows(
    GeneralStatisticsDto general,
    String Function(double) formatMoney,
    AppColorScheme colors,
  ) {
    final sar = AppString.sar.tr();
    return [
      StatisticsTableRow(
        cells: [
          AppString.totalBudget.tr(),
          '${formatMoney(general.totalBudget)} $sar',
        ],
        highlightColor: colors.kPrimaryColor,
      ),
      StatisticsTableRow(
        cells: [
          AppString.paidAmount.tr(),
          '${formatMoney(general.paidAmount)} $sar',
        ],
        highlightColor: colors.kPrimaryColor,
      ),
      StatisticsTableRow(
        cells: [
          AppString.inProgressAmount.tr(),
          '${formatMoney(general.inProgressAmount)} $sar',
        ],
        highlightColor: colors.kGoldColor,
      ),
      StatisticsTableRow(
        cells: [
          AppString.contractualBudget.tr(),
          '${formatMoney(general.contractualBudget)} $sar',
        ],
      ),
      StatisticsTableRow(
        cells: [
          AppString.remainingBudget.tr(),
          '${formatMoney(general.remaining)} $sar',
        ],
        highlightColor: colors.kRedColor,
      ),
    ];
  }
}

class _RegionFilterBanner extends StatelessWidget {
  final String title;

  const _RegionFilterBanner({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colors.kPrimaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.kPrimaryColor.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: colors.kPrimaryColor, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: colors.kWhiteColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                context.read<GlobalStatisticsCubit>().clearRegionFilter(),
            child: Text(
              AppString.allRegions.tr(),
              style: TextStyle(color: colors.kPrimaryColor, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: colors.kGrayColor, fontSize: 11.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Text(
      title,
      style: TextStyle(
        color: colors.kWhiteColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ProjectStatusCard extends StatelessWidget {
  final ProjectExecutionSummaryDto execution;

  const _ProjectStatusCard({required this.execution});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final total = execution.totalProjects > 0 ? execution.totalProjects : 1;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Row(
              children: [
                if (execution.finishedProjects > 0)
                  Expanded(
                    flex: execution.finishedProjects,
                    child: Container(
                      height: 16.h,
                      color: const Color(0xFF6A8EAE),
                    ),
                  ),
                if (execution.achievement95Projects > 0)
                  Expanded(
                    flex: execution.achievement95Projects,
                    child: Container(
                      height: 16.h,
                      color: colors.kPrimaryColor,
                    ),
                  ),
                if (execution.achievement25Projects > 0)
                  Expanded(
                    flex: execution.achievement25Projects,
                    child: Container(
                      height: 16.h,
                      color: colors.kGoldColor,
                    ),
                  ),
                if (execution.otherProjects > 0)
                  Expanded(
                    flex: execution.otherProjects,
                    child: Container(
                      height: 16.h,
                      color: colors.kRedColor.withOpacity(0.7),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 12.h,
            children: [
              _StatusLegend(
                title: AppString.finished.tr(),
                subtitle: '${execution.finishedProjects} / $total',
                color: const Color(0xFF6A8EAE),
              ),
              _StatusLegend(
                title: AppString.achievement95Projects.tr(),
                subtitle: '${execution.achievement95Projects} / $total',
                color: colors.kPrimaryColor,
              ),
              _StatusLegend(
                title: AppString.achievement25Projects.tr(),
                subtitle: '${execution.achievement25Projects} / $total',
                color: colors.kGoldColor,
              ),
              if (execution.otherProjects > 0)
                _StatusLegend(
                  title: AppString.otherProjects.tr(),
                  subtitle: '${execution.otherProjects} / $total',
                  color: colors.kRedColor,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusLegend extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _StatusLegend({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: colors.kWhiteColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(color: colors.kGrayColor, fontSize: 10.sp),
            ),
          ],
        ),
      ],
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  final ProjectExecutionSummaryDto execution;
  final AppColorScheme colors;

  const _PerformanceCard({required this.execution, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          CustomProgressBar(
            label: AppString.finishedPercentage.tr(),
            percentageText: '${execution.finishedPercentage.toStringAsFixed(1)}%',
            percentage: (execution.finishedPercentage / 100).clamp(0.0, 1.0),
            color: const Color(0xFF6A8EAE),
            backgroundColor: colors.kBorderColor.withOpacity(0.3),
            labelColor: colors.kGrayColor,
          ),
          SizedBox(height: 16.h),
          CustomProgressBar(
            label: AppString.achievement95Percentage.tr(),
            percentageText:
                '${execution.achievement95Percentage.toStringAsFixed(1)}%',
            percentage:
                (execution.achievement95Percentage / 100).clamp(0.0, 1.0),
            color: colors.kPrimaryColor,
            backgroundColor: colors.kBorderColor.withOpacity(0.3),
            labelColor: colors.kGrayColor,
          ),
          SizedBox(height: 16.h),
          CustomProgressBar(
            label: AppString.achievement25Percentage.tr(),
            percentageText:
                '${execution.achievement25Percentage.toStringAsFixed(1)}%',
            percentage:
                (execution.achievement25Percentage / 100).clamp(0.0, 1.0),
            color: colors.kGoldColor,
            backgroundColor: colors.kBorderColor.withOpacity(0.3),
            labelColor: colors.kGrayColor,
          ),
        ],
      ),
    );
  }
}
