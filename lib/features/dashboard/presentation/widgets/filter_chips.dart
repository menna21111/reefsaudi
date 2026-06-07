import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class FilterChipsSection extends StatelessWidget {
  const FilterChipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        var selectedStatus = 'all';
        if (state is DashboardStatsLoaded) {
          selectedStatus = state.selectedStatus;
        }

        final statuses = [
          {'key': 'all', 'label': AppString.all.tr()},
          {'key': 'in_progress', 'label': AppString.inProgress.tr()},
          {'key': 'stalled', 'label': AppString.stalled.tr()},
          {'key': 'finished', 'label': AppString.finished.tr()},
        ];

        return SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: statuses.length,
            itemBuilder: (context, index) {
              final status = statuses[index];
              final isSelected = selectedStatus == status['key'];

              return Padding(
                padding: EdgeInsets.only(
                  left: index == statuses.length - 1 ? 0 : 4.w,
                  right: index == 0 ? 0 : 4.w,
                ),
                child: GestureDetector(
                  onTap: () {
                    context.read<DashboardBloc>().add(
                          FilterProjects(status['key']!),
                        );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.kPrimaryColor
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : colors.kBorderColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: RobotoText(
                        text: status['label']!,
                        fontSize: 12.sp,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : colors.kGrayColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
