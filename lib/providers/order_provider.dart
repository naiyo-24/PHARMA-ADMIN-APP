import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order.dart';

abstract class OrderRepository {
  Future<List<Order>> list();

  Future<Order?> findById(String id);

  Future<void> upsert(Order order);

  Future<void> delete(String id);
}

class InMemoryOrderRepository implements OrderRepository {
  InMemoryOrderRepository();

  final List<Order> _items = List<Order>.of(<Order>[
    Order(
      id: 'ord_2001',
      pickedByType: OrderPickedByType.mr,
      pickedById: 'mr_1',
      pickedByName: 'Rahul Sharma',
      interestedDoctorName: 'Dr. Ananya Bose',
      products: const [
        OrderLineItem(productName: 'CardioPlus 10mg', quantity: 2),
        OrderLineItem(productName: 'VitaBoost Syrup', quantity: 1),
      ],
      chemistShopName: 'Medico Chemist - Salt Lake',
      distributorName: 'Eastern Distributors',
      expectedDeliveryTime: DateTime.now().add(
        const Duration(days: 1, hours: 3),
      ),
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    Order(
      id: 'ord_2002',
      pickedByType: OrderPickedByType.asm,
      pickedById: 'asm_1',
      pickedByName: 'Amit Singh',
      interestedDoctorName: 'Dr. Rakesh Mehta',
      products: const [
        OrderLineItem(productName: 'GlucoCare Strips', quantity: 4),
        OrderLineItem(productName: 'DiabetEase 500mg', quantity: 2),
        OrderLineItem(productName: 'OmegaPlus Capsules', quantity: 1),
      ],
      chemistShopName: 'City Care Pharmacy',
      distributorName: 'North Star Distribution',
      expectedDeliveryTime: DateTime.now().add(
        const Duration(days: 2, hours: 1),
      ),
      status: OrderStatus.packed,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
    Order(
      id: 'ord_2003',
      pickedByType: OrderPickedByType.mr,
      pickedById: 'mr_2',
      pickedByName: 'Sneha Das',
      interestedDoctorName: 'Dr. Priyanka Sen',
      products: const [
        OrderLineItem(productName: 'AntiBact 250mg', quantity: 5),
      ],
      chemistShopName: 'HealthMart Chemist',
      distributorName: 'Metro Pharma Supply',
      expectedDeliveryTime: DateTime.now().add(const Duration(hours: 16)),
      status: OrderStatus.outForDelivery,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
    ),
    Order(
      id: 'ord_2004',
      pickedByType: OrderPickedByType.asm,
      pickedById: 'asm_2',
      pickedByName: 'Priya Nair',
      interestedDoctorName: 'Dr. Kunal Roy',
      products: const [
        OrderLineItem(productName: 'PainRelief Gel', quantity: 3),
        OrderLineItem(productName: 'ColdEase Tablets', quantity: 2),
      ],
      chemistShopName: 'Apollo Chemists - Park Street',
      distributorName: 'Eastern Distributors',
      expectedDeliveryTime: DateTime.now().subtract(const Duration(hours: 2)),
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 6, hours: 3)),
    ),
  ], growable: true);

  @override
  Future<List<Order>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final items = [..._items]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List<Order>.unmodifiable(items);
  }

  @override
  Future<Order?> findById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> upsert(Order order) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final index = _items.indexWhere((e) => e.id == order.id);
    if (index >= 0) {
      _items[index] = order;
    } else {
      _items.insert(0, order);
    }
  }

  @override
  Future<void> delete(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _items.removeWhere((e) => e.id == id);
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return InMemoryOrderRepository();
});
