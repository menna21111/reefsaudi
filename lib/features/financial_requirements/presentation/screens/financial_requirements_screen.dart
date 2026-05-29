import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../domain/models/financial_requirement.dart';
import '../widgets/financial_summary_cards.dart';
import '../widgets/financial_filter_chips.dart';
import '../widgets/financial_requirement_card.dart';
import '../widgets/financial_requirement_table.dart';

class FinancialRequirementsScreen extends StatefulWidget {
  const FinancialRequirementsScreen({super.key});

  @override
  State<FinancialRequirementsScreen> createState() =>
      _FinancialRequirementsScreenState();
}

class _FinancialRequirementsScreenState
    extends State<FinancialRequirementsScreen> {
  FinancialRequirementStatus _selectedStatus =
      FinancialRequirementStatus.all;
  bool _isTableView = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FinancialRequirement> get _filteredItems {
    var items = mockFinancialRequirements;

    if (_selectedStatus != FinancialRequirementStatus.all) {
      items = items.where((e) => e.status == _selectedStatus).toList();
    }

    if (_searchQuery.isNotEmpty) {
      items = items
          .where((e) =>
              e.projectName.contains(_searchQuery) ||
              e.contractor.contains(_searchQuery) ||
              e.projectNumber.contains(_searchQuery))
          .toList();
    }

    return items;
  }

  void _onFilterChanged(FinancialRequirementStatus status) {
    setState(() {
      _selectedStatus = status;
      // Switch to table view automatically when a specific filter is selected
      _isTableView = status != FinancialRequirementStatus.all;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ─── Header ───────────────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              sliver: SliverToBoxAdapter(child: _buildHeader()),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 16.h)),

            // ─── Summary Cards (big + 2 small + sector card) ──────
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: const SliverToBoxAdapter(
                child: FinancialSummaryCards(),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 20.h)),

            // ─── Section title ────────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverToBoxAdapter(child: _buildSectionTitle()),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 12.h)),

            // ─── Search Bar ───────────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverToBoxAdapter(child: _buildSearchBar()),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 14.h)),

            // ─── Filter Chips ─────────────────────────────────────
            SliverToBoxAdapter(
              child: FinancialFilterChips(
                selectedStatus: _selectedStatus,
                onStatusChanged: _onFilterChanged,
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 14.h)),

            // ─── View toggle row ──────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverToBoxAdapter(
                  child: _buildViewToggleRow(filtered)),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 12.h)),

            // ─── Content: Cards or Table ──────────────────────────
            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48.sp,
                        color: AppColor.kGrayTextColor,
                      ),
                      SizedBox(height: 12.h),
                      RobotoText(
                        text: 'لا توجد متطلبات مالية',
                        fontSize: 14.sp,
                        color: AppColor.kGrayTextColor,
                      ),
                    ],
                  ),
                ),
              )
            else if (_isTableView)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverToBoxAdapter(
                  child: FinancialRequirementTable(items: filtered),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => FinancialRequirementCard(
                      item: filtered[index],
                    ),
                    childCount: filtered.length,
                  ),
                ),
              ),

            SliverToBoxAdapter(child: SizedBox(height: 90.h)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Header  (matches screenshot: title right, bell icon left)
  // ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bell icon on the left
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColor.kSurfaceColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
                color: AppColor.kBorderColor.withOpacity(0.3)),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: AppColor.kGrayTextColor,
            size: 20.sp,
          ),
        ),

        // Title on the right
        RobotoText(
          text: 'القوائم المالية',
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.kWhiteColor,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Section title
  // ─────────────────────────────────────────────────────────────────
  Widget _buildSectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _selectedStatus = FinancialRequirementStatus.all;
            _isTableView = false;
          }),
          child: RobotoText(
            text: 'عرض الكل',
            fontSize: 12.sp,
            color: AppColor.kPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        RobotoText(
          text: 'المتطلبات المالية',
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColor.kWhiteColor,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Search Bar
  // ─────────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        color: AppColor.kWhiteColor,
        fontSize: 13.sp,
        fontFamily: 'Almarai',
      ),
      onChanged: (val) => setState(() => _searchQuery = val),
      decoration: InputDecoration(
        hintText: 'ابحث عن مشروع...',
        hintStyle: TextStyle(
          color: AppColor.kGrayTextColor,
          fontSize: 13.sp,
          fontFamily: 'Almarai',
        ),
        filled: true,
        fillColor: AppColor.kSurfaceColor,
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColor.kGrayTextColor,
          size: 20.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColor.kBorderColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColor.kPrimaryColor),
        ),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // View Toggle Row (count + toggle button)
  // ─────────────────────────────────────────────────────────────────
  Widget _buildViewToggleRow(List<FinancialRequirement> filtered) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Toggle card/table button
        GestureDetector(
          onTap: () => setState(() => _isTableView = !_isTableView),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: _isTableView
                  ? AppColor.kPrimaryColor.withOpacity(0.15)
                  : AppColor.kSurfaceColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: _isTableView
                    ? AppColor.kPrimaryColor
                    : AppColor.kBorderColor.withOpacity(0.3),
              ),
            ),
            child: Icon(
              _isTableView
                  ? Icons.list_rounded
                  : Icons.grid_view_rounded,
              color: _isTableView
                  ? AppColor.kPrimaryColor
                  : AppColor.kGrayTextColor,
              size: 20.sp,
            ),
          ),
        ),
        // Count badge
        RobotoText(
          text: '${filtered.length} متطلب',
          fontSize: 12.sp,
          color: AppColor.kGrayTextColor,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
