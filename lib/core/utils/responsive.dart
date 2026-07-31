import 'package:flutter/material.dart';

/// Breakpoint aligned with Material / iPad mini shortest side.
const double kTabletBreakpoint = 600;

/// Max readable width for form-like content (login, etc.).
const double kFormMaxWidth = 480;

/// Max content width for dashboard-style pages on tablet.
const double kPageMaxWidth = 1100;

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  bool get isTablet => screenSize.shortestSide >= kTabletBreakpoint;

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// Side padding that breathes on iPad without stretching edges.
  double get pagePadding => isTablet ? 28 : 16;

  double get contentMaxWidth => isTablet ? kPageMaxWidth : double.infinity;

  int get projectGridCrossAxisCount {
    if (!isTablet) return 1;
    return isLandscape ? 3 : 2;
  }

  int get statsGridCrossAxisCount => isTablet ? 4 : 2;
}

/// Centers [child] and caps its width on tablet / wide screens.
class AdaptiveContent extends StatelessWidget {
  const AdaptiveContent({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final resolvedMax = maxWidth ?? context.contentMaxWidth;
    final resolvedPadding = padding ??
        EdgeInsets.symmetric(horizontal: context.pagePadding);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: resolvedMax),
        child: Padding(
          padding: resolvedPadding,
          child: child,
        ),
      ),
    );
  }
}

/// Detects tablet before [MediaQuery] is available (e.g. in [main]).
bool isTabletDevice() {
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final size = view.physicalSize / view.devicePixelRatio;
  return size.shortestSide >= kTabletBreakpoint;
}

Size appDesignSize() {
  return isTabletDevice() ? const Size(768, 1024) : const Size(360, 800);
}
