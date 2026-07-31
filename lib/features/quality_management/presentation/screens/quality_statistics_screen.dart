import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/utils/enums.dart';
import '../constants/request_type_config.dart';
import '../cubit/quality_management_cubit.dart';
import '../widgets/quality_filter_header.dart';
import '../widgets/quality_statistics_cards.dart';

class QualityStatisticsScreen extends StatelessWidget {
  const QualityStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QualityManagementCubit>()..loadStatistics(),
      child: const _QualityStatisticsView(),
    );
  }
}

class _QualityStatisticsView extends StatelessWidget {
  const _QualityStatisticsView();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kBgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.kFontColor),
        title: Text(
          AppString.qualityStatistics.tr(),
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
      ),
      body: BlocBuilder<QualityManagementCubit, QualityManagementState>(
        builder: (context, state) {
          if (state.statisticsStatus == RequestStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state.statisticsStatus == RequestStatus.error) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.statisticsError.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.kFontColor,
                        fontSize: 14.sp,
                        fontFamily: 'Almarai',
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FilledButton(
                      onPressed: () => context
                          .read<QualityManagementCubit>()
                          .loadStatistics(),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.statisticsStatus != RequestStatus.success) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: () => context.read<QualityManagementCubit>().loadStatistics(
                  approvalStatus: state.statisticsApprovalStatus,
                ),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              children: [
              //   QualityFilterHeader(
              //     options: StatisticsStatusFilter.options,
              //     selectedStatus: state.statisticsApprovalStatus ??
              //         StatisticsStatusFilter.all,
              //     onChanged: (value) => context
              //         .read<QualityManagementCubit>()
              //         .loadStatistics(approvalStatus: value),
              //   ),
              //   SizedBox(height: 14.h),
                QualityStatisticsSummaryCard(
                  total: state.statisticsProcessedTotal,
                ),
                SizedBox(height: 16.h),
                ...state.statisticsItems.map(
                  (item) => QualityStatisticsTypeCard(item: item),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
