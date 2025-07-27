import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pushnotification/data/database/daos/NotificationDao.dart';
import 'package:pushnotification/data/database/database.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

Future<void> SchedulePushNotification(Database db) async {
  final plugin = FlutterLocalNotificationsPlugin();
  final scheduler = tz.local;
  final dao = NotificationDao(db);
  final List<NotificationData>? notis = await dao.getPushNotification();

  for (final noti in notis!) {
    final plugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin?.zonedSchedule(
      noti.id,
      noti.title,
      noti.contents ?? '',
      tz.TZDateTime.from(noti.date, tz.local),
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
}
