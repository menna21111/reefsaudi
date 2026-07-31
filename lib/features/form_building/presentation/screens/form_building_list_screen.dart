import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../domain/models/form_building_item.dart';
import '../../domain/models/form_building_module.dart';
import '../cubit/form_building_list_cubit.dart';

class FormBuildingListScreen extends StatelessWidget {
  const FormBuildingListScreen({super.key, required this.module});

  final FormBuildingModule module;

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
          module.titleKey.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.kPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<FormBuildingListCubit, FormBuildingListState>(
        builder: (context, state) {
          if (state is FormBuildingListLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is FormBuildingListError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.kRedColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FilledButton(
                      onPressed: () =>
                          context.read<FormBuildingListCubit>().load(),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! FormBuildingListLoaded) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: () => context.read<FormBuildingListCubit>().refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              children: [
                _SummaryCard(totalCount: state.totalCount),
                SizedBox(height: 14.h),
                if (state.items.isEmpty)
                  _EmptyState()
                else
                  ...state.items.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _FormBuildingListTile(item: item),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.totalCount});

  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.kPrimaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.kPrimaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            '$totalCount',
            style: TextStyle(
              color: colors.kPrimaryColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            AppString.totalRecords.tr(),
            style: TextStyle(color: colors.kGrayColor, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 48.h),
      alignment: Alignment.center,
      child: Text(
        AppString.noRecordsFound.tr(),
        style: TextStyle(color: colors.kGrayColor, fontSize: 14.sp),
      ),
    );
  }
}

class _FormBuildingListTile extends StatelessWidget {
  const _FormBuildingListTile({required this.item});

  final FormBuildingItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: colors.kPrimaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.label_outline_rounded,
              color: colors.kPrimaryColor,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: colors.kFontColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    item.subtitle!,
                    style: TextStyle(color: colors.kGrayColor, fontSize: 12.sp),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
