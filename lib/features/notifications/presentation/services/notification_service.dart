import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // Firebase Server Key - IMPORTANT: In production, use Cloud Functions instead
  // This is just for demo purposes
  static const String _serverKey = 'YOUR_SERVER_KEY_HERE'; // User will need to add this

  Future<void> initialize() async {
    // Request permission
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ Notification permission granted');
    }

    // Initialize local notifications for foreground
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Get FCM token
    _fcmToken = await _fcm.getToken();
    debugPrint('📱 FCM Token: $_fcmToken');

    // Listen for token refresh
    _fcm.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      debugPrint('🔄 FCM Token refreshed: $newToken');
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Subscribe to general marketing topic
    await _fcm.subscribeToTopic('market');
    debugPrint('📢 Subscribed to marketing topic');
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('📬 Foreground message: ${message.notification?.title}');
    
    // Show local notification
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Nueva notificación',
      message.notification?.body ?? '',
      details,
      payload: jsonEncode(message.data),
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('📭 Message opened app: ${message.notification?.title}');
    // Handle navigation based on message.data
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
    // Handle navigation
  }

  // Send notification to specific token
  Future<bool> sendToToken(String token, String title, String body, {Map<String, dynamic>? data}) async {
    if (_serverKey == 'YOUR_SERVER_KEY_HERE') {
      debugPrint('⚠️ Server key not configured. Skipping notification send.');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'to': token,
          'notification': {
            'title': title,
            'body': body,
            'sound': 'default',
          },
          'data': data ?? {},
          'priority': 'high',
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Notification sent successfully');
        return true;
      } else {
        debugPrint('❌ Failed to send notification: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error sending notification: $e');
      return false;
    }
  }

  // Send to multiple tokens
  Future<void> sendToMultipleTokens(List<String> tokens, String title, String body, {Map<String, dynamic>? data}) async {
    for (final token in tokens) {
      await sendToToken(token, title, body, data: data);
      await Future.delayed(const Duration(milliseconds: 100)); // Rate limiting
    }
  }

  // Send to topic (Marketing)
  Future<bool> sendToTopic(String topic, String title, String body, {Map<String, dynamic>? data}) async {
    if (_serverKey == 'YOUR_SERVER_KEY_HERE') {
      debugPrint('⚠️ Server key not configured. Skipping notification send.');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'to': '/topics/$topic',
          'notification': {
            'title': title,
            'body': body,
            'sound': 'default',
          },
          'data': data ?? {},
          'priority': 'high',
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Broadcast sent to topic: $topic');
        return true;
      } else {
        debugPrint('❌ Failed to send broadcast: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error sending broadcast: $e');
      return false;
    }
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background message: ${message.notification?.title}');
}
