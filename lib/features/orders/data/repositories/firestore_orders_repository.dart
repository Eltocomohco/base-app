import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../notifications/presentation/services/notification_service.dart';

abstract class OrdersRepository {
  Future<void> createOrder(OrderEntity order);
  Stream<List<OrderEntity>> getUserOrders(String userId);
  Stream<List<OrderEntity>> getAllOrders();
  Future<void> updateOrderStatus(String orderId, String newStatus);
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

  @override
  Stream<List<OrderEntity>> getAllOrders() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderEntity.fromMap(doc.data())).toList();
    });
  }

  @override
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    // Update status in Firestore
    await _firestore.collection('orders').doc(orderId).update({
      'status': newStatus,
    });

    // Send notification to user
    await _sendOrderStatusNotification(orderId, newStatus);
  }

  Future<void> _sendOrderStatusNotification(String orderId, String newStatus) async {
    try {
      // Get order to find userId
      final orderDoc = await _firestore.collection('orders').doc(orderId).get();
      if (!orderDoc.exists) return;

      final userId = orderDoc.data()?['userId'] as String?;
      if (userId == null) return;

      // Get user's FCM token
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final fcmToken = userDoc.data()?['fcmToken'] as String?;
      if (fcmToken == null) return;

      // Prepare notification message
      String title;
      String body;
      
      switch (newStatus) {
        case 'cooking':
          title = '👨‍🍳 ¡Tu pedido está en el horno!';
          body = 'Estamos preparando tu pedido con mucho cariño';
          break;
        case 'delivered':
          title = '✅ ¡Pedido listo!';
          body = 'Tu pedido está listo para recoger';
          break;
        default:
          title = '📦 Actualización de pedido';
          body = 'El estado de tu pedido ha cambiado';
      }

      // Send notification
      await NotificationService().sendToToken(
        fcmToken,
        title,
        body,
        data: {
          'type': 'order_status',
          'orderId': orderId,
          'status': newStatus,
        },
      );
    } catch (e) {
      // Log error but don't fail the status update
      print('Error sending order notification: $e');
    }
  }
}
