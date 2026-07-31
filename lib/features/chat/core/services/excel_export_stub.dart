import 'package:share_plus/share_plus.dart';

/// Stub for web - never called since we use XFile.fromData on web.
Future<XFile> createXFileFromTempFile(
  List<int> bytes,
  String fileName,
  String mimeType,
) async {
  throw UnsupportedError('Not used on web');
}
