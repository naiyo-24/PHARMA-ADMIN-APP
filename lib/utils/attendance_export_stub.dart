class AttendanceExportResult {
  const AttendanceExportResult({required this.fileName, this.path});

  final String fileName;
  final String? path;
}

Future<AttendanceExportResult> exportAttendanceCsv({
  required String fileName,
  required String csv,
}) {
  throw UnsupportedError('CSV export is not supported on this platform.');
}
