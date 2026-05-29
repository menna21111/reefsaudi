import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

/// The full summary section at the top of the financial requirements screen.
/// It mirrors the screenshot exactly:
///   1. Big card  – إجمالي قيمة القوائم
///   2. Two small cards row – مطالبات مالية | عدد القوائم
///   3. Top-sector card – القطاع الأعلى (الفاكهة)
class FinancialSummaryCards extends StatelessWidget {
  const FinancialSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BigTotalCard(),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _ClaimsCard()),
            SizedBox(width: 12.w),
            Expanded(child: _CountCard()),
          ],
        ),
        SizedBox(height: 12.h),
        _TopSectorCard(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// 1.  إجمالي قيمة القوائم
// ─────────────────────────────────────────────────────────────────
class _BigTotalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          right: BorderSide(color: AppColor.kSecondaryColor, width: 4.w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          RobotoText(
            text: 'إجمالي قيمة القوائم',
            fontSize: 12.sp,
            color: AppColor.kGrayTextColor,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 6.h),
          // Main value
          RobotoText(
            text: 'SAR 323.1M',
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.kPrimaryColor,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 10.h),
          // Sub row: مدفوع | قيد التنفيذ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SubValue(
                label: 'قيد التنفيذ',
                value: '50.1M',
                color: AppColor.kGoldColor,
                isLtr: true,
              ),
              _SubValue(
                label: 'مدفوع',
                value: '273.0M',
                color: AppColor.kPrimaryColor,
                isLtr: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// 2a. مطالبات مالية (left small card)
// ─────────────────────────────────────────────────────────────────
class _ClaimsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RobotoText(
            text: 'مطالبات مالية',
            fontSize: 11.sp,
            color: AppColor.kGrayTextColor,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 6.h),
          // Big number in red (0 outstanding claims)
          RobotoText(
            text: '0',
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.kRedColor,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 4.h),
          // ↑ 100%
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RobotoText(
                text: '100%',
                fontSize: 11.sp,
                color: AppColor.kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.arrow_upward_rounded,
                color: AppColor.kPrimaryColor,
                size: 13.sp,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          RobotoText(
            text: 'القيمة السابقة: 323.1M',
            fontSize: 9.sp,
            color: AppColor.kGrayTextColor,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// 2b. عدد القوائم (right small card)
// ─────────────────────────────────────────────────────────────────
class _CountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RobotoText(
            text: 'عدد القوائم',
            fontSize: 11.sp,
            color: AppColor.kGrayTextColor,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 6.h),
          RobotoText(
            text: '281',
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.kWhiteColor,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 6.h),
          Divider(color: AppColor.kBorderColor.withOpacity(0.3), height: 1),
          SizedBox(height: 6.h),
          // 239 مدفوع • 42 قيد التنفيذ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RobotoText(
                text: '42 قيد التنفيذ',
                fontSize: 9.sp,
                color: AppColor.kGoldColor,
              ),
              RobotoText(
                text: '239 مدفوع',
                fontSize: 9.sp,
                color: AppColor.kPrimaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// 3.  القطاع الأعلى مطالبات مالية (الفاكهة card)
// ─────────────────────────────────────────────────────────────────
class _TopSectorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row: icon + label
          Row(
            children: [
              RobotoText(
                text: 'القطاع الأعلى مطالبات مالية',
                fontSize: 12.sp,
                color: AppColor.kGrayTextColor,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColor.kPrimaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.eco_rounded,
                  color: AppColor.kPrimaryColor,
                  size: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          // Sector name
          RobotoText(
            text: 'الفاكهة',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.kPrimaryColor,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 14.h),
          // مدفوع bar
          _BarRow(
            label: 'مدفوع',
            valueText: '47.1M SAR',
            progress: 0.82,
            barColor: AppColor.kPrimaryColor,
          ),
          SizedBox(height: 10.h),
          // قيد التنفيذ bar
          _BarRow(
            label: 'قيد التنفيذ',
            valueText: '9.0M SAR',
            progress: 0.18,
            barColor: AppColor.kGoldColor,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────
class _BarRow extends StatelessWidget {
  final String label;
  final String valueText;
  final double progress;
  final Color barColor;

  const _BarRow({
    required this.label,
    required this.valueText,
    required this.progress,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RobotoText(
              text: label,
              fontSize: 11.sp,
              color: AppColor.kGrayTextColor,
            ),
            RobotoText(
              text: valueText,
              fontSize: 12.sp,
              color: AppColor.kWhiteColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox(height: 5.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6.h,
            backgroundColor: AppColor.kBackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}

class _SubValue extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isLtr;

  const _SubValue({
    required this.label,
    required this.value,
    required this.color,
    required this.isLtr,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      RobotoText(
        text: value,
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      SizedBox(width: 4.w),
      RobotoText(text: label, fontSize: 11.sp, color: AppColor.kGrayTextColor),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: isLtr ? children.reversed.toList() : children,
    );
  }
}
