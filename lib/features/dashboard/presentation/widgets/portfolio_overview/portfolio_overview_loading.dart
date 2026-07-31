import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/shimmer_widgets.dart';
import '../dashboard_header.dart';

class PortfolioOverviewShimmer extends StatelessWidget {
  const PortfolioOverviewShimmer({super.key});

  Widget _statsRow() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: 100.h,
              borderRadius: 16,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: 100.h,
              borderRadius: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          sliver: const SliverToBoxAdapter(child: DashboardHeader()),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: 180.w,
                  height: 28.h,
                  borderRadius: 8,
                ),
                SizedBox(height: 16.h),
                ShimmerBox(
                  width: double.infinity,
                  height: 52.h,
                  borderRadius: 12,
                ),
                SizedBox(height: 12.h),
                ShimmerBox(
                  width: 140.w,
                  height: 18.h,
                  borderRadius: 6,
                ),
                SizedBox(height: 12.h),
                ShimmerBox(
                  width: double.infinity,
                  height: 200.h,
                  borderRadius: 16,
                ),
                SizedBox(height: 16.h),
                _statsRow(),
                _statsRow(),
                SizedBox(height: 12.h),
                ShimmerBox(
                  width: 140.w,
                  height: 18.h,
                  borderRadius: 6,
                ),
                SizedBox(height: 12.h),
                _statsRow(),
                _statsRow(),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
