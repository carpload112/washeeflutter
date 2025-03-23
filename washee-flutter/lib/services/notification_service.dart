import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      
      // Initialize local notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
          
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();
          
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      
      await _localNotifications.initialize(initializationSettings);
      
      // Handle messages when app is in foreground
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Get the token
      String? token = await _messaging.getToken();
      print('FCM Token: $token');
    } else {
      print('User declined permission');
    }
  }
  
  void _handleForegroundMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      _showLocalNotification(message);
    }
  }
  
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'washee_channel',
            'Washee Notifications',
            channelDescription: 'Notifications from Washee app',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: message.data['screen'],
      );
    }
  }
  
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }
  
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}

