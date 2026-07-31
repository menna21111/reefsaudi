import '../features/dashboard/data/models/global_statistics_models.dart';

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

  static const Map<String, List<String>> arabicTitlesByCode = {
    'SA01': ['الرياض', 'منطقة الرياض'],
    'SA02': ['مكة', 'مكة المكرمة', 'منطقة مكة'],
    'SA03': ['المدينة', 'المدينة المنورة'],
    'SA04': ['الشرقية', 'المنطقة الشرقية'],
    'SA05': ['القصيم'],
    'SA06': ['حائل'],
    'SA07': ['تبوك'],
    'SA08': ['الحدود الشمالية', 'الشمالية'],
    'SA09': ['جازان', 'جيزان'],
    'SA10': ['نجران'],
    'SA11': ['الباحة'],
    'SA12': ['الجوف'],
    'SA14': ['عسير'],
  };

  static String? regionCodeAt(int index) {
    if (index < 0 || index >= regionCodesByIndex.length) return null;
    return regionCodesByIndex[index];
  }

  static int? indexForRegionCode(String? regionCode) {
    if (regionCode == null || regionCode.isEmpty) return null;
    final index = regionCodesByIndex.indexOf(regionCode);
    return index >= 0 ? index : null;
  }

  static int? indexForArea(AreaProjectDto area) {
    final byCode = indexForRegionCode(area.regionCode);
    if (byCode != null) return byCode;

    final title = area.title.trim().toLowerCase();
    if (title.isEmpty) return null;

    for (final entry in arabicTitlesByCode.entries) {
      for (final name in entry.value) {
        if (title.contains(name.toLowerCase()) ||
            name.toLowerCase().contains(title)) {
          return indexForRegionCode(entry.key);
        }
      }
    }

    for (final entry in englishNamesByCode.entries) {
      final english = entry.value.toLowerCase();
      if (title.contains(english) || english.contains(title)) {
        return indexForRegionCode(entry.key);
      }
    }
    return null;
  }

  static AreaProjectDto? areaForIndex(int index, List<AreaProjectDto> areas) {
    final code = regionCodeAt(index);
    if (code == null) return null;

    final byCode = areaForRegionCode(code, areas);
    if (byCode != null) return byCode;

    final arabicNames = arabicTitlesByCode[code] ?? const <String>[];
    final english = englishNamesByCode[code]?.toLowerCase();

    for (final area in areas) {
      final title = area.title.trim().toLowerCase();
      if (title.isEmpty) continue;

      for (final name in arabicNames) {
        if (title.contains(name.toLowerCase()) ||
            name.toLowerCase().contains(title)) {
          return area;
        }
      }

      if (english != null &&
          (title.contains(english) || english.contains(title))) {
        return area;
      }
    }
    return null;
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
