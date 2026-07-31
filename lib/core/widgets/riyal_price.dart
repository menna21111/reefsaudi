import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_image.dart';
import '../utils/app_theme_context.dart';

/// Displays a price with the Saudi Riyal symbol image behind / with it.
class RiyalPrice extends StatelessWidget {
  const RiyalPrice({
    super.key,
    required this.price,
    this.style,
    this.iconSize,
    this.iconColor,
    this.iconOpacity = 0.22,
    this.padding,
    this.textAlign,
  });

  /// Formatted price text (e.g. `1,250.00` or `1.2M`).
  final String price;

  final TextStyle? style;
  final double? iconSize;
  final Color? iconColor;

  /// Opacity of the riyal image sitting behind the price.
  final double iconOpacity;

  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final resolvedStyle = style ??
        TextStyle(
          color: colors.kFontColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'Almarai',
        );
    final size = iconSize ?? ((resolvedStyle.fontSize ?? 14) * 1.8);
    final tint = iconColor ?? resolvedStyle.color ?? colors.kFontColor;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Opacity(
            opacity: iconOpacity.clamp(0.0, 1.0),
            child: Image.asset(
              AppImage.riyal,
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            price,
            textAlign: textAlign ?? TextAlign.center,
            style: resolvedStyle,
          ),
        ],
      ),
    );
  }
}

/// Compact price + riyal icon side by side (icon after the amount).
class RiyalPriceLabel extends StatelessWidget {
  const RiyalPriceLabel({
    super.key,
    required this.price,
    this.style,
    this.iconSize,
    this.iconColor,
    this.spacing,
  });

  final String price;
  final TextStyle? style;
  final double? iconSize;
  final Color? iconColor;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final resolvedStyle = style ??
        TextStyle(
          color: colors.kFontColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Almarai',
        );
    final size = iconSize ?? ((resolvedStyle.fontSize ?? 14) * 0.95);
    final tint = iconColor ?? resolvedStyle.color ?? colors.kFontColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            price,
            style: resolvedStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: spacing ?? 4.w),
        Image.asset(
          AppImage.riyal,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

/// Riyal symbol alone — useful as a field suffix.
class RiyalIcon extends StatelessWidget {
  const RiyalIcon({
    super.key,
    this.size,
    this.color,
  });

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final resolvedSize = size ?? 16.sp;
    final tint = color ?? colors.kPrimaryColor;

    return Image.asset(
      AppImage.riyal,
      width: resolvedSize,
      height: resolvedSize,
      fit: BoxFit.contain,
    );
  }
}
