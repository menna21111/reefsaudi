import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../core/funcation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../project/presentation/cubit/edit_project_cubit.dart';
import '../../../project/presentation/cubit/project_statistics_cubit.dart';
import '../../../project/presentation/screens/edit_project_screen.dart';
import '../../../project/presentation/screens/project_details_screen.dart';
import '../../domain/entities/project.dart';

class TableRowWidget extends StatelessWidget {
  const TableRowWidget({
    super.key,
    required this.project,
    required this.isLast,
    required this.colors,
  });

  final Project project;
  final bool isLast;
  final AppColorScheme colors;

  Map<String, String> get _locationParts {
    return {
      'sector': project.brandTitle.isNotEmpty ? project.brandTitle : '—',
      'region': project.product.isNotEmpty ? project.product : '—',
    };
  }

  void _openDetails(BuildContext context) {
    AppFunctions.navigateTo(
      context,
      BlocProvider(
        create: (_) => sl<ProjectDetailsCubit>()..load(project.id),
        child: ProjectDetailsScreen(projectId: project.id),
      ),
      PageTransitionType.leftToRight,
    );
  }

  void _openEdit(BuildContext context) {
    AppFunctions.navigateTo(
      context,
      BlocProvider(
        create: (_) => sl<EditProjectCubit>()..loadProject(project.id),
        child: EditProjectScreen(projectId: project.id),
      ),
      PageTransitionType.leftToRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(project.status);

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: colors.kBorderColor.withValues(alpha: 0.35),
                ),
              ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProjectNameColumn(statusData),
            _buildTextColumn(_locationParts['sector']!),
            _buildTextColumn(_locationParts['region']!),
            _buildValueColumn(),
            _buildProgressColumn(statusData),
            _buildActionsColumn(context),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusData(String status) {
    switch (status) {
      case 'finished':
        return {
          'color': colors.kPrimaryColor,
          'bg': colors.kPrimaryColor.withValues(alpha: 0.12),
          'label': AppString.finished.tr(),
        };
      case 'stalled':
        return {
          'color': colors.kGoldColor,
          'bg': colors.kGoldColor.withValues(alpha: 0.12),
          'label': AppString.stalled.tr(),
        };
      default:
        return {
          'color': colors.kPrimaryColor,
          'bg': colors.kPrimaryColor.withValues(alpha: 0.08),
          'label': AppString.inProgress.tr(),
        };
    }
  }

  Widget _buildProjectNameColumn(Map<String, dynamic> statusData) {
    return SizedBox(
      width: 250.w,
      child: Row(
        children: [
          Container(
            width: 4.w,
            margin: EdgeInsetsDirectional.only(
              start: 12.w,
              end: 4.w,
              top: 12.h,
              bottom: 12.h,
            ),
            decoration: BoxDecoration(
              color: statusData['color'] as Color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                project.title,
                style: TextStyle(
                  color: colors.kFontColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextColumn(String text) {
    return SizedBox(
      width: 100.w,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: colors.kGrayColor, fontSize: 12.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildValueColumn() {
    return SizedBox(
      width: 150.w,
      child: Center(
        child: Text(
          '${NumberFormat('#,###').format(project.budget)} ${AppString.sar.tr()}',
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildProgressColumn(Map<String, dynamic> statusData) {
    final statusColor = statusData['color'] as Color;

    return SizedBox(
      width: 180.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: statusData['bg'] as Color,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                statusData['label'] as String,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${project.progress.toInt()}%',
                    style: TextStyle(
                      color: colors.kFontColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: project.progress / 100,
                      minHeight: 4.h,
                      backgroundColor: colors.kBgColor,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsColumn(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: AppString.viewDetails.tr(),
            onPressed: () => _openDetails(context),
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: colors.kPrimaryColor,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: AppString.editProject.tr(),
            onPressed: () => _openEdit(context),
            icon: Icon(
              Icons.edit_outlined,
              color: colors.kGrayColor,
              size: 18.sp,
            ),
          ),
        ],
      ),
    );
  }
}
