import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AttendanceExportResult {
  const AttendanceExportResult({required this.fileName, this.path});

  final String fileName;
  final String? path;
}

Future<AttendanceExportResult> exportAttendanceCsv({
  required String fileName,
  required String csv,
}) async {
  final dir = await _resolveExportDirectory();
  final safeName = fileName
      .trim()
      .replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')
      .replaceAll(RegExp(r'_+'), '_');
  final path = '${dir.path}${Platform.pathSeparator}$safeName';
  final file = File(path);
  await file.writeAsBytes(utf8.encode(csv), flush: true);
  return AttendanceExportResult(fileName: safeName, path: path);
}

Future<Directory> _resolveExportDirectory() async {
  try {
    final downloads = await getDownloadsDirectory();
    if (downloads != null) return downloads;
  } catch (_) {
    // ignore
  }

  try {
    return await getApplicationDocumentsDirectory();
  } catch (_) {
    return await getTemporaryDirectory();
  }
}
