import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/funcation.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/riyal_price.dart';
import '../../data/models/global_statistics_models.dart';
import '../cubit/global_statistics_cubit.dart';
import '../widgets/custom_progress_bar.dart';
import '../widgets/project_statistics_charts.dart';
import '../widgets/saudi_statistics_map.dart';
import '../widgets/statistics_style.dart';

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
      return '${(value / 1000000000).toStringAsFixed(1)}B';
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
        foregroundColor: colors.kFontColor,
        elevation: 0,
        centerTitle: true,
        title: RobotoText(
          text: AppString.statistics.tr(),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colors.kPrimaryColor,
        ),
      ),
      body: BlocBuilder<GlobalStatisticsCubit, GlobalStatisticsState>(
        builder: (context, state) {
          if (state is GlobalStatisticsInitial ||
              state is GlobalStatisticsLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is! GlobalStatisticsLoaded) {
            return const SizedBox.shrink();
          }

          final cubit = context.read<GlobalStatisticsCubit>();

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: cubit.refresh,
                color: colors.kPrimaryColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state.selectedRegionTitle != null) ...[
                        _RegionFilterBanner(title: state.selectedRegionTitle!),
                        SizedBox(height: 16.h),
                      ],
                      StatisticsSectionCard(
                        titleKey: AppString.generalStatistics,
                        child: _SectionBody(
                          section: state.general,
                          minHeight: 88.h,
                          builder: (general) => Row(
                            children: [
                              Expanded(
                                child: _SummaryCard(
                                  titleKey: AppString.totalBudget,
                                  value: _formatMoney(general.totalBudget),
                                  valueColor: colors.kPrimaryColor,
                                  showRiyal: true,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _SummaryCard(
                                  titleKey: AppString.totalProjects,
                                  value: '${general.projectsCount}',
                                  valueColor: colors.kGoldColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  SizedBox(height: 16.h),
                  StatisticsSectionCard(
                    titleKey: AppString.projectAreas,
                    child: _SectionBody(
                      section: state.areas,
                      minHeight: 220.h,
                      builder: (areas) => Column(
                        children: [
                          SaudiStatisticsMap(
                            areas: areas,
                            selectedRegionCode: state.selectedRegionCode,
                            onRegionSelected: cubit.selectRegion,
                            onUnknownRegionTapped: () {
                              AppFunctions.showsToast(
                                AppString.regionHasNoProjects.tr(),
                                colors.kPrimaryColor,
                                context,
                              );
                            },
                          ),
                          SizedBox(height: 16.h),
                          StatisticsRegionalBars(areas: areas),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  StatisticsSectionCard(
                    titleKey: AppString.projectSectors,
                    height: 280.h,
                    child: _SectionBody(
                      section: state.sectors,
                      builder: (sectors) =>
                          StatisticsSectorBarChart(sectors: sectors),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  StatisticsSectionCard(
                    titleKey: AppString.statisticsOnProjectStatus,
                    child: _SectionBody(
                      section: state.projectStatusCounts,
                      minHeight: 120.h,
                      builder: (items) =>
                          StatisticsProjectStatusBar(items: items),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  StatisticsSectionCard(
                    titleKey: AppString.projectStatus,
                    child: _SectionBody(
                      section: state.countByType,
                      minHeight: 180.h,
                      builder: (items) =>
                          StatisticsCountByTypePieChart(items: items),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  StatisticsSectionCard(
                    titleKey: AppString.qualityControlStatistical,
                    child: _SectionBody(
                      section: state.qcTechnical,
                      minHeight: 180.h,
                      builder: (items) =>
                          StatisticsQcDonutChart(items: items),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  StatisticsSectionCard(
                    titleKey: AppString.executionSummary,
                    child: _SectionBody(
                      section: state.execution,
                      minHeight: 140.h,
                      builder: (execution) => _ExecutionSummaryCard(
                        execution: execution,
                        colors: colors,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  StatisticsSectionCard(
                    titleKey: AppString.financialOverview,
                    child: _SectionBody(
                      section: state.general,
                      minHeight: 140.h,
                      builder: (general) => _FinancialOverview(
                        general: general,
                        formatMoney: _formatMoney,
                        colors: colors,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
              ),
              if (state.isRefreshing)
                Positioned.fill(
                  child: ColoredBox(
                    color: colors.kBgColor.withValues(alpha: 0.45),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colors.kPrimaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionBody<T> extends StatelessWidget {
  const _SectionBody({
    required this.section,
    required this.builder,
    this.minHeight,
  });

  final StatisticsSection<T> section;
  final Widget Function(T data) builder;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (section.isLoading) {
      return SizedBox(
        height: minHeight ?? 120.h,
        child: Center(
          child: CircularProgressIndicator(color: colors.kPrimaryColor),
        ),
      );
    }

    if (section.error != null) {
      return SizedBox(
        height: minHeight ?? 120.h,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              section.error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.kRedColor,
                fontSize: 12.sp,
                fontFamily: 'Almarai',
              ),
            ),
          ),
        ),
      );
    }

    final data = section.data;
    if (data == null) {
      return SizedBox(height: minHeight ?? 80.h);
    }

    return builder(data);
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
        color: colors.kPrimaryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.kPrimaryColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: colors.kPrimaryColor, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: StatisticsStyle.label(
                context,
                color: colors.kFontColor,
                size: 13,
                weight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                context.read<GlobalStatisticsCubit>().clearRegionFilter(),
            child: RobotoText(
              text: AppString.allRegions.tr(),
              fontSize: 12,
              color: colors.kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String titleKey;
  final String value;
  final Color valueColor;
  final bool showRiyal;

  const _SummaryCard({
    required this.titleKey,
    required this.value,
    required this.valueColor,
    this.showRiyal = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final valueStyle = StatisticsStyle.value(
      context,
      color: valueColor,
      size: 15,
    );

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.kBgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RobotoText(
            text: titleKey.tr(),
            fontSize: 11,
            color: colors.kGrayColor,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.h),
          if (showRiyal)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: RiyalPriceLabel(
                price: value,
                style: valueStyle,
                iconSize: 14.sp,
                iconColor: valueColor,
              ),
            )
          else
            Text(
              value,
              textAlign: TextAlign.right,
              style: valueStyle,
            ),
        ],
      ),
    );
  }
}

class _ExecutionSummaryCard extends StatelessWidget {
  final ProjectExecutionSummaryDto execution;
  final AppColorScheme colors;

  const _ExecutionSummaryCard({
    required this.execution,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomProgressBar(
          label: AppString.finishedPercentage.tr(),
          percentageText: '${execution.finishedPercentage.toStringAsFixed(1)}%',
          percentage: (execution.finishedPercentage / 100).clamp(0.0, 1.0),
          color: StatisticsStyle.statusFinished(colors),
          backgroundColor: colors.kBorderColor.withValues(alpha: 0.3),
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
          backgroundColor: colors.kBorderColor.withValues(alpha: 0.3),
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
          backgroundColor: colors.kBorderColor.withValues(alpha: 0.3),
          labelColor: colors.kGrayColor,
        ),
      ],
    );
  }
}

class _FinancialOverview extends StatelessWidget {
  final GeneralStatisticsDto general;
  final String Function(double) formatMoney;
  final AppColorScheme colors;

  const _FinancialOverview({
    required this.general,
    required this.formatMoney,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final rows = [
      (AppString.paidAmount.tr(), general.paidAmount, colors.kPrimaryColor),
      (
        AppString.inProgressAmount.tr(),
        general.inProgressAmount,
        colors.kGoldColor,
      ),
      (
        AppString.contractualBudget.tr(),
        general.contractualBudget,
        colors.kFontColor,
      ),
      (AppString.remainingBudget.tr(), general.remaining, colors.kRedColor),
    ];

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  row.$1,
                  style: StatisticsStyle.label(context, size: 12),
                ),
              ),
              RiyalPriceLabel(
                price: formatMoney(row.$2),
                iconSize: 12.sp,
                iconColor: row.$3,
                style: StatisticsStyle.value(
                  context,
                  color: row.$3,
                  size: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
