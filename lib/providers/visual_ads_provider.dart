import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/visual_ads.dart';

abstract class VisualAdsRepository {
  Future<List<VisualAd>> list();
  Future<void> upsert(VisualAd ad);
  Future<void> delete(String id);
}

class InMemoryVisualAdsRepository implements VisualAdsRepository {
  InMemoryVisualAdsRepository();

  final List<VisualAd> _items = const [
    VisualAd(id: 'va_1', name: 'Summer Campaign', imageBytes: null),
    VisualAd(id: 'va_2', name: 'New Launch Banner', imageBytes: null),
  ];

  @override
  Future<List<VisualAd>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return List<VisualAd>.unmodifiable(_items);
  }

  @override
  Future<void> upsert(VisualAd ad) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final index = _items.indexWhere((e) => e.id == ad.id);
    if (index >= 0) {
      _items[index] = ad;
    } else {
      _items.insert(0, ad);
    }
  }

  @override
  Future<void> delete(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _items.removeWhere((e) => e.id == id);
  }
}

final visualAdsRepositoryProvider = Provider<VisualAdsRepository>((ref) {
  return InMemoryVisualAdsRepository();
});
