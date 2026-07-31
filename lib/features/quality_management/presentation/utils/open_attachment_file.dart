import 'dart:io';
import 'dart:typed_data';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

/// Saves [bytes] under a safe file name and opens with the system app
/// (Word, Excel, PDF viewer, etc.) via [open_filex].
Future<OpenResult> openAttachmentWithSystemApp({
  required List<int> bytes,
  required String fileName,
}) async {
  final safeName = _sanitizeFileName(fileName);
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$safeName');
  await file.writeAsBytes(
    bytes is Uint8List ? bytes : Uint8List.fromList(bytes),
    flush: true,
  );
  return OpenFilex.open(file.path);
}

String _sanitizeFileName(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return 'attachment.bin';
  return trimmed
      .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
      .replaceAll(RegExp(r'\s+'), ' ');
}
