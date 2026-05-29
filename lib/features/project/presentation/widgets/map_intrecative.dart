import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

// --- نموذج البيانات ---
class GovernorateModel {
  final int id;
  final String name;
  final String arabicName;
  final bool isCompleted;
  final bool isCurrent;
  final double studentScore;
  final List<CityModel> cities;

  GovernorateModel({
    required this.id,
    required this.name,
    required this.arabicName,
    this.isCompleted = false,
    this.isCurrent = false,
    this.studentScore = 0,
    this.cities = const [],
  });
}

class CityModel {
  final String name;
  CityModel(this.name);
}

// --- مراكز المحافظات على الخريطة (مثل GovernorateCenters في كود عمان) ---
class SaudiGovernorateCenters {
  static final Map<int, Map<String, dynamic>> centers = {
    1: {
      'lat': 24.7136,
      'lng': 46.6753,
      'name': 'Ar Riyad',
      'arabicName': 'الرياض',
      'area': 380000.0,
    },
    2: {
      'lat': 21.4225,
      'lng': 39.8262,
      'name': 'Makkah',
      'arabicName': 'مكة المكرمة',
      'area': 153000.0,
    },
    3: {
      'lat': 24.4667,
      'lng': 39.6000,
      'name': 'Al Madinah',
      'arabicName': 'المدينة المنورة',
      'area': 150000.0,
    },
    4: {
      'lat': 26.4207,
      'lng': 50.0888,
      'name': 'Ash Sharqiyah',
      'arabicName': 'المنطقة الشرقية',
      'area': 540000.0,
    },
    5: {
      'lat': 18.2164,
      'lng': 42.5053,
      'name': '`Asir',
      'arabicName': 'عسير',
      'area': 81000.0,
    },
    6: {
      'lat': 17.4917,
      'lng': 44.1322,
      'name': 'Najran',
      'arabicName': 'نجران',
      'area': 130000.0,
    },
    7: {
      'lat': 16.8892,
      'lng': 42.5611,
      'name': 'Jizan',
      'arabicName': 'جيزان',
      'area': 12000.0,
    },
    8: {
      'lat': 19.0969,
      'lng': 41.9378,
      'name': 'Al Bahah',
      'arabicName': 'الباحة',
      'area': 15000.0,
    },
    9: {
      'lat': 29.4122,
      'lng': 41.6822,
      'name': 'Al Jawf',
      'arabicName': 'الجوف',
      'area': 100000.0,
    },
    10: {
      'lat': 28.3828,
      'lng': 36.5778,
      'name': 'Tabuk',
      'arabicName': 'تبوك',
      'area': 140000.0,
    },
    11: {
      'lat': 27.5117,
      'lng': 41.7214,
      'name': "Ha'il",
      'arabicName': 'حائل',
      'area': 120000.0,
    },
    12: {
      'lat': 26.1523,
      'lng': 43.9640,
      'name': 'Al Quassim',
      'arabicName': 'القصيم',
      'area': 73000.0,
    },
    13: {
      'lat': 30.0561,
      'lng': 42.5197,
      'name': 'Al Hudud ash Shamaliyah',
      'arabicName': 'الحدود الشمالية',
      'area': 111000.0,
    },
    14: {
      'lat': 19.8244,
      'lng': 43.5264,
      'name': 'AlUla',
      'arabicName': 'العلا',
      'area': 225000.0,
    },
  };
}

class SaudiMapCard extends StatefulWidget {
  const SaudiMapCard({super.key});

  @override
  State<SaudiMapCard> createState() => _SaudiMapCardState();
}

class _SaudiMapCardState extends State<SaudiMapCard> {
  MapShapeSource? _backgroundMapDataSource;
  MapShapeSource? _mapDataSource;
  bool _isLoading = true;
  int _selectedIndex = -1;
  late MapZoomPanBehavior _zoomPanBehavior;

  // مثل governorateCenters في كود عمان
  late Map<int, Map<String, dynamic>> governorateCenters;

  // قائمة بأسماء المحافظات كما هي موجودة في ملف GeoJSON
  final List<String> _governorateNamesInGeoJson = [
    'Ar Riyad',
    'Makkah',
    'Al Madinah',
    'Ash Sharqiyah',
    '`Asir',
    'Najran',
    'Jizan',
    'Al Jawf',
    'Tabuk',
    "Ha'il",
    'Al Quassim',
    'Al Hudud ash Shamaliyah',
  ];

