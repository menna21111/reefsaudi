import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_risk_models.dart';
import '../cubit/risk_management_cubit.dart';
import '../widgets/add_risk_sheet.dart';
import '../widgets/risk_table.dart';

class RiskManagementScreen extends StatelessWidget {
  const RiskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RiskManagementCubit>()..load(),
      child: const _RiskManagementView(),
    );
  }
}

class _RiskManagementView extends StatefulWidget {
  const _RiskManagementView();

  @override
  State<_RiskManagementView> createState() => _RiskManagementViewState();
}

class _RiskManagementViewState extends State<_RiskManagementView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<RiskManagementCubit>().loadMore();
    }
  }

  Future<void> _openAddRiskSheet() async {
    final cubit = context.read<RiskManagementCubit>();
    await cubit.loadFormData();

    if (!mounted) return;
    final state = cubit.state;
    if (state is! RiskManagementLoaded) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddRiskSheet(
          projects: state.projects,
          accounts: state.accounts,
          isLoading: state.isFormDataLoading,
          isSubmitting: state.isSubmitting,
        ),
      ),
    );
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
          AppString.riskManagement.tr(),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddRiskSheet,
        backgroundColor: colors.kRedColor,
        icon: Icon(Icons.add, color: colors.kWhiteColor),
        label: Text(
          AppString.addRisk.tr(),
          style: TextStyle(color: colors.kWhiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<RiskManagementCubit, RiskManagementState>(
        builder: (context, state) {
          if (state is RiskManagementLoading || state is RiskManagementInitial) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is RiskManagementError) {
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
                      onPressed: () => context.read<RiskManagementCubit>().load(),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! RiskManagementLoaded) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: () => context.read<RiskManagementCubit>().refresh(),
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              children: [
                _SummaryRow(
                  colors: colors,
                  total: state.totalCount,
                  risks: state.risks,
                ),
                SizedBox(height: 16.h),
                RiskTable(risks: state.risks, colors: colors),
                if (state.isLoadingMore)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Center(
                      child: CircularProgressIndicator(color: colors.kPrimaryColor),
                    ),
                  ),
                SizedBox(height: 80.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.colors,
    required this.total,
    required this.risks,
  });

  final AppColorScheme colors;
  final int total;
  final List<ProjectRiskDto> risks;

  int _countByStatus(int status) =>
      risks.where((risk) => risk.riskStatus == status).length;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Chip(
            colors: colors,
            label: AppString.totalRecords.tr(),
            value: '$total',
            color: colors.kPrimaryColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _Chip(
            colors: colors,
            label: AppString.riskStatusOpen.tr(),
            value: '${_countByStatus(1)}',
            color: colors.kRedColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _Chip(
            colors: colors,
            label: AppString.riskStatusClosed.tr(),
            value: '${_countByStatus(2)}',
            color: colors.kGoldColor,
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.colors,
    required this.label,
    required this.value,
    required this.color,
  });

  final AppColorScheme colors;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.kGrayColor, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
