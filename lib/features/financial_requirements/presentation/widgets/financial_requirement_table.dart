import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../domain/models/financial_requirement.dart';

class FinancialRequirementTable extends StatelessWidget {
  final List<FinancialRequirement> items;

  const FinancialRequirementTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          ...items.asMap().entries.map((entry) {
            return _buildRow(entry.value, isEven: entry.key.isEven);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColor.kBorderLight.withOpacity(0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          _headerCell('المتطلب', flex: 3, align: TextAlign.right),
          _headerCell('القيمة', flex: 2, align: TextAlign.center),
          _headerCell('التاريخ', flex: 2, align: TextAlign.center),
          _headerCell('الحالة', flex: 2, align: TextAlign.center),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {required int flex, TextAlign align = TextAlign.center}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: AppColor.kGrayTextColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }

  Widget _buildRow(FinancialRequirement item, {required bool isEven}) {
    final statusData = _getStatusData(item.status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isEven
            ? AppColor.kBackgroundColor.withOpacity(0.3)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: AppColor.kBorderColor.withOpacity(0.15),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Project name
          Expanded(
            flex: 3,
            child: Text(
              item.projectName,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColor.kWhiteColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Almarai',
              ),
            ),
          ),
          // Amount
          Expanded(
            flex: 2,
            child: Text(
              '${item.amount}\nSAR',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.kPrimaryColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Almarai',
              ),
            ),
          ),
          // Date
          Expanded(
            flex: 2,
            child: Text(
              item.date,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.kGrayTextColor,
                fontSize: 10.sp,
                fontFamily: 'Almarai',
              ),
            ),
          ),
          // Status
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: (statusData['color'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  statusData['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: statusData['color'] as Color,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusData(FinancialRequirementStatus status) {
    switch (status) {
      case FinancialRequirementStatus.funded:
        return {'color': AppColor.kPrimaryColor, 'label': 'ممول'};
      case FinancialRequirementStatus.unfunded:
        return {'color': AppColor.kGoldColor, 'label': 'غير ممول'};
      case FinancialRequirementStatus.completed:
        return {'color': Colors.cyan, 'label': 'مكتمل'};
      default:
        return {'color': AppColor.kGrayTextColor, 'label': 'الكل'};
    }
  }
}
