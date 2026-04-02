import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/visual_ads.dart';
import '../providers/visual_ads_provider.dart';

class VisualAdsNotifier extends AsyncNotifier<List<VisualAd>> {
  @override
  Future<List<VisualAd>> build() async {
    final repo = ref.read(visualAdsRepositoryProvider);
    return repo.list();
  }

  Future<void> refreshList() async {
    state = const AsyncLoading();
    final repo = ref.read(visualAdsRepositoryProvider);
    state = AsyncData(await repo.list());
  }

  Future<void> upsert(VisualAd ad) async {
    final repo = ref.read(visualAdsRepositoryProvider);
    await repo.upsert(ad);
    await refreshList();
  }

  Future<void> delete(String id) async {
    final repo = ref.read(visualAdsRepositoryProvider);
    await repo.delete(id);
    await refreshList();
  }
}

final visualAdsNotifierProvider =
    AsyncNotifierProvider<VisualAdsNotifier, List<VisualAd>>(
      VisualAdsNotifier.new,
    );
