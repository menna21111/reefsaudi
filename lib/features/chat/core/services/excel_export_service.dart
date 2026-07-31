import 'package:reefsaudia/features/chat/core/services/excel_export_native.dart'
    if (dart.library.js_interop) 'package:reefsaudia/features/chat/core/services/excel_export_stub.dart'
    as native;
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

class ExcelExportService {
  static Future<bool> exportTableFromMarkdown(String markdownText) async {
    try {
      final lines = markdownText.split(RegExp(r'\r?\n'));

      final tableLines = lines.where((line) {
        final trimmed = line.trim();
        if (!trimmed.contains('|')) {
          return false;
        }
        final contentWithoutFormatting =
            trimmed.replaceAll(RegExp(r'[\|\-\:\s]'), '');
        return contentWithoutFormatting.isNotEmpty;
      }).toList();

      if (tableLines.isEmpty) {
        return false;
      }

      final excel = Excel.createExcel();
      final defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
      final sheetObject = excel[defaultSheet]..isRTL = true;

      var columnCount = 0;

      for (final line in tableLines) {
        // 1. Clean up pipes AND strip markdown formatting (** or __) from
        // cell content
        final cells = line.split('|').map((c) {
          return c.replaceAll(RegExp('[*_#`]'), '').trim();
        }).toList();

        if (cells.isNotEmpty && cells.first.isEmpty) {
          cells.removeAt(0);
        }
        if (cells.isNotEmpty && cells.last.isEmpty) {
          cells.removeLast();
        }

        if (columnCount == 0) {
          columnCount = cells.length;
        }

        sheetObject.appendRow(cells.map(TextCellValue.new).toList());
      }

      // 2. Auto-expand columns to make the table look spacious and readable
      for (var i = 0; i < columnCount; i++) {
        sheetObject.setColumnWidth(i, 30);
      }

      // 3. Smart Contextual File Naming
      final fileName = _generateFileName(markdownText);
      excel.rename(defaultSheet, 'البيانات');

      final bytes = excel.encode();
      if (bytes == null) {
        return false;
      }

      const mimeType =
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      late final XFile xFile;

      if (kIsWeb) {
        xFile = XFile.fromData(
          Uint8List.fromList(bytes),
          mimeType: mimeType,
          name: fileName,
        );
      } else {
        xFile = await native.createXFileFromTempFile(
          bytes,
          fileName,
          mimeType,
        );
      }

      final params = ShareParams(
        files: [xFile],
        fileNameOverrides: [fileName],
      );
      await SharePlus.instance.share(params);
      return true;
    } catch (e, stackTrace) {
      debugPrint('Excel Export Error: $e\n$stackTrace');
      return false;
    }
  }

  /// Extracts the subject from the paragraph preceding the table
  static String _generateFileName(String text) {
    var baseName = 'بيانات_الجدول';
    final lines = text.split(RegExp(r'\r?\n'));

    for (final line in lines) {
      // Find the intro sentence (usually ends with a colon)
      if (line.contains(':') && !line.contains('|')) {
        var title = line.split(':').first;

        // Strip AI conversational filler words
        const fillerPattern =
            'أبشر|من عيوني|هذا الجدول|فيه|يوضح|إليك|التالية|بالنسبة لـ|،|,|:';
        title = title.replaceAll(RegExp(fillerPattern), '').trim();

        if (title.isNotEmpty) {
          baseName = title;
          break;
        }
      }
    }

    baseName = baseName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '');
    baseName = baseName.replaceAll(' ', '_');

    if (baseName.length > 40) {
      baseName = baseName.substring(0, 40).trim();
    }
    while (baseName.endsWith('_')) {
      baseName = baseName.substring(0, baseName.length - 1);
    }

    final timestamp =
        DateTime.now().millisecondsSinceEpoch.toString().substring(9);
    return '${baseName}_$timestamp.xlsx';
  }
}
