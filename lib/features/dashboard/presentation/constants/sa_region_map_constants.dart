import '../../data/models/global_statistics_models.dart';

/// Region order matches [assets/map/sa.json] feature order (Syncfusion index).
class SaRegionMapConstants {
  static const int regionCount = 13;

  static const List<String> regionCodesByIndex = [
    'SA04', // Ash Sharqiyah
    'SA08', // Al Hudud ash Shamaliyah
    'SA12', // Al Jawf
    'SA10', // Najran
    'SA14', // `Asir
    'SA09', // Jizan
    'SA07', // Tabuk
    'SA03', // Al Madinah
    'SA02', // Makkah
    'SA01', // Ar Riyad
    'SA05', // Al Quassim
    'SA06', // Ha'il
    'SA11', // Al Bahah
  ];

  static const Map<String, String> englishNamesByCode = {
    'SA01': 'Ar Riyad',
    'SA02': 'Makkah',
    'SA03': 'Al Madinah',
    'SA04': 'Ash Sharqiyah',
    'SA05': 'Al Quassim',
    'SA06': "Ha'il",
    'SA07': 'Tabuk',
    'SA08': 'Al Hudud ash Shamaliyah',
    'SA09': 'Jizan',
    'SA10': 'Najran',
    'SA11': 'Al Bahah',
    'SA12': 'Al Jawf',
    'SA14': '`Asir',
  };

  static String? regionCodeAt(int index) {
    if (index < 0 || index >= regionCodesByIndex.length) return null;
    return regionCodesByIndex[index];
  }

  static int? indexForRegionCode(String? regionCode) {
    if (regionCode == null) return null;
    return regionCodesByIndex.indexOf(regionCode);
  }

  static AreaProjectDto? areaForIndex(
    int index,
    List<AreaProjectDto> areas,
  ) {
    final code = regionCodeAt(index);
    if (code == null) return null;
    return areaForRegionCode(code, areas);
  }

  static AreaProjectDto? areaForRegionCode(
    String regionCode,
    List<AreaProjectDto> areas,
  ) {
    for (final area in areas) {
      if (area.regionCode == regionCode) return area;
    }
    return null;
  }

  static int projectCountForIndex(int index, List<AreaProjectDto> areas) {
    return areaForIndex(index, areas)?.count ?? 0;
  }
}
