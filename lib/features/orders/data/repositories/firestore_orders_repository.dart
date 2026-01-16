import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../orders/domain/entities/order.dart';

abstract class OrdersRepository {
  Future<void> createOrder(OrderEntity order);
  Stream<List<OrderEntity>> getUserOrders(String userId);
}

class FirestoreOrdersRepository implements OrdersRepository {
  final FirebaseFirestore _firestore;

  FirestoreOrdersRepository(this._firestore);

  @override
  Future<void> createOrder(OrderEntity order) async {
    await _firestore.collection('orders').doc(order.id).set(order.toJson());
  }

  @override
  Stream<List<OrderEntity>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderEntity.fromMap(doc.data())).toList();
    });
  }
}
