abstract class NotificationRepository {
  Future<void> saveUserToken(String userId, String token);
  Future<String?> getUserToken(String userId);
  Future<void> sendNotificationToUser(String userId, String title, String body, {Map<String, dynamic>? data});
  Future<void> sendNotificationToAll(String title, String body, {Map<String, dynamic>? data});
}
