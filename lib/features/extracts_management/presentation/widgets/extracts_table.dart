import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class ExtractsTable extends StatelessWidget {
  const ExtractsTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          _buildTableRow('الفاكهة', 'EXT-2024-001', '12.4M', 'مكتمل', 'معتمد', isEven: false),
          _buildTableRow('الخضروات', 'EXT-2024-015', '1.2M', 'قيد المراجعة', 'تحت الإجراء', isEven: true),
          _buildTableRow('التمور', 'EXT-2024-042', '8.8M', 'متأخر', 'مرفوض', isEven: false),
          _buildTableRow('الماشية', 'EXT-2024-089', '15.1M', 'مكتمل', 'معتمد', isEven: true),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.kBorderLight.withOpacity(0.5),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('القطاع', style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 12.sp), textAlign: TextAlign.right)),
          Expanded(child: Text('رقم المستخلص', style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 12.sp), textAlign: TextAlign.center)),
          Expanded(child: Text('القيمة', style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 12.sp), textAlign: TextAlign.center)),
          Expanded(child: Text('الحالة', style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 12.sp), textAlign: TextAlign.center)),
          Expanded(child: Text('إدارة المستخلص', style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 12.sp), textAlign: TextAlign.left)),
        ],
      ),
    );
  }

  Widget _buildTableRow(String sector, String extractNo, String value, String status, String management, {required bool isEven}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isEven ? AppColor.kBackgroundColor.withOpacity(0.3) : Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(sector, style: TextStyle(color: AppColor.kWhiteColor, fontSize: 12.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
          Expanded(child: Text(extractNo, style: TextStyle(color: AppColor.kWhiteColor, fontSize: 12.sp), textAlign: TextAlign.center)),
          Expanded(child: Text(value, style: TextStyle(color: AppColor.kPrimaryColor, fontSize: 12.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          Expanded(child: Center(child: _buildStatusPill(status))),
          Expanded(child: Text(management, style: TextStyle(color: AppColor.kWhiteColor, fontSize: 12.sp), textAlign: TextAlign.left)),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bgColor;
    Color textColor;

    if (status == 'مكتمل') {
      bgColor = AppColor.kPrimaryColor.withOpacity(0.2);
      textColor = AppColor.kPrimaryColor;
    } else if (status == 'قيد المراجعة') {
      bgColor = AppColor.kGoldColor.withOpacity(0.2);
      textColor = AppColor.kGoldColor;
    } else {
      bgColor = AppColor.kRedColor.withOpacity(0.2);
      textColor = AppColor.kRedColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        status,
        style: TextStyle(color: textColor, fontSize: 10.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
