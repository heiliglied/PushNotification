import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required DateTime dateTime,
}) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(dateTime, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel',
        '예약 알림',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: null,
  );
}

Future<void> cancelNotification(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

Future<void> updateNotification({
  required int id,
  required String title,
  required String body,
  required DateTime newDateTime,
}) async {
  await cancelNotification(id);
  await scheduleNotification(
    id: id,
    title: title,
    body: body,
    dateTime: newDateTime,
  );
}