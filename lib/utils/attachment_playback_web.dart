import 'dart:typed_data';
import 'dart:html' as html;

class AttachmentPlaybackHandle {
  AttachmentPlaybackHandle._(this._objectUrl) : uri = Uri.parse(_objectUrl);

  final Uri uri;
  final String _objectUrl;

  Future<void> dispose() async {
    html.Url.revokeObjectUrl(_objectUrl);
  }
}

Future<AttachmentPlaybackHandle> createAttachmentPlaybackHandle({
  required Uint8List bytes,
  required String fileName,
  String? mimeType,
}) async {
  final blob = html.Blob(
    <Object>[bytes],
    mimeType ?? 'application/octet-stream',
  );
  final url = html.Url.createObjectUrlFromBlob(blob);
  return AttachmentPlaybackHandle._(url);
}
