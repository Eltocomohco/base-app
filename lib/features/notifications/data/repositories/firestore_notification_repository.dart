import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/notification_repository.dart';

class FirestoreNotificationRepository implements NotificationRepository {
  final FirebaseFirestore _firestore;

  FirestoreNotificationRepository(this._firestore);

  @override
  Future<void> saveUserToken(String userId, String token) async {
    await _firestore.collection('users').doc(userId).set({
      'fcmToken': token,
      'tokenUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<String?> getUserToken(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['fcmToken'] as String?;
  }

  @override
  Future<void> sendNotificationToUser(String userId, String title, String body, {Map<String, dynamic>? data}) async {
    // This would typically call a Cloud Function or use FCM Admin SDK
    // For now, we'll store the notification request in Firestore
    // and let a Cloud Function handle the actual sending
    await _firestore.collection('notification_requests').add({
      'userId': userId,
      'title': title,
      'body': body,
      'data': data,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }

  @override
  Future<void> sendNotificationToAll(String title, String body, {Map<String, dynamic>? data}) async {
    // Store broadcast request
    await _firestore.collection('notification_requests').add({
      'type': 'broadcast',
      'title': title,
      'body': body,
      'data': data,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }
}
