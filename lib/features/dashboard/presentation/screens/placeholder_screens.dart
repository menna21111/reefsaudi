import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../auth/presination/screans/login_screan.dart';
import '../../../../core/blocs/theme_bloc.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';

class ProjectsPlaceholderScreen extends StatelessWidget {
  const ProjectsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        title: Text(AppString.projects.tr()),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64.sp,
              color: AppColor.kPrimaryColor,
            ),
            SizedBox(height: 16.h),
            LamaSansText(
              text: AppString.projects.tr(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.kWhiteColor,
            ),
            SizedBox(height: 8.h),
            Text(
              'صفحة المشاريع قيد التطوير'.tr(),
              style: TextStyle(
                color: AppColor.kGrayTextColor,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TasksPlaceholderScreen extends StatelessWidget {
  const TasksPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        title: Text(AppString.tasks.tr()),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt_rounded,
              size: 64.sp,
              color: AppColor.kPrimaryColor,
            ),
            SizedBox(height: 16.h),
            LamaSansText(
              text: AppString.tasks.tr(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.kWhiteColor,
            ),
            SizedBox(height: 8.h),
            Text(
              'صفحة المهام قيد التطوير'.tr(),
              style: TextStyle(
                color: AppColor.kGrayTextColor,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QualityPlaceholderScreen extends StatelessWidget {
  const QualityPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        title: Text(AppString.qualityManagement.tr()),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_outlined,
              size: 64.sp,
              color: AppColor.kPrimaryColor,
            ),
            SizedBox(height: 16.h),
            LamaSansText(
              text: AppString.qualityManagement.tr(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.kWhiteColor,
            ),
            SizedBox(height: 8.h),
            Text(
              'صفحة إدارة الجودة قيد التطوير'.tr(),
              style: TextStyle(
                color: AppColor.kGrayTextColor,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        title: Text(AppString.personalProfile.tr()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // User Avatar and info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppColor.kPrimaryColor.withOpacity(0.1),
                    child: CircleAvatar(
                      radius: 46.r,
                      backgroundImage: const NetworkImage(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=256&auto=format&fit=crop',
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'أماني نصر'.tr(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.kWhiteColor,
                    ),
                  ),
                  Text(
                    'emanny@saudi-reef.sa',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.kGrayTextColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Settings options
            _buildSettingCard(
              context: context,
              title: AppString.language.tr(),
              icon: Icons.language,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isArabic ? 'العربية' : 'English',
                    style: TextStyle(
                      color: AppColor.kPrimaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14.sp,
                    color: AppColor.kGrayTextColor,
                  ),
                ],
              ),
              onTap: () {
                if (isArabic) {
                  context.setLocale(const Locale('en'));
                } else {
                  context.setLocale(const Locale('ar'));
                }
              },
            ),
            SizedBox(height: 16.h),

            // Theme Switcher
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return _buildSettingCard(
                  context: context,
                  title: 'المظهر الداكن'.tr(),
                  icon: Icons.dark_mode_outlined,
                  trailing: Switch(
                    value: themeState.isDark,
                    activeColor: AppColor.kPrimaryColor,
                    onChanged: (val) {
                      if (val) {
                        context.read<ThemeBloc>().add(DarkThemeEvent());
                      } else {
                        context.read<ThemeBloc>().add(LightThemeEvent());
                      }
                    },
                  ),
                  onTap: () {},
                );
              },
            ),
            SizedBox(height: 16.h),

            // Sign out Button
            _buildSettingCard(
              context: context,
              title: AppString.signOut.tr(),
              icon: Icons.logout_rounded,
              iconColor: AppColor.kRedColor,
              textColor: AppColor.kRedColor,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScrean()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.kBorderColor.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: iconColor ?? AppColor.kPrimaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? AppColor.kWhiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
