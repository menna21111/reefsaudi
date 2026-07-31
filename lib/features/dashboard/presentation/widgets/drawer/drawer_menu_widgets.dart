import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/permissions/permission_cubit.dart';
import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';

typedef DrawerNavigate = void Function(BuildContext context);

class DrawerMenuEntry {
  const DrawerMenuEntry({
    required this.titleKey,
    required this.onTap,
    this.permission,
    this.anyOfPermissions,
    this.visibleToAdmin = false,
  });

  final String titleKey;
  final DrawerNavigate onTap;

  /// Single required permission. Null = always visible.
  final String? permission;

  /// Show if the user has any of these permissions.
  final List<String>? anyOfPermissions;

  /// When true, Admin role/userType can see this item even without the permission.
  final bool visibleToAdmin;

  bool isVisible(PermissionCubit permissions) {
    if (visibleToAdmin && permissions.isAdmin) return true;
    if (permission != null) return permissions.has(permission!);
    if (anyOfPermissions != null && anyOfPermissions!.isNotEmpty) {
      return permissions.hasAny(anyOfPermissions!);
    }
    return true;
  }
}

class DrawerExpandableSection extends StatefulWidget {
  const DrawerExpandableSection({
    super.key,
    this.icon,
    this.iconPath,
    required this.titleKey,
    required this.children,
    this.initiallyExpanded = false,
  });

  final IconData? icon;
  final String? iconPath;
  final String titleKey;
  final List<DrawerMenuEntry> children;
  final bool initiallyExpanded;

  @override
  State<DrawerExpandableSection> createState() =>
      _DrawerExpandableSectionState();
}

class _DrawerExpandableSectionState extends State<DrawerExpandableSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final permissions = context.watch<PermissionCubit>();
    final visibleChildren =
        widget.children.where((e) => e.isVisible(permissions)).toList();

    if (visibleChildren.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                if (widget.iconPath != null)
                  SvgPicture.asset(
                    widget.iconPath!,
                    width: 22.sp,
                    height: 22.sp,
                    colorFilter: ColorFilter.mode(
                      colors.kPrimaryColor,
                      BlendMode.srcIn,
                    ),
                  )
                else
                  Icon(
                    widget.icon ?? Icons.circle,
                    color: colors.kPrimaryColor,
                    size: 22.sp,
                  ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    widget.titleKey.tr(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: colors.kFontColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _expanded ? -0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colors.kGrayColor,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: visibleChildren
                .map((entry) => DrawerSubMenuItem(entry: entry))
                .toList(),
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: colors.kBorderColor.withValues(alpha: 0.35),
        ),
      ],
    );
  }
}

class DrawerSubMenuItem extends StatelessWidget {
  const DrawerSubMenuItem({super.key, required this.entry});

  final DrawerMenuEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: () => entry.onTap(context),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: 32.w,
          end: 16.w,
          top: 10.h,
          bottom: 10.h,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            entry.titleKey.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: colors.kGrayColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Almarai',
            ),
          ),
        ),
      ),
    );
  }
}

void drawerPush(BuildContext context, Widget screen) {
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => screen),
  );
}

void drawerShowComingSoon(BuildContext context) {
  Navigator.pop(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(AppString.comingSoon.tr()),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
