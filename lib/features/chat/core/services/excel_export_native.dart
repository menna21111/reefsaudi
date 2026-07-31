import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Creates an XFile from bytes by writing to a temp file.
/// Used on mobile/desktop where native share sheets require physical paths.
Future<XFile> createXFileFromTempFile(
  List<int> bytes,
  String fileName,
  String mimeType,
) async {
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/$fileName');
  await file.writeAsBytes(bytes);
  return XFile(file.path, mimeType: mimeType);
}
