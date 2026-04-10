enum OrderPickedByType { mr, asm }

extension OrderPickedByTypeX on OrderPickedByType {
  String get label {
    switch (this) {
      case OrderPickedByType.mr:
        return 'MR';
      case OrderPickedByType.asm:
        return 'ASM';
    }
  }
}

enum OrderStatus { pending, packed, outForDelivery, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.packed:
        return 'Packed';
      case OrderStatus.outForDelivery:
        return 'Out for delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class OrderLineItem {
  const OrderLineItem({required this.productName, required this.quantity});

  final String productName;
  final int quantity;

  OrderLineItem copyWith({String? productName, int? quantity}) {
    return OrderLineItem(
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
    );
  }
}

class Order {
  const Order({
    required this.id,
    required this.pickedByType,
    required this.pickedById,
    required this.pickedByName,
    required this.interestedDoctorName,
    required this.products,
    required this.chemistShopName,
    required this.distributorName,
    required this.expectedDeliveryTime,
    required this.status,
    required this.createdAt,
  });

  final String id;

  final OrderPickedByType pickedByType;
  final String pickedById;
  final String pickedByName;

  final String interestedDoctorName;
  final List<OrderLineItem> products;

  final String chemistShopName;
  final String distributorName;
  final DateTime expectedDeliveryTime;

  final OrderStatus status;

  /// Used for filtering by day.
  final DateTime createdAt;

  Order copyWith({
    String? id,
    OrderPickedByType? pickedByType,
    String? pickedById,
    String? pickedByName,
    String? interestedDoctorName,
    List<OrderLineItem>? products,
    String? chemistShopName,
    String? distributorName,
    DateTime? expectedDeliveryTime,
    OrderStatus? status,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      pickedByType: pickedByType ?? this.pickedByType,
      pickedById: pickedById ?? this.pickedById,
      pickedByName: pickedByName ?? this.pickedByName,
      interestedDoctorName: interestedDoctorName ?? this.interestedDoctorName,
      products: products ?? this.products,
      chemistShopName: chemistShopName ?? this.chemistShopName,
      distributorName: distributorName ?? this.distributorName,
      expectedDeliveryTime: expectedDeliveryTime ?? this.expectedDeliveryTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

DateTime orderDayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
