import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class AttachmentPlaybackHandle {
  AttachmentPlaybackHandle._(this.uri);

  final Uri uri;

  Future<void> dispose() async {}
}

Future<AttachmentPlaybackHandle> createAttachmentPlaybackHandle({
  required Uint8List bytes,
  required String fileName,
  String? mimeType,
}) async {
  final dir = await getTemporaryDirectory();
  final safeName = fileName
      .trim()
      .replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')
      .replaceAll(RegExp(r'_+'), '_');
  final ts = DateTime.now().millisecondsSinceEpoch;
  final path =
      '${dir.path}${Platform.pathSeparator}team_media_${ts}_$safeName';
  final file = File(path);
  await file.writeAsBytes(bytes, flush: true);
  return AttachmentPlaybackHandle._(file.uri);
}
