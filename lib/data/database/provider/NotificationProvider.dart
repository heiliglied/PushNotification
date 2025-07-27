import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pushnotification/data/database/database.dart';
import 'package:pushnotification/data/database/repository/NotificationRepository.dart';
import 'package:pushnotification/data/database/daos/NotificationDao.dart';

final notificationProvider = Provider<NotificationRepository>((ref) {
  final dao = ref.watch(notiDaoProvider);
  final db = ref.watch(databaseProvider);
  return NotificationRepository(dao, db);
});
