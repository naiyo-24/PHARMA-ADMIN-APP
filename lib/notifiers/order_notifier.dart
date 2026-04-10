import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order.dart';
import '../providers/order_provider.dart';

class OrderNotifier extends AsyncNotifier<List<Order>> {
  @override
  Future<List<Order>> build() async {
    final repo = ref.read(orderRepositoryProvider);
    return repo.list();
  }

  Future<void> refreshList() async {
    state = const AsyncLoading();
    final repo = ref.read(orderRepositoryProvider);
    state = AsyncData(await repo.list());
  }

  Future<Order?> findById(String id) {
    final repo = ref.read(orderRepositoryProvider);
    return repo.findById(id);
  }

  Future<void> upsert(Order order) async {
    final repo = ref.read(orderRepositoryProvider);
    await repo.upsert(order);
    await refreshList();
  }

  Future<void> delete(String id) async {
    final repo = ref.read(orderRepositoryProvider);
    await repo.delete(id);
    await refreshList();
  }

  Future<void> updateStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    final repo = ref.read(orderRepositoryProvider);
    final current = await repo.findById(orderId);
    if (current == null) return;
    await repo.upsert(current.copyWith(status: status));
    await refreshList();
  }
}

final orderNotifierProvider = AsyncNotifierProvider<OrderNotifier, List<Order>>(
  OrderNotifier.new,
);
