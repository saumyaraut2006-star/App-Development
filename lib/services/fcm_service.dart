import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Background message handler MUST be a top-level function (not inside a class)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // This runs when a push notification arrives while the app is
  // terminated or in the background.
  // ignore: avoid_print
  print('Background FCM message received: ${message.messageId}');
}

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Call this once during app startup (after Firebase.initializeApp)
  static Future<void> init() async {
    // 1. Request notification permission (required on iOS, Android 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    // ignore: avoid_print
    print('FCM permission status: ${settings.authorizationStatus}');

    // 2. Get the device token — you'd save this to Firestore under the
    // user's profile so a Cloud Function / backend knows where to send pushes
    final token = await _messaging.getToken();
    // ignore: avoid_print
    print('FCM Device Token: $token');

    // 3. Register the background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 4. Handle messages received while app is in the FOREGROUND
    // (FCM does not show a system notification automatically in this case,
    // so we show one manually using flutter_local_notifications)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // ignore: avoid_print
      print('Foreground FCM message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // 5. Handle the case where the user taps a notification and opens the app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // ignore: avoid_print
      print('Notification tapped, app opened: ${message.data}');
      // You could navigate to a specific screen here based on message.data
    });
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'fcm_channel',
      'Firebase Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'SmartInterestX',
      message.notification?.body ?? '',
      details,
    );
  }

  /// Returns the current device's FCM token.
  /// Save this to Firestore (e.g. users/{uid}/fcmToken) so a backend
  /// or Cloud Function can target this device with a push notification.
  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}