import 'dart:typed_data';

class AttachmentPlaybackHandle {
  AttachmentPlaybackHandle(this.uri);

  final Uri uri;

  Future<void> dispose() async {}
}

Future<AttachmentPlaybackHandle> createAttachmentPlaybackHandle({
  required Uint8List bytes,
  required String fileName,
  String? mimeType,
}) async {
  // Fallback: best-effort data URI.
  // Some platforms may not support it for media playback.
  final dataUri = Uri.dataFromBytes(
    bytes,
    mimeType: mimeType ?? 'application/octet-stream',
  );
  return AttachmentPlaybackHandle(dataUri);
}
