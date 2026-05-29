
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../utils/app_color.dart';
// import '../utils/app_font.dart';
// import '../utils/app_image.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final bool showBackButton;
//   final List<Widget>? actions;
//   final VoidCallback? onNotificationTap;

//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.showBackButton = true,
//     this.actions,
//     this.onNotificationTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//     final double headerHeight = 70.h; // Height of the colored part
//     final double totalHeight =
//         headerHeight +
//         statusBarHeight +
//         10.h; // Total height including status bar and the curve overlap

//     return Container(
//       height: totalHeight,
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           // 1. Header Background (Primary Color + Pattern)
//           Container(
//             height: headerHeight + statusBarHeight,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: AppColor.kPrimaryColor,
//               image: DecorationImage(
//                 alignment: Alignment.centerRight,
//                 image: AssetImage(AppImage.kFrameHome),
//                 fit: BoxFit.contain,
//                 scale: 0.8,
//               ),
//             ),
//           ),

//           // 2. White curve container at the bottom
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 20.h,
//               decoration: BoxDecoration(
//                 color: AppColor.kBgColor,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(12.r),
//                   topRight: Radius.circular(12.r),
//                 ),
//               ),
//             ),
//           ),

//           // 3. AppBar Content
//           SafeArea(
//             bottom: false,
//             child: _AppBarContent(
//               title: title,
//               showBackButton: showBackButton,
//               onNotificationTap: onNotificationTap,
//               actions: actions,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(100.h);
// }

// class SliverCustomAppBar extends StatelessWidget {
//   final String title;
//   final bool showBackButton;
//   final List<Widget>? actions;
//   final VoidCallback? onNotificationTap;

//   const SliverCustomAppBar({
//     super.key,
//     required this.title,
//     this.showBackButton = true,
//     this.actions,
//     this.onNotificationTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//     final double expandedHeight = 60.h + statusBarHeight;

//     return SliverAppBar(
//       pinned: true,

//       expandedHeight: expandedHeight,
//       collapsedHeight: 60.h,
//       backgroundColor: AppColor.kPrimaryColor,
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       leadingWidth: 0,
//       titleSpacing: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(12.r),
//           bottomRight: Radius.circular(12.r),
//         ),
//       ),
//       title: null,
//       flexibleSpace: FlexibleSpaceBar(
//         expandedTitleScale: 1.0,
//         titlePadding: EdgeInsets.only(bottom: 14.h),
//         title: _AppBarContent(
//           title: title,
//           showBackButton: showBackButton,
//           onNotificationTap: onNotificationTap,
//           actions: actions,
//         ),
//         background: Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: AppColor.kPrimaryColor,
//                 image: DecorationImage(
//                   alignment: Alignment.centerRight,
//                   image: AssetImage(AppImage.kFrameHome),
//                   fit: BoxFit.contain,
//                   scale: 0.8,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: -1, // Small overlap to prevent white sliver
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: 12.h,
//                 decoration: BoxDecoration(
//                   color: AppColor.kBgColor,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(12.r),
//                     topRight: Radius.circular(12.r),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AppBarContent extends StatelessWidget {
//   final String title;
//   final bool showBackButton;
//   final VoidCallback? onNotificationTap;
//   final List<Widget>? actions;

//   const _AppBarContent({
//     required this.title,
//     required this.showBackButton,
//     this.onNotificationTap,
//     this.actions,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 50.h,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (showBackButton)
//             InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.0.w),
//                 child: Container(
//                   padding: EdgeInsets.all(4.r),
//                   decoration: BoxDecoration(
//                     color: AppColor.kWhiteColor.withOpacity(0.2),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.arrow_back_ios_new_rounded,
//                     color: AppColor.kWhiteColor,
//                     size: 18.sp,
//                   ),
//                 ),
//               ),
//             )
//           else
//             SizedBox(width: 16.w),
//           Expanded(
//             child: Center(
//               child: RobotoText(
//                 text: title,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: AppColor.kWhiteColor,
//               ),
//             ),
//           ),
//           if (onNotificationTap != null)
//             GestureDetector(
//               onTap: onNotificationTap,
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 16.w),
//                 padding: EdgeInsets.all(8.r),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: SvgPicture.asset(
//                   AppImage.knotificationhome,
//                   height: 20.h,
//                   width: 20.w,
//                   colorFilter: const ColorFilter.mode(
//                     AppColor.kWhiteColor,
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//             )
//           else if (actions != null)
//             ...actions!
//           else
//             SizedBox(width: 48.w),
//         ],
//       ),
//     );
//   }
// }
