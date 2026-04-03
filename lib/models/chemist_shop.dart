enum ChemistShopAddedByType { mr, asm }

extension ChemistShopAddedByTypeX on ChemistShopAddedByType {
  String get label {
    switch (this) {
      case ChemistShopAddedByType.mr:
        return 'MR';
      case ChemistShopAddedByType.asm:
        return 'ASM';
    }
  }
}

class ChemistShop {
  const ChemistShop({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.phoneNumber,
    required this.email,
    required this.photoPath,
    required this.addedByType,
    required this.addedByName,
  });

  final String id;
  final String name;
  final String address;
  final String description;
  final String phoneNumber;
  final String email;

  /// Can be an asset path (e.g. `assets/...`) or a network URL.
  final String photoPath;

  final ChemistShopAddedByType addedByType;
  final String addedByName;

  ChemistShop copyWith({
    String? id,
    String? name,
    String? address,
    String? description,
    String? phoneNumber,
    String? email,
    String? photoPath,
    ChemistShopAddedByType? addedByType,
    String? addedByName,
  }) {
    return ChemistShop(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      photoPath: photoPath ?? this.photoPath,
      addedByType: addedByType ?? this.addedByType,
      addedByName: addedByName ?? this.addedByName,
    );
  }
}
