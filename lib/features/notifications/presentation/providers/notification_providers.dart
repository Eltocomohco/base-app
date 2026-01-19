import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/notification_service.dart';
import '../../data/repositories/firestore_notification_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'notification_providers.g.dart';

@riverpod
NotificationService notificationService(Ref ref) {
  return NotificationService();
}

@riverpod
NotificationRepository notificationRepository(Ref ref) {
  return FirestoreNotificationRepository(FirebaseFirestore.instance);
}
