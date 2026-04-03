import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chemist_shop.dart';

abstract class ChemistShopRepository {
  Future<List<ChemistShop>> list();

  Future<ChemistShop?> findById(String id);
}

class InMemoryChemistShopRepository implements ChemistShopRepository {
  InMemoryChemistShopRepository();

  final List<ChemistShop> _items = List<ChemistShop>.of(<ChemistShop>[
    ChemistShop(
      id: 'cs_1',
      name: 'Srijan Medical Hall',
      address: '12B, Park Street, Kolkata',
      description:
          'A well-stocked chemist shop with a wide range of medicines, OTC products, and quick home delivery support.',
      phoneNumber: '+91 98765 43210',
      email: 'srijanmedical@example.com',
      photoPath: 'assets/images/director.jpeg',
      addedByType: ChemistShopAddedByType.mr,
      addedByName: 'Rahul Das',
    ),
    ChemistShop(
      id: 'cs_2',
      name: 'City Care Pharmacy',
      address: 'Near Bus Stand, Siliguri',
      description:
          'Located near the bus stand. Known for reliable stock availability and prompt order handling.',
      phoneNumber: '+91 91234 56789',
      email: 'citycare@example.com',
      photoPath: '',
      addedByType: ChemistShopAddedByType.asm,
      addedByName: 'Ananya Sen',
    ),
    ChemistShop(
      id: 'cs_3',
      name: 'Green Cross Chemist',
      address: 'MG Road, Durgapur',
      description:
          'A neighborhood chemist shop with a focus on prescription medicines and patient guidance.',
      phoneNumber: '+91 90000 12345',
      email: 'greencross@example.com',
      photoPath: '',
      addedByType: ChemistShopAddedByType.mr,
      addedByName: 'Sourav Paul',
    ),
  ], growable: true);

  @override
  Future<List<ChemistShop>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final items = [..._items]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return List<ChemistShop>.unmodifiable(items);
  }

  @override
  Future<ChemistShop?> findById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}

final chemistShopRepositoryProvider = Provider<ChemistShopRepository>((ref) {
  return InMemoryChemistShopRepository();
});
