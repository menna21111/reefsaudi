import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_color.dart';

class RiskMatrixWidget extends StatelessWidget {
  final int markerIndex;
  final int advancedRisksCount;
  final String? highlightTitle;

  const RiskMatrixWidget({
    super.key,
    this.markerIndex = 17,
    this.advancedRisksCount = 3,
    this.highlightTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColor.kPrimaryColor,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'مصفوفة المخاطر',
                style: TextStyle(
                  color: AppColor.kWhiteColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.h,
              childAspectRatio: 1.2,
            ),
            itemCount: 25,
            itemBuilder: (context, index) {
              final colors = _getRiskColors();
              final bool hasMarker = index == markerIndex;

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 600 + (index * 40)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[index],
                        borderRadius: BorderRadius.circular(4.r),
                        border: hasMarker
                            ? Border.all(color: AppColor.kGoldColor, width: 2)
                            : null,
                      ),
                      child: hasMarker
                          ? Center(
                              child: Icon(
                                Icons.circle,
                                color: AppColor.kGoldColor,
                                size: 8.sp,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColor.kGoldColor, size: 14.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  highlightTitle ??
                      'مصفوفة المخاطر عند شديد التأثير متوسط الاحتمالية',
                  style: TextStyle(
                    color: AppColor.kGrayTextColor,
                    fontSize: 9.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.warning, color: AppColor.kRedColor, size: 14.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'تم رصد عدد ($advancedRisksCount) مخاطر متقدمة',
                  style: TextStyle(
                    color: AppColor.kGrayTextColor,
                    fontSize: 9.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Color> _getRiskColors() {
    return [
      // Row 1 (Top) - Highest risk (Red shades)
      const Color(0xFFEF5350), const Color(0xFFE57373), const Color(0xFFEF9A9A),
      const Color(0xFFA1887F), const Color(0xFF8D6E63),

      // Row 2 - High risk (Orange/Red)
      const Color(0xFFEF5350), const Color(0xFFFF7043), const Color(0xFFFFA726),
      const Color(0xFFA1887F), const Color(0xFF8D6E63),

      // Row 3 - Medium risk (Orange/Yellow)
      const Color(0xFFFFA726), const Color(0xFFFFCA28), const Color(0xFFFFD54F),
      const Color(0xFF81C784), const Color(0xFF66BB6A),

      // Row 4 - Medium-Low risk (Green/Yellow)
      const Color(0xFFFFD54F), const Color(0xFF81C784), const Color(0xFF66BB6A),
      const Color(0xFF4DB6AC), const Color(0xFF26A69A),

      // Row 5 (Bottom) - Low risk (Green shades)
      const Color(0xFF66BB6A), const Color(0xFF4DB6AC), const Color(0xFF26A69A),
      const Color(0xFF00897B), const Color(0xFF00695C),
    ];
  }
}