  // الأسماء العربية بنفس الترتيب
  final List<String> _arabicNames = [
    'الرياض',
    'مكة المكرمة',
    'المدينة المنورة',
    'المنطقة الشرقية',
    'عسير',
    'نجران',
    'جيزان',
    'الجوف',
    'تبوك',
    'حائل',
    'القصيم',
    'الحدود الشمالية',
  ];

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = MapZoomPanBehavior(
      enableDoubleTapZooming: false,
      enablePanning: false,
      enablePinching: false,
      zoomLevel: 1.5,
    );
    _initializeGovernorateCenters();
    _loadBackgroundMap();
  }

  // تهيئة مراكز المحافظات مثل كود عمان
  void _initializeGovernorateCenters() {
    governorateCenters = {};

    // ربط الأسماء في GeoJson مع الإحداثيات
    for (int i = 0; i < _governorateNamesInGeoJson.length; i++) {
      final govName = _governorateNamesInGeoJson[i];

      // البحث عن الإحداثيات المناسبة
      Map<String, dynamic>? center;
      for (var entry in SaudiGovernorateCenters.centers.entries) {
        if (entry.value['name'] == govName) {
          center = entry.value;
          break;
        }
      }

      if (center != null) {
        governorateCenters[i] = {
          'lat': center['lat'],
          'lng': center['lng'],
          'area': center['area'],
          'name': center['name'],
          'arabicName': center['arabicName'],
        };
      }
    }
  }

  // تحميل خلفية الخريطة
  Future<void> _loadBackgroundMap() async {
    try {
      final backgroundSource = MapShapeSource.asset(
        'assets/map/sa.json', // تأكد من صحة المسار
        shapeDataField: 'name',
        dataCount: _governorateNamesInGeoJson.length,
        primaryValueMapper: (int index) => _governorateNamesInGeoJson[index],
        shapeColorValueMapper: (int index) => 'all',
        shapeColorMappers: [
          MapColorMapper(value: 'all', color: const Color(0xff1A7A5C)),
        ],
      );

      if (mounted) {
        setState(() {
          _backgroundMapDataSource = backgroundSource;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("خطأ في تحميل خلفية الخريطة: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // دالة لحساب حجم النص بناءً على المساحة (مثل كود عمان)
  double _getTextSize(int index) {
    if (governorateCenters.isEmpty) return 12;

    final area = governorateCenters[index]?['area'] as double? ?? 1.0;

    if (area < 50000) {
      return 10.0; // مناطق صغيرة
    } else if (area < 150000) {
      return 12.0; // مناطق متوسطة
    } else if (area < 300000) {
      return 14.0; // مناطق كبيرة
    } else {
      return 16.0; // مناطق كبيرة جداً (الرياض، الشرقية)
    }
  }

  // دالة لإنشاء مصدر الخريطة الرئيسي
  MapShapeSource? _buildMapDataSource(List<GovernorateModel> governorates) {
    try {
      return MapShapeSource.asset(
        'assets/map/sa.json',
        shapeDataField: 'name',
        dataCount: _governorateNamesInGeoJson.length,
        primaryValueMapper: (int index) => _governorateNamesInGeoJson[index],
        shapeColorValueMapper: (int index) => _governorateNamesInGeoJson[index],
        shapeColorMappers: _governorateNamesInGeoJson.map((govName) {
          final gov = governorates.firstWhere(
            (g) => g.name == govName,
            orElse: () =>
                GovernorateModel(id: -1, name: govName, arabicName: ''),
          );

          Color fillColor;
          if (gov.isCurrent || gov.isCompleted) {
            fillColor = const Color(0xff3BFFB7);
          } else if (gov.studentScore > 30) {
            fillColor = const Color(0xff8AFFE2);
          } else {
            fillColor = const Color(0xffFFB547);
          }

          return MapColorMapper(value: govName, color: fillColor);
        }).toList(),
      );
    } catch (e) {
      print("خطأ في بناء مصدر الخريطة: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية (استبدلها بـ BlocBuilder)
    final List<GovernorateModel> governorates = [
      GovernorateModel(
        id: 1,
        name: 'Ar Riyad',
        arabicName: 'الرياض',
        isCurrent: true,
        studentScore: 85,
      ),
      GovernorateModel(
        id: 2,
        name: 'Makkah',
        arabicName: 'مكة المكرمة',
        isCompleted: true,
        studentScore: 92,
      ),
      GovernorateModel(
        id: 3,
        name: 'Al Madinah',
        arabicName: 'المدينة المنورة',
        isCompleted: true,
        studentScore: 78,
      ),
      GovernorateModel(
        id: 4,
        name: 'Ash Sharqiyah',
        arabicName: 'المنطقة الشرقية',
        isCompleted: false,
        studentScore: 45,
      ),
      GovernorateModel(
        id: 5,
        name: '`Asir',
        arabicName: 'عسير',
        isCompleted: false,
        studentScore: 30,
      ),
      GovernorateModel(
        id: 6,
        name: 'Najran',
        arabicName: 'نجران',
        isCompleted: false,
        studentScore: 20,
      ),
      GovernorateModel(
        id: 7,
        name: 'Jizan',
        arabicName: 'جيزان',
        isCompleted: false,
        studentScore: 15,
      ),
      GovernorateModel(
        id: 8,
        name: 'Al Jawf',
        arabicName: 'الجوف',
        isCompleted: false,
        studentScore: 10,
      ),
      GovernorateModel(
        id: 9,
        name: 'Tabuk',
        arabicName: 'تبوك',
        isCompleted: false,
        studentScore: 25,
      ),
      GovernorateModel(
        id: 10,
        name: "Ha'il",
        arabicName: 'حائل',
        isCompleted: false,
        studentScore: 18,
      ),
      GovernorateModel(
        id: 11,
        name: 'Al Quassim',
        arabicName: 'القصيم',
        isCompleted: false,
        studentScore: 22,
      ),
      GovernorateModel(
        id: 12,
        name: 'Al Hudud ash Shamaliyah',
        arabicName: 'الحدود الشمالية',
        isCompleted: false,
        studentScore: 8,
      ),
    ];

    final dynamicMapDataSource = _buildMapDataSource(governorates);

    if (_isLoading || dynamicMapDataSource == null) {
      return Container(
        height: 280.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          color: Colors.black12,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.green),
              SizedBox(height: 15.h),
              Text(
                'جاري تحميل خريطة السعودية...',
                style: TextStyle(color: Colors.green[800], fontSize: 14.sp),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(.05)),
      ),
      child: Stack(
        children: [
          // خريطة الخلفية (مثل كود عمان)
          if (_backgroundMapDataSource != null)
            SfMaps(
              layers: [
                MapShapeLayer(
                  source: _backgroundMapDataSource!,
                  color: const Color(0xff1A7A5C),
                  strokeColor: const Color(0xff18674F),
                  strokeWidth: 1,
                  showDataLabels: false,
                ),
              ],
            ),

          // الخريطة الرئيسية مع الماركرز (مثل كود عمان)
          Positioned.fill(
            child: SfMaps(
              layers: [
                MapShapeLayer(
                  zoomPanBehavior: _zoomPanBehavior,
                  source: dynamicMapDataSource,
                  strokeColor: const Color(0xff18674F),
                  strokeWidth: 1,
                  showDataLabels: false,
                  selectedIndex: _selectedIndex,
                  selectionSettings: MapSelectionSettings(
                    color: const Color(0xff3BFFB7).withOpacity(0.3),
                    strokeColor: const Color(0xff3BFFB7),
                    strokeWidth: 2,
                  ),
                  onSelectionChanged: (int index) {
                    final govName = _governorateNamesInGeoJson[index];
                    final gov = governorates.firstWhere(
                      (g) => g.name == govName,
                      orElse: () => GovernorateModel(
                        id: -1,
                        name: govName,
                        arabicName: '',
                      ),
                    );

                    if (gov.isCurrent || gov.isCompleted) {
                      setState(() => _selectedIndex = index);
                      print("تم النقر على: ${gov.arabicName}");
                    }
                  },
                  // إضافة الماركرز مثل كود عمان بالضبط
                  initialMarkersCount: governorates.length,
                  markerBuilder: (BuildContext context, int index) {
                    final gov = governorates[index];
                    final center = governorateCenters[index];

                    // إخفاء الماركر إذا لم تكن المحافظة مفتوحة أو لا يوجد مركز
                    if (center == null) {
                      return const MapMarker(
                        latitude: 0,
                        longitude: 0,
                        child: SizedBox.shrink(),
                      );
                    }

                    final isOpen = gov.isCurrent || gov.isCompleted;
                    final textSize = _getTextSize(index);

                    // عرض الماركر فقط للمحافظات المفتوحة
                    if (!isOpen) {
                      return const MapMarker(
                        latitude: 0,
                        longitude: 0,
                        child: SizedBox.shrink(),
                      );
                    }

                    return MapMarker(
                      latitude: center['lat'] as double,
                      longitude: center['lng'] as double,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedIndex = index);
                          print("تم النقر على: ${gov.arabicName}");
                          // TODO: إضافة التنقل
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // الدائرة المتوهجة
                            Container(
                              width: 12.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: gov.isCurrent || gov.isCompleted
                                    ? const Color(0xff3BFFB7)
                                    : const Color(0xffFFB547),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (gov.isCurrent || gov.isCompleted
                                                ? const Color(0xff3BFFB7)
                                                : const Color(0xffFFB547))
                                            .withOpacity(0.7),
                                    blurRadius: 18,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            // اسم المحافظة
                            Text(
                              gov.arabicName,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: textSize.sp,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Legend (أسطوانة الألوان)
          Positioned(
            right: 0,
            bottom: 10.h,
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xff121B2D),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withOpacity(.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legendItem("ذروة عالية (مكتملة)", const Color(0xff3BFFB7)),
                  SizedBox(height: 8.h),
                  _legendItem("متوسطة (قيد التقدم)", const Color(0xff8AFFE2)),
                  SizedBox(height: 8.h),
                  _legendItem("منخفضة (لم تبدأ)", const Color(0xffFFB547)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
        ),
        SizedBox(width: 8.w),
        Container(
          width: 10.w,
          height: 10.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ],
    );
  }
}
