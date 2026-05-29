import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../utils/app_color.dart';

// Helper class for theme-aware shimmer colors
class ShimmerColors {
  static Color getBaseColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.grey[800]! : Colors.grey[300]!;
  }

  static Color getHighlightColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.grey[700]! : Colors.grey[100]!;
  }

  static Color getContainerColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.grey[850]! : Colors.white;
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ShimmerColors.getBaseColor(context),
      highlightColor: ShimmerColors.getHighlightColor(context),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ShimmerColors.getContainerColor(context),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerWidgets {
  // Shimmer for slider
  static Widget sliderShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: Container(
          height: 141.h,
          width: 380.w,
          decoration: BoxDecoration(
            color: ShimmerColors.getContainerColor(context),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  // Shimmer for categories
  static Widget categoryShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ShimmerColors.getContainerColor(context),
            border: Border.all(color: AppColor.kBackgroundColor, width: 1.w),
          ),
        ),
      ),
    );
  }

  // Shimmer for services/brands
  static Widget serviceShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: SizedBox(
          width: 74.w,
          height: 86.h,
          child: Column(
            children: [
              Container(
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  color: ShimmerColors.getContainerColor(context),
                  borderRadius: BorderRadius.circular(7.r),
                ),
              ),
              SizedBox(height: 8.w),
              Container(
                width: 60.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: ShimmerColors.getContainerColor(context),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shimmer for top rated products
  static Widget productShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: Container(
          width: 165.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: ShimmerColors.getContainerColor(context),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }

  static Widget quickServiceShimmer() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final baseColor = isDark ? Colors.grey[800]! : Colors.grey.shade300;
        final highlightColor = isDark
            ? Colors.grey[700]!
            : Colors.grey.shade100;
        final shimmerColor = isDark ? Colors.grey[600]! : Colors.white;

        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 16.h,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Column(
                children: [
                  // Icon shimmer
                  Container(
                    width: 72.w,
                    height: 72.w,
                    margin: EdgeInsets.only(bottom: 8.h),
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),

                  // Text shimmer
                  Container(
                    width: 50.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Shimmer for offers
  static Widget offerShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          width: double.infinity,
          decoration: BoxDecoration(
            color: ShimmerColors.getContainerColor(context),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 160.h,
                decoration: BoxDecoration(
                  color: ShimmerColors.getContainerColor(context),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: ShimmerColors.getContainerColor(context),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: 100.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: ShimmerColors.getContainerColor(context),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Container(
                          width: 70.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: ShimmerColors.getContainerColor(context),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 70.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: ShimmerColors.getContainerColor(context),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 70.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: ShimmerColors.getContainerColor(context),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget offerHorizontalShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          margin: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: ShimmerColors.getContainerColor(context),
          ),
          child: Row(
            children: [
              Container(
                width: 90.w,
                height: 80.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: ShimmerColors.getContainerColor(context),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 120.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: ShimmerColors.getContainerColor(context),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 100.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: ShimmerColors.getContainerColor(context),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: ShimmerColors.getContainerColor(context),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          width: 50.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: ShimmerColors.getContainerColor(context),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          width: 50.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: ShimmerColors.getContainerColor(context),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget horizontallistShimmer() {
    return SizedBox(
      height: 130.h,
      child: Builder(
        builder: (context) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Shimmer.fromColors(
                baseColor: ShimmerColors.getBaseColor(context),
                highlightColor: ShimmerColors.getHighlightColor(context),
                child: Container(
                  width: 250.w,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  padding: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: ShimmerColors.getContainerColor(context),
                  ),
                  child: Column(
                    children: [
                      // Image shimmer
                      Container(
                        width: 250.w,
                        height: 120.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: ShimmerColors.getContainerColor(context),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            // Store name shimmer
                            Container(
                              width: 120.w,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: ShimmerColors.getContainerColor(context),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // Offer shimmer
                            Container(
                              width: 160.w,
                              height: 22.h,
                              decoration: BoxDecoration(
                                color: ShimmerColors.getContainerColor(context),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // Bottom info shimmer
                            Row(
                              children: [
                                Container(
                                  width: 80.w,
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    color: ShimmerColors.getContainerColor(
                                      context,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  width: 80.w,
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    color: ShimmerColors.getContainerColor(
                                      context,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Shimmer for search bar
  static Widget searchBarShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: Container(
          height: 85.h,
          width: 380.w,
          decoration: BoxDecoration(
            color: ShimmerColors.getContainerColor(context),
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
      ),
    );
  }

  // Shimmer for address section
  static Widget addressShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.w),
                    Container(
                      width: 60.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: ShimmerColors.getContainerColor(context),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: 120.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: ShimmerColors.getContainerColor(context),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget verticalStoreShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: Container(
          padding: EdgeInsets.only(bottom: 10.h),
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: ShimmerColors.getContainerColor(context),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 160.h,
                    decoration: BoxDecoration(
                      color: ShimmerColors.getContainerColor(context),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  Positioned(
                    bottom: 12.h,
                    right: 12.w,
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: ShimmerColors.getContainerColor(context),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: ShimmerColors.getContainerColor(context),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: 100.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: ShimmerColors.getContainerColor(context),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Container(
                          width: 70.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: ShimmerColors.getContainerColor(context),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 70.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: ShimmerColors.getContainerColor(context),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 70.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: ShimmerColors.getContainerColor(context),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget verticallistShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return verticalStoreShimmer();
      },
    );
  }

  static Widget orderModificationShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 80.h),
              Container(
                width: 162.sp,
                height: 162.sp,
                decoration: BoxDecoration(
                  color: ShimmerColors.getContainerColor(context),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 30.h),
              Container(
                width: 200.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: ShimmerColors.getContainerColor(context),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                width: double.infinity,
                height: 60.h,
                decoration: BoxDecoration(
                  color: ShimmerColors.getContainerColor(context),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(height: 40.h),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 150.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: ShimmerColors.getContainerColor(context),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (_, __) => Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: ShimmerColors.getContainerColor(context),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 60.h),
              Container(
                width: double.infinity,
                height: 55.h,
                decoration: BoxDecoration(
                  color: ShimmerColors.getContainerColor(context),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                height: 55.h,
                decoration: BoxDecoration(
                  color: ShimmerColors.getContainerColor(context),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget restaurantDetailsShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: Column(
          children: [
            Container(
              height: 200.h,
              width: double.infinity,
              color: ShimmerColors.getContainerColor(context),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: ShimmerColors.getContainerColor(context),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150.w,
                          height: 14.h,
                          color: ShimmerColors.getContainerColor(context),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: 200.w,
                          height: 11.h,
                          color: ShimmerColors.getContainerColor(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  3,
                  (index) => Container(
                    width: 80.w,
                    height: 40.h,
                    color: ShimmerColors.getContainerColor(context),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 50.h,
              width: double.infinity,
              color: ShimmerColors.getContainerColor(context),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (_, __) => Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.w,
                        height: 18.h,
                        color: ShimmerColors.getContainerColor(context),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: ShimmerColors.getContainerColor(context),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 14.h,
                                  color: ShimmerColors.getContainerColor(
                                    context,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  width: 100.w,
                                  height: 12.h,
                                  color: ShimmerColors.getContainerColor(
                                    context,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget productDetailsShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300.h,
              width: double.infinity,
              color: ShimmerColors.getContainerColor(context),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200.w,
                        height: 20.h,
                        color: ShimmerColors.getContainerColor(context),
                      ),
                      Container(
                        width: 80.w,
                        height: 20.h,
                        color: ShimmerColors.getContainerColor(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    height: 40.h,
                    color: ShimmerColors.getContainerColor(context),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: 100.w,
                    height: 16.h,
                    color: ShimmerColors.getContainerColor(context),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Expanded(
                        child: Container(
                          height: 60.h,
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            color: ShimmerColors.getContainerColor(context),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: 100.w,
                    height: 16.h,
                    color: ShimmerColors.getContainerColor(context),
                  ),
                  SizedBox(height: 10.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: 6,
                    itemBuilder: (_, __) => Container(
                      decoration: BoxDecoration(
                        color: ShimmerColors.getContainerColor(context),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget offerDetailsShimmer() {
    return Builder(
      builder: (context) => Shimmer.fromColors(
        baseColor: ShimmerColors.getBaseColor(context),
        highlightColor: ShimmerColors.getHighlightColor(context),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (_, __) => Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: ShimmerColors.getContainerColor(context),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const ShimmerImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget shimmer = Shimmer.fromColors(
      baseColor: ShimmerColors.getBaseColor(context),
      highlightColor: ShimmerColors.getHighlightColor(context),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ShimmerColors.getContainerColor(context),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => shimmer,
        errorWidget: (context, url, error) => errorWidget ?? shimmer,
      ),
    );
  }
}
