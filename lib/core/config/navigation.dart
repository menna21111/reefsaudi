import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/placeholder_screens.dart';
import '../../features/financial_requirements/presentation/screens/financial_requirements_screen.dart';
import '../services/service_locator.dart';
import '../utils/app_color.dart';
import '../utils/app_font.dart';
import '../utils/app_icon.dart';
import '../utils/app_string.dart';

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
      BlocProvider(
        create: (context) => sl<DashboardBloc>(),
        child: const DashboardScreen(),
      ),
      const FinancialRequirementsScreen(),
      const TasksPlaceholderScreen(),
      // const QualityPlaceholderScreen(),
      const ProfilePlaceholderScreen(),
    ];
  }

  void _initializeNavItems() {
    _navItems = [
      const BottomNavItem(
        labelKey: AppString.dashboard,
        iconData: Icons.dashboard_rounded,
      ),
      const BottomNavItem(
        labelKey: AppString.financialRequirements,
        iconData: Icons.account_balance_wallet_outlined,
      ),
      const BottomNavItem(
        labelKey: AppString.tasks,
        iconData: Icons.task_alt_rounded,
      ),
      // const BottomNavItem(
      //   labelKey: AppString.qualityManagement,
      //   iconData: Icons.query_stats_rounded,
      // ),
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 78.h,
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(24.r),
        //   topRight: Radius.circular(24.r),
        // ),
        border: Border(
          top: BorderSide(
            color: AppColor.kBorderColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _navItems.length,
            (index) => _buildNavItem(index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppColor.kPrimaryColor : AppColor.kGrayTextColor;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Indicator line on top of active tab
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3.h,
              width: isSelected ? 36.w : 0,
              decoration: BoxDecoration(
                color: AppColor.kPrimaryColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.iconPath != null)
                  SvgPicture.asset(
                    item.iconPath!,
                    width: 22.w,
                    height: 22.h,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  )
                else if (item.iconData != null)
                  Icon(item.iconData!, size: 22.sp, color: color),
                SizedBox(height: 4.h),
                LamaSansText(
                  text: item.labelKey,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ],
            ),
            const SizedBox(),
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
