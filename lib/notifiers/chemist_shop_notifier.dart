import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chemist_shop.dart';

import '../providers/chemist_shop_provider.dart';

class ChemistShopNotifier extends AsyncNotifier<List<ChemistShop>> {
  @override
  Future<List<ChemistShop>> build() async {
    final repo = ref.read(chemistShopRepositoryProvider);
    return repo.list();
  }

  Future<void> refreshList() async {
    state = const AsyncLoading();
    final repo = ref.read(chemistShopRepositoryProvider);
    state = AsyncData(await repo.list());
  }

  Future<ChemistShop?> findById(String id) {
    final repo = ref.read(chemistShopRepositoryProvider);
    return repo.findById(id);
  }
}

final chemistShopNotifierProvider =
    AsyncNotifierProvider<ChemistShopNotifier, List<ChemistShop>>(
      ChemistShopNotifier.new,
    );
