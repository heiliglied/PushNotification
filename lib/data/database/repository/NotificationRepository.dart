import 'dart:async';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pushnotification/data/database/daos/NotificationDao.dart';
import 'package:pushnotification/data/database/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(keepAlive: true)
class NotificationRepository {
  final NotificationDao notificationDao;
  NotificationRepository(this.notificationDao);

  Future<int?> addNotification(Map<String, dynamic> data) async {
    final notificationData = NotificationCompanion(
      date: Value(data['date']),
      title: Value(data['title']),
      contents: Value(data['contents']),
      sound: data['sound'] == '' ? Value('assets/music/Fur Elise (by Beethoven) - Beethoven.mp3') : Value(data['sound']),
      alarm: Value(data['alarm']),
      status: Value(data['status']),
    );

    try {
      return notificationDao.insertNoti(notificationData);
    } on SqliteException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<int?> updateNotification(int id, Map<String, dynamic> data) async {
    try {
      final notificationData = NotificationCompanion(
        date: Value(data['date']),
        title: Value(data['title']),
        contents: Value(data['contents']),
        sound: data['sound'] == '' ? Value('assets/music/Fur Elise (by Beethoven) - Beethoven.mp3') : Value(data['sound']),
        alarm: Value(data['alarm']),
      );

      return notificationDao.updateNoti(id, notificationData);
    } on SqliteException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<int?> updateStatus(int id, Map<String, dynamic> data) async {
    try {
      final notificationData = NotificationCompanion(
        alarm: Value(data['alarm']),
        status: Value(data['status'])
      );
      return notificationDao.updateNoti(id, notificationData);
    } on SqliteException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<NotificationData?> getNotification(int id) async {
    return notificationDao.getNotification(id);
  }

  Future<int?> deleteNotification(int id) async {
    try {
      return notificationDao.deleteNotification(id);
    } on SqliteException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
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
