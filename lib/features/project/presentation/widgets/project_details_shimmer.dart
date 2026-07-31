import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/shimmer_widgets.dart';

class ProjectHeaderShimmer extends StatelessWidget {
  const ProjectHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(width: double.infinity, height: 18.h, borderRadius: 6),
        SizedBox(height: 10.h),
        ShimmerBox(width: 140.w, height: 12.h, borderRadius: 6),
        SizedBox(height: 8.h),
        ShimmerBox(width: 100.w, height: 12.h, borderRadius: 6),
      ],
    );
  }
}

class ProjectInfoCardShimmer extends StatelessWidget {
  const ProjectInfoCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index == 4 ? 0 : 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 90.w, height: 12.h, borderRadius: 6),
                ShimmerBox(width: 120.w, height: 12.h, borderRadius: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectChartCardShimmer extends StatelessWidget {
  const ProjectChartCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 180.w, height: 18.h, borderRadius: 6),
          SizedBox(height: 8.h),
          ShimmerBox(width: 220.w, height: 12.h, borderRadius: 6),
          SizedBox(height: 24.h),
          ShimmerBox(width: double.infinity, height: 200.h, borderRadius: 12),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerBox(width: 72.w, height: 12.h, borderRadius: 6),
              SizedBox(width: 16.w),
              ShimmerBox(width: 72.w, height: 12.h, borderRadius: 6),
            ],
          ),
        ],
      ),
    );
  }
}

class StatsRowShimmer extends StatelessWidget {
  const StatsRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _statCardShimmer()),
            SizedBox(width: 16.w),
            Expanded(child: _statCardShimmer()),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _statCardShimmer()),
            SizedBox(width: 16.w),
            Expanded(child: _statCardShimmer()),
          ],
        ),
      ],
    );
  }

  Widget _statCardShimmer() {
    return ShimmerBox(
      width: double.infinity,
      height: 88.h,
      borderRadius: 12,
    );
  }
}

class ProjectSummaryCardShimmer extends StatelessWidget {
  const ProjectSummaryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: ShimmerBox(width: double.infinity, height: 64.h, borderRadius: 12)),
            SizedBox(width: 12.w),
            Expanded(child: ShimmerBox(width: double.infinity, height: 64.h, borderRadius: 12)),
          ],
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(child: ShimmerBox(width: double.infinity, height: 64.h, borderRadius: 12)),
            SizedBox(width: 12.w),
            Expanded(child: ShimmerBox(width: double.infinity, height: 64.h, borderRadius: 12)),
          ],
        ),
      ],
    );
  }
}

class ProjectImagesShimmer extends StatelessWidget {
  const ProjectImagesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: double.infinity,
      height: 180.h,
      borderRadius: 16,
    );
  }
}

class ProjectDetailsReadOnlyShimmer extends StatelessWidget {
  const ProjectDetailsReadOnlyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index == 2 ? 0 : 16.h),
          child: ShimmerBox(
            width: double.infinity,
            height: 180.h,
            borderRadius: 16,
          ),
        ),
      ),
    );
  }
}
