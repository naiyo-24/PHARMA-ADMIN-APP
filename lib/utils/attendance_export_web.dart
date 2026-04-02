import 'dart:convert';
import 'dart:html' as html;

class AttendanceExportResult {
  const AttendanceExportResult({required this.fileName, this.path});

  final String fileName;
  final String? path;
}

Future<AttendanceExportResult> exportAttendanceCsv({
  required String fileName,
  required String csv,
}) async {
  final bytes = utf8.encode(csv);
  final blob = html.Blob(<Object>[bytes], 'text/csv;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..download = fileName
    ..style.display = 'none';

  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);

  return AttendanceExportResult(fileName: fileName, path: null);
}
