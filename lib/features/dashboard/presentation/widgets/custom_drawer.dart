import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../achievement_rates_management/presentation/screens/achievement_rates_management_screen.dart';
import '../../../extracts_management/presentation/screens/extracts_management_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          SizedBox(height: 80.h),
          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                _buildDrawerItem(
                  icon: Icons.trending_up_rounded,
                  title: 'إدارة نسب الإنجاز',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AchievementRatesManagementScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.receipt_long_rounded,
                  title: 'إدارة المستخلصات',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ExtractsManagementScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.verified_user_rounded,
                  title: 'ادارة الجوده',
                  onTap: () {
                    // Navigate to Quality Management
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.meeting_room_rounded,
                  title: 'ادارة الاجتماعات',
                  onTap: () {
                    // Navigate to Meetings Management
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.insert_chart_rounded,
                  title: 'البيانات الرئيسيه',
                  onTap: () {
                    // Navigate to Main Data
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.model_training_rounded,
                  title: 'بناء النماذج',
                  onTap: () {
                    // Navigate to Forms Builder
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.folder_rounded,
                  title: 'الادله الاجرائيه',
                  onTap: () {
                    // Navigate to Procedural Guides
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              'Reef Saudia',
              style: TextStyle(
                color: AppColor.kWhiteColor.withOpacity(0.5),
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColor.kSurfaceContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColor.kWhiteColor, size: 22.sp),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColor.kWhiteColor,
            fontSize: 14.sp,

            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColor.kWhiteColor.withOpacity(0.7),
          size: 16.sp,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      ),
    );
  }
}
