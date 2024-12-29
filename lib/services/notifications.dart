import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Message received in background: ${message.notification?.title}');

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'admin_notifications',
      title: message.notification?.title ?? 'No title',
      body: message.notification?.body ?? 'No body',
      notificationLayout: NotificationLayout.Default,
    ),
  );
}
