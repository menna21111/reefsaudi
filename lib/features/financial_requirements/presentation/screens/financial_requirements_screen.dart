import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../domain/entities/financial_requirement.dart';
import '../bloc/financial_requirements_bloc.dart';
import '../bloc/financial_requirements_event.dart';
import '../bloc/financial_requirements_state.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/financial_requirement_table.dart';
import '../widgets/financial_summary_cards.dart';
import '../widgets/screen_header.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/section_title.dart';
import 'financial_requirement_edit_screen.dart';

class FinancialRequirementsScreen extends StatelessWidget {
  const FinancialRequirementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<FinancialRequirementsBloc>()..add(const LoadFinancialRequirements()),
      child: const _FinancialRequirementsView(),
    );
  }
}

class _FinancialRequirementsView extends StatefulWidget {
  const _FinancialRequirementsView();

  @override
  State<_FinancialRequirementsView> createState() =>
      _FinancialRequirementsViewState();
}

class _FinancialRequirementsViewState extends State<_FinancialRequirementsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAddProject() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FinancialRequirementEditScreen(item: null),
      ),
    );
  }

  void _onEditItem(FinancialRequirement item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinancialRequirementEditScreen(item: item),
      ),
    );
  }

  void _onDeleteItem(FinancialRequirement item) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        onConfirm: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: RobotoText(
                text: AppString.deletedSuccessfully.tr(),
                fontSize: 14.sp,
                color: AppColor.kWhiteColor,
              ),
              backgroundColor: AppColor.kPrimaryColor,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<FinancialRequirementsBloc, FinancialRequirementsState>(
          builder: (context, state) {
            if (state is FinancialRequirementsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FinancialRequirementsError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RobotoText(
                        text: state.message,
                        fontSize: 14.sp,
                        color: AppColor.kWhiteColor,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () => context
                            .read<FinancialRequirementsBloc>()
                            .add(const LoadFinancialRequirements()),
                        child: RobotoText(
                          text: AppString.retry.tr(),
                          fontSize: 14.sp,
                          color: AppColor.kWhiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final loadedState = state is FinancialRequirementsLoaded
                ? state
                : null;
            final filtered = loadedState?.filteredItems ?? const [];

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                  sliver: const SliverToBoxAdapter(child: ScreenHeader()),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver:
                      const SliverToBoxAdapter(child: FinancialSummaryCards()),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverToBoxAdapter(
                    child: SectionTitle(
                      title: AppString.financialRequirements.tr(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverToBoxAdapter(
                    child: SearchBarWidget(
                      controller: _searchController,
                      onChanged: (value) => context
                          .read<FinancialRequirementsBloc>()
                          .add(SearchFinancialRequirements(value)),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 14.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppString.requirementsCount.tr(
                            namedArgs: {
                              'count':
                                  '${loadedState?.totalCount ?? filtered.length}',
                            },
                          ),
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: 12.sp,
                            color: AppColor.kGrayTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _onAddProject,
                          icon: Icon(Icons.add, size: 18.sp),
                          label: RobotoText(
                            text: AppString.addProject.tr(),
                            fontSize: 13.sp,
                            color: AppColor.kWhiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.kPrimaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                if (loadedState == null)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget(),
                  )
                else if (filtered.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget(),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverToBoxAdapter(
                      child: FinancialRequirementTable(
                        items: filtered,
                        onEdit: _onEditItem,
                        onDelete: _onDeleteItem,
                        currentPage: loadedState.pageNumber,
                        totalPages: loadedState.totalPages,
                        pageSize: loadedState.pageSize,
                        hasPreviousPage: loadedState.hasPreviousPage,
                        hasNextPage: loadedState.hasNextPage,
                        isPageLoading: loadedState.isPageLoading,
                        onPageChanged: (page) => context
                            .read<FinancialRequirementsBloc>()
                            .add(ChangeFinancialRequirementsPage(page)),
                        onPageSizeChanged: (size) => context
                            .read<FinancialRequirementsBloc>()
                            .add(ChangeFinancialRequirementsPageSize(size)),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: 90.h)),
              ],
            );
          },
        ),
      ),
    );
  }
}
