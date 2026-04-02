import 'dart:typed_data';

class VisualAd {
  const VisualAd({
    required this.id,
    required this.name,
    required this.imageBytes,
  });

  final String id;
  final String name;
  final Uint8List? imageBytes;

  VisualAd copyWith({String? id, String? name, Uint8List? imageBytes}) {
    return VisualAd(
      id: id ?? this.id,
      name: name ?? this.name,
      imageBytes: imageBytes ?? this.imageBytes,
    );
  }
}
