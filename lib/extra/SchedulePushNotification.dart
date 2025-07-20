import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pushnotification/data/database/daos/NotificationDao.dart';
import 'package:pushnotification/data/database/database.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> SchedulePushNotification(Database db) async {
  final plugin = FlutterLocalNotificationsPlugin();
  final scheduler = tz.local;
  final dao = NotificationDao(db);
  final List<NotificationData>? notis = await dao.getPushNotification();

  for (final noti in notis!) {
    final plugin = FlutterLocalNotificationsPlugin();
    final androidPlugin = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.zonedSchedule(
      noti.id,
      noti.title,
      noti.contents ?? '',
      tz.TZDateTime.from(noti.date, tz.local),
      const AndroidNotificationDetails(
        'scheduled_channel',
        '예약 알림',
        importance: Importance.high,
        priority: Priority.high,
      ),
      scheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // 필수
      //payload: 'your payload', // 선택
      matchDateTimeComponents: null, // 반복 없으면 null
    );
  }
}
