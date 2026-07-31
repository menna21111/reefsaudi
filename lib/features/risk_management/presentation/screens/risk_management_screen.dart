import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/funcation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/master_data_management_table.dart';
import '../../../financial_requirements/presentation/widgets/delete_confirmation_dialog.dart';
import '../../data/models/project_risk_models.dart';
import '../cubit/risk_management_cubit.dart';
import '../widgets/risk_table.dart';
import 'risk_add_screen.dart';

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
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
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

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      context.read<RiskManagementCubit>().search(value);
    });
  }

  Future<void> _openAddRiskSheet() async {
    final cubit = context.read<RiskManagementCubit>();
    if (cubit.state is! RiskManagementLoaded) return;

    final created = await Navigator.push<bool>(
      context,
      RiskAddScreen.route(cubit),
    );
    if (created == true && mounted) {
      await cubit.refresh();
    }
  }

  Future<void> _openEditRisk(ProjectRiskDto risk) async {
    final cubit = context.read<RiskManagementCubit>();
    final updated = await Navigator.push<bool>(
      context,
      RiskAddScreen.route(cubit, initial: risk),
    );
    if (updated == true && mounted) {
      await cubit.refresh();
    }
  }

  Future<void> _deleteRisk(ProjectRiskDto risk) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteConfirmationDialog(
        messageKey: AppString.deleteRiskConfirmation,
      ),
    );
    if (!mounted || confirmed != true) return;

    final success =
        await context.read<RiskManagementCubit>().deleteRisk(risk.id);
    if (!mounted) return;

    if (success) {
      AppFunctions.showSuccessToast(
        context,
        AppString.deletedSuccessfully.tr(),
      );
    } else {
      AppFunctions.showsToast(
        AppString.unKnownError.tr(),
        context.appColorsRead.kRedColor,
        context,
      );
    }
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
        heroTag: 'risk_management_fab',
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
                MasterDataManagementToolbar(
                  searchController: _searchController,
                  onSearchChanged: _onSearchChanged,
                  onAddPressed: state.isSubmitting ? () {} : _openAddRiskSheet,
                ),
                SizedBox(height: 16.h),
                _SummaryRow(
                  colors: colors,
                  total: state.totalCount,
                  risks: state.risks,
                ),
                SizedBox(height: 16.h),
                RiskTable(
                  risks: state.risks,
                  onEdit: state.isSubmitting ? null : _openEditRisk,
                  onDelete: state.isSubmitting ? null : _deleteRisk,
                ),
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

  int _countByStatus(String status) => risks
      .where((risk) => risk.riskStatus.toLowerCase() == status.toLowerCase())
      .length;

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
            value: '${_countByStatus('Open')}',
            color: colors.kRedColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _Chip(
            colors: colors,
            label: AppString.riskStatusClosed.tr(),
            value: '${_countByStatus('Closed')}',
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
