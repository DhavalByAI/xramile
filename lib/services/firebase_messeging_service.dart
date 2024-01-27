import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:xramile/main.dart';

import '../models/notification_data_model.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages
      _handleForegroundMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle messages opened from the notification itself
      _handleForegroundMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _initializeLocalNotifications();
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // Handle background messages
    print("Handling a background message: ${message.data}");
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _selectNotification(String? payload) async {
    if (payload != null) {
      print('Notification tapped with payload: $payload');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notificationData = NotificationData(
      title: message.notification?.title ?? 'Default Title',
      body: message.notification?.body ?? 'Default Body',
      receivedTime: DateTime.now(),
    );
    listOfNotifications.add(notificationData);
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'xarmile_task',
        'xarmile task',
        channelDescription:
            'this is for test notification for xarmile task', // Replace with your own channel description
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        message.notification?.title ?? 'Default Title',
        message.notification?.body ?? 'Default Body',
        platformChannelSpecifics,
        payload: message.data.toString(),
      );
    } catch (e) {
      print('Error handling foreground message: $e');
    }
  }
}
