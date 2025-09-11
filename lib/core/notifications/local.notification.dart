import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  final bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Initialize
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Android initialization
    const initAndroidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // ios initialization

    const initIOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialization settings for both platforms
    const initializationSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIOSSettings,
    );

    //initialize the plugin
    await notificationPlugin.initialize(initializationSettings);
  }

  // notification details
  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: const AndroidNotificationDetails(
        'basic_channel_id',
        'basic channel',
        channelDescription: 'Notification channel for basic messages',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  // Show notification
  Future<void> showNotification(
    int id,
    String title,
    String body,
  ) async {
     return notificationPlugin.show(
      id,
      title,
      body,
      NotificationDetails(),
    );
  }
}
