import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const initAndroidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initIOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIOSSettings,
    );

    await notificationPlugin.initialize(initializationSettings);
    _isInitialized = true;  
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'basic_channel_id',
        'basic channel',
        channelDescription: 'Notification channel for basic messages',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification(int id, String title, String body) async {
    await notificationPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }


  // Request permission for Android 13+ and iOS
  Future<void> requestPermission() async {
    // Android 13+
    final androidPlugin =
        notificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    // iOS
    final iosPlugin =
        notificationPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


}
