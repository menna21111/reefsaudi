import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/dashboard/presentation/cubit/portfolio_overview_cubit.dart';
import '../../features/dashboard/presentation/screens/portfolio_overview_screen.dart';
import '../../features/dashboard/presentation/screens/profile_screen.dart';
import '../../features/quality_management/presentation/screens/quality_requests_screen.dart';
import '../services/service_locator.dart';
import '../utils/app_font.dart';
import '../utils/app_string.dart';
import '../utils/app_theme_context.dart';
import '../utils/responsive.dart';

class BottomNavigation extends StatefulWidget {
  final int initialIndex;

  const BottomNavigation({super.key, this.initialIndex = 0});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _selectedIndex;
  late final List<Widget> _screens;
  late final List<BottomNavItem> _navItems;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _initializeScreens();
    _initializeNavItems();
  }

  void _initializeScreens() {
    _screens = [
      BlocProvider.value(
        value: sl<PortfolioOverviewCubit>(),
        child: const PortfolioOverviewScreen(),
      ),
      QualityRequestsScreen.myRequests(showAppBar: false),
      QualityRequestsScreen.approvalTasks(showAppBar: false),
      const ProfileScreen(),
    ];
  }

  void _initializeNavItems() {
    _navItems = [
      const BottomNavItem(
        labelKey: AppString.dashboard,
        iconData: Icons.dashboard_rounded,
      ),
      const BottomNavItem(
        labelKey: AppString.myRequests,
        iconData: Icons.assignment_outlined,
      ),
      const BottomNavItem(
        labelKey: AppString.approvalTasks,
        iconData: Icons.task_alt_rounded,
      ),
      const BottomNavItem(
        labelKey: AppString.personalProfile,
        iconData: Icons.person_outline_rounded,
      ),
    ];
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final useSideRail = context.isTablet && context.isLandscape;

    final body = IndexedStack(
      index: _selectedIndex,
      children: List.generate(_screens.length, (index) {
        return HeroMode(
          enabled: _selectedIndex == index,
          child: _screens[index],
        );
      }),
    );

    if (useSideRail) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            _buildNavigationRail(),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: context.appColors.kBorderColor.withValues(alpha: 0.3),
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: body,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildNavigationRail() {
    final colors = context.appColors;

    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onItemTapped,
      backgroundColor: colors.kInputColor,
      selectedIconTheme: IconThemeData(color: colors.kPrimaryColor, size: 26),
      unselectedIconTheme: IconThemeData(color: colors.kGrayColor, size: 24),
      selectedLabelTextStyle: TextStyle(
        color: colors.kPrimaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        fontFamily: 'Almarai',
      ),
      unselectedLabelTextStyle: TextStyle(
        color: colors.kGrayColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: 'Almarai',
      ),
      labelType: NavigationRailLabelType.all,
      minWidth: 88,
      destinations: [
        for (final item in _navItems)
          NavigationRailDestination(
            icon: Icon(item.iconData ?? Icons.circle),
            selectedIcon: Icon(item.iconData ?? Icons.circle),
            label: Text(item.labelKey.tr()),
          ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    final colors = context.appColors;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final isTablet = context.isTablet;
    final barHeight = isTablet ? 64.0 : 52.h;
    final topPad = isTablet ? 8.0 : 8.h;
    final bottomPad = bottomInset > 0 ? bottomInset : (isTablet ? 8.0 : 8.h);

    return Material(
      color: colors.kInputColor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colors.kBorderColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: topPad, bottom: bottomPad),
          child: SizedBox(
            height: barHeight,
            width: double.infinity,
            child: Row(
              children: List.generate(
                _navItems.length,
                (index) => _buildNavItem(index, isTablet: isTablet),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, {required bool isTablet}) {
    final colors = context.appColors;
    final item = _navItems[index];
    final isSelected = _selectedIndex == index;
    final color = isSelected ? colors.kPrimaryColor : colors.kGrayColor;
    final iconSize = isTablet ? 24.0 : 22.sp;
    final fontSize = isTablet ? 11 : 10;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: isTablet ? 3.0 : 3.h,
              width: isSelected ? (isTablet ? 36.0 : 36.w) : 0,
              decoration: BoxDecoration(
                color: colors.kPrimaryColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: isTablet ? 4 : 6.h),
            if (item.iconPath != null)
              SvgPicture.asset(
                item.iconPath!,
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              )
            else if (item.iconData != null)
              Icon(item.iconData!, size: iconSize, color: color),
            SizedBox(height: isTablet ? 2 : 4.h),
            LamaSansText(
              text: item.labelKey,
              fontSize: fontSize,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem {
  final String labelKey;
  final String? iconPath;
  final IconData? iconData;

  const BottomNavItem({required this.labelKey, this.iconPath, this.iconData});
}
