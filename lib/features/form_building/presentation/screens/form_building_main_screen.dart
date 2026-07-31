import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../domain/models/form_building_module.dart';
import '../form_building_screen_factory.dart';

class FormBuildingMainScreen extends StatelessWidget {
  const FormBuildingMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final modules = FormBuildingModule.mainScreenModules;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kInputColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppString.mainData.tr(),
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
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: modules.length,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final module = modules[index];
          return _ModuleCard(
            title: module.titleKey.tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FormBuildingScreenFactory.build(module),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.kInputColor,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: colors.kBorderColor.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.article_outlined,
                color: colors.kPrimaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colors.kFontColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_left_rounded,
                color: colors.kGrayColor,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
