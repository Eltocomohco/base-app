// Simple immutable class - avoiding Freezed to prevent circular dependency issues
class OrderEntity {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final String deliveryAddress;
  final String contactPhone;
  final String paymentMethod;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.deliveryAddress,
    required this.contactPhone,
    required this.paymentMethod,
  });

  // toJson for Firestore
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': items,
    'total': total,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'deliveryAddress': deliveryAddress,
    'contactPhone': contactPhone,
    'paymentMethod': paymentMethod,
  };
  // fromMap for Firestore
  factory OrderEntity.fromMap(Map<String, dynamic> map) {
    return OrderEntity(
      id: (map['id'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      items: ((map['items'] as Iterable?) ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      total: (map['total'] as num? ?? 0.0).toDouble(),
      status: (map['status'] ?? 'pending').toString(),
      createdAt: DateTime.tryParse((map['createdAt'] ?? '').toString()) ?? DateTime.now(),
      deliveryAddress: (map['deliveryAddress'] ?? '').toString(),
      contactPhone: (map['contactPhone'] ?? '').toString(),
      paymentMethod: (map['paymentMethod'] ?? '').toString(),
    );
  }
}
