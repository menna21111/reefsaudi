import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/utils/app_color.dart';

class CustomLineChart extends StatefulWidget {
  final List<double> actualPoints;
  final List<double> plannedPoints;

  const CustomLineChart({
    super.key,
    this.actualPoints = const [],
    this.plannedPoints = const [],
  });

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return LineChart(
          _lineChartData(),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  LineChartData _lineChartData() {
    return LineChartData(
      minY: 0,
      maxY: 100,
      clipData: const FlClipData.all(),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: AppColor.kInputBorderColor, width: 1),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.transparent, strokeWidth: 0),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: barData.color ?? AppColor.kPrimaryColor,
                  );
                },
              ),
            );
          }).toList();
        },
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 25.h,
            getTitlesWidget: _getBottomTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35.w,
            interval: 25,
            getTitlesWidget: _getLeftTitles,
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 25,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColor.kInputBorderColor.withOpacity(0.3),
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
      ),
      lineBarsData: [
        LineChartBarData(
          spots: _getAnimatedSpots(_toSpots(widget.actualPoints)),
          isCurved: true,
          color: AppColor.kPrimaryColor,
          barWidth: 2.5,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppColor.kPrimaryColor.withOpacity(0.1),
            cutOffY: 0,
          ),
        ),
        LineChartBarData(
          spots: _getAnimatedSpots(_toSpots(widget.plannedPoints)),
          isCurved: true,
          color: AppColor.kGrayTextColor,
          barWidth: 2.5,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppColor.kGrayTextColor.withOpacity(0.1),
            cutOffY: 0,
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getAnimatedSpots(List<FlSpot> originalSpots) {
    return originalSpots.map((spot) {
      return FlSpot(spot.x, spot.y * _animation.value);
    }).toList();
  }

  List<FlSpot> _toSpots(List<double> values) {
    if (values.isEmpty) {
      return const [FlSpot(0, 0), FlSpot(1, 0)];
    }
    return values
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    switch (value.toInt()) {
      case 0:
        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: RobotoText(
            text: 'البداية',
            color: AppColor.kGrayTextColor,
            fontSize: 10.sp,
          ),
        );
      case 1:
        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: RobotoText(
            text: '50%',
            color: AppColor.kGrayTextColor,
            fontSize: 10.sp,
          ),
        );
      case 2:
        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: RobotoText(
            text: 'النهاية',
            color: AppColor.kGrayTextColor,
            fontSize: 10.sp,
          ),
        );
      default:
        return const Text('');
    }
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Text(
        '${value.toInt()}%',
        style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 10.sp),
      ),
    );
  }
}
