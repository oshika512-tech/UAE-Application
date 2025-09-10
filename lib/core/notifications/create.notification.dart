import 'package:awesome_notifications/awesome_notifications.dart';

class CreateNotification {
  static void showNotification(
    String title,
    String body,
    int? id,
  ) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id ?? 1,
        channelKey: 'Local_channel',
        title: title,
        body: body,
        
        notificationLayout: NotificationLayout.BigText,
      ),
    );
  }
}
