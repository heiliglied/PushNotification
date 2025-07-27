import 'dart:async';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pushnotification/data/database/daos/NotificationDao.dart';
import 'package:pushnotification/data/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:pushnotification/extra/NotificationHelper.dart';

@Riverpod(keepAlive: true)
class NotificationRepository {
  final Database db;
  final NotificationDao notificationDao;
  NotificationRepository(this.notificationDao, this.db);

  Future<int?> addNotificationWithAlarm(Map<String, dynamic> data) async {
    return await db.transaction(() async {
      final notificationData = NotificationCompanion(
        date: Value(data['date']),
        title: Value(data['title']),
        contents: Value(data['contents']),
        alarm: Value(data['alarm']),
      );

      final insertedId = await notificationDao.insertNoti(notificationData);

      if (data['alarm'] == true) {
        await scheduleNotification(
          id: insertedId,
          title: data['title'],
          body: data['contents'],
          dateTime: data['date'],
        );
      }
      return insertedId;
    });
  }

  Future<void> updateNotificationWithAlarm(
      int notiId,
      Map<String, dynamic> data,
      ) async {
    await db.transaction(() async {
      final updateData = NotificationCompanion(
        date: Value(data['date']),
        title: Value(data['title']),
        contents: Value(data['contents']),
        alarm: Value(data['alarm']),
      );

      await notificationDao.updateNoti(notiId, updateData);
      if (data['alarm'] == true) {
        await scheduleNotification(
          id: notiId,
          title: data['title'],
          body: data['contents'],
          dateTime: data['date'],
        );
      } else {
        await cancelNotification(notiId);
      }
    });
  }

  Future<void> updateStatusWithAlarm(int notiId, Map<String, dynamic> data) async {
    await db.transaction(() async {
      final updateData = NotificationCompanion(
        alarm: Value(data['alarm']),
      );

      await notificationDao.updateNoti(notiId, updateData);

      if (data['alarm'] == false) {
        await cancelNotification(notiId); // 실제 알림 취소
      } else {
        final noti = await notificationDao.getNotification(notiId);
        if (noti != null) {
          await scheduleNotification(
            id: notiId,
            title: noti.title,
            body: noti.contents,
            dateTime: noti.date,
          );
        }
      }
    });
  }

  Future<NotificationData?> getNotification(int id) async {
    return notificationDao.getNotification(id);
  }

  Future<void> deleteNotificationWithAlarm(int id) async {
    await db.transaction(() async {
      await notificationDao.deleteNotification(id);
      await cancelNotification(id);
    });
  }

  Future<List<NotificationData>?> getAllNotification(int page, int limit, String search, DateTime? start_day, DateTime? end_day) async {
    try {
      return notificationDao.getAllNotification(page, limit, search, start_day, end_day);
    } on SqliteException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }
}
