import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/permissions/app_permissions.dart';
import '../../../../core/permissions/permission_gate.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../domain/models/achievement_month_record.dart';
import '../widgets/achievement_curve_section.dart';
import '../widgets/achievement_monthly_log_header.dart';
import '../widgets/achievement_monthly_records_list.dart';
import '../widgets/achievement_pagination.dart';
import '../widgets/achievement_rates_app_bar.dart';
import '../widgets/achievement_status_summary_card.dart';

class AchievementRatesManagementScreen extends StatefulWidget {
  const AchievementRatesManagementScreen({super.key});

  @override
  State<AchievementRatesManagementScreen> createState() =>
      _AchievementRatesManagementScreenState();
}

class _AchievementRatesManagementScreenState
    extends State<AchievementRatesManagementScreen> {
  int _currentPage = 1;
  static const int _totalPages = 3;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return PermissionGate(
      permission: AppPermissions.projectAchievementManualView,
      allowAdmin: true,
      fallback: Scaffold(
        backgroundColor: colors.kBgColor,
        body: Center(
          child: Text(
            AppString.noPermission.tr(),
            style: TextStyle(color: colors.kFontColor, fontSize: 16.sp),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                sliver: const SliverToBoxAdapter(
                  child: AchievementRatesAppBar(),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: const SliverToBoxAdapter(
                  child: AchievementStatusSummaryCard(),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 24.h)),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: const SliverToBoxAdapter(
                  child: AchievementMonthlyLogHeader(),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 14.h)),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: const SliverToBoxAdapter(
                  child: AchievementMonthlyRecordsList(
                    records: mockAchievementMonthRecords,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(
                child: AchievementPagination(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                  },
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 28.h)),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: const SliverToBoxAdapter(
                  child: AchievementCurveSection(),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 32.h)),
            ],
          ),
        ),
      ),
    );
  }
}
