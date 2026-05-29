import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../domain/models/financial_requirement.dart';

class FinancialFilterChips extends StatelessWidget {
  final FinancialRequirementStatus selectedStatus;
  final ValueChanged<FinancialRequirementStatus> onStatusChanged;

  const FinancialFilterChips({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'key': FinancialRequirementStatus.all, 'label': 'الكل'},
      {'key': FinancialRequirementStatus.funded, 'label': 'ممول'},
      {'key': FinancialRequirementStatus.unfunded, 'label': 'غير ممول'},
      {'key': FinancialRequirementStatus.completed, 'label': 'مكتمل'},
    ];

    return SizedBox(
      height: 34.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedStatus == filter['key'];

          return Padding(
            padding: EdgeInsets.only(
              left: index == filters.length - 1 ? 0 : 6.w,
              right: index == 0 ? 0 : 6.w,
            ),
            child: GestureDetector(
              onTap: () {
                onStatusChanged(filter['key'] as FinancialRequirementStatus);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.kPrimaryColor
                      : AppColor.kSurfaceColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColor.kBorderColor.withOpacity(0.3),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.kPrimaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: RobotoText(
                    text: filter['label'] as String,
                    fontSize: 12.sp,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? AppColor.kWhiteColor
                        : AppColor.kGrayTextColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
