import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/global_statistics_models.dart';
import '../constants/sa_region_map_constants.dart';
import 'statistics_style.dart';

class SaudiStatisticsMap extends StatefulWidget {
  final List<AreaProjectDto> areas;
  final String? selectedRegionCode;
  final ValueChanged<AreaProjectDto> onRegionSelected;
  final VoidCallback? onUnknownRegionTapped;
  final String? hintText;

  const SaudiStatisticsMap({
    super.key,
    required this.areas,
    required this.onRegionSelected,
    this.selectedRegionCode,
    this.onUnknownRegionTapped,
    this.hintText,
  });

  @override
  State<SaudiStatisticsMap> createState() => _SaudiStatisticsMapState();
}

class _SaudiStatisticsMapState extends State<SaudiStatisticsMap> {
  int _selectedIndex = -1;

  @override
  void didUpdateWidget(SaudiStatisticsMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedRegionCode != widget.selectedRegionCode) {
      _selectedIndex =
          SaRegionMapConstants.indexForRegionCode(widget.selectedRegionCode) ??
          -1;
    }
  }

  MapShapeSource _buildMapSource(BuildContext context) {
    final colors = context.appColors;

    return MapShapeSource.asset(
      'assets/map/sa.json',
      shapeDataField: 'id',
      dataCount: SaRegionMapConstants.regionCount,
      primaryValueMapper: (int index) =>
          SaRegionMapConstants.regionCodesByIndex[index],
      shapeColorValueMapper: (int index) => _colorKeyForIndex(index),
      shapeColorMappers: [
        MapColorMapper(value: 'selected', color: colors.kPrimaryColor),
        MapColorMapper(
          value: 'active',
          color: colors.kPrimaryColor.withValues(alpha: 0.55),
        ),
        MapColorMapper(
          value: 'inactive',
          color: colors.kDarkGrayColor.withValues(alpha: 0.65),
        ),
      ],
    );
  }

  String _colorKeyForIndex(int index) {
    final code = SaRegionMapConstants.regionCodeAt(index);
    if (code != null && code == widget.selectedRegionCode) {
      return 'selected';
    }
    final count = SaRegionMapConstants.projectCountForIndex(
      index,
      widget.areas,
    );
    return count > 0 ? 'active' : 'inactive';
  }

  void _handleSelection(int index) {
    final area = SaRegionMapConstants.areaForIndex(index, widget.areas);
    if (area == null) {
      widget.onUnknownRegionTapped?.call();
      return;
    }
    setState(() => _selectedIndex = index);
    widget.onRegionSelected(area);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final mapSource = _buildMapSource(context);

    if (_selectedIndex == -1 && widget.selectedRegionCode != null) {
      _selectedIndex =
          SaRegionMapConstants.indexForRegionCode(widget.selectedRegionCode) ??
          -1;
    }

    return Container(
      height: 280.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.kBgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RobotoText(
            text: widget.hintText ?? AppString.tapRegionOnMap,
            fontSize: 11,
            color: colors.kGrayColor,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SfMaps(
                layers: [
                  MapShapeLayer(
                    source: mapSource,
                    strokeColor: colors.kBgColor,
                    strokeWidth: 1.2,
                    color: colors.kDarkGrayColor.withValues(alpha: 0.4),
                    selectedIndex: _selectedIndex,
                    selectionSettings: MapSelectionSettings(
                      color: colors.kGoldColor.withValues(alpha: 0.85),
                      strokeColor: colors.kPrimaryColor,
                      strokeWidth: 1.5,
                    ),
                    onSelectionChanged: _handleSelection,
                    tooltipSettings: MapTooltipSettings(
                      color: colors.kDarkGrayColor.withValues(alpha: 0.95),
                      strokeColor: colors.kPrimaryColor,
                    ),
                    shapeTooltipBuilder: (BuildContext context, int index) {
                      final code = SaRegionMapConstants.regionCodeAt(index);
                      final area = SaRegionMapConstants.areaForIndex(
                        index,
                        widget.areas,
                      );
                      final englishName =
                          SaRegionMapConstants.englishNamesByCode[code] ?? code;
                      final title = area?.title ?? englishName ?? '';
                      final count = area?.count ?? 0;
                      return Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Text(
                          '$title\n${AppString.projects.tr()}: $count',
                          style: StatisticsStyle.label(
                            context,
                            color: StatisticsStyle.textOnAccent,
                            size: 11,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
