import 'package:drift/drift.dart';
import 'package:pushnotification/data/database/database.dart';
import 'package:pushnotification/data/database/migrations/Notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'NotificationDao.g.dart';

@DriftAccessor(tables: [Notification])
class NotificationDao extends DatabaseAccessor<Database> with _$NotificationDaoMixin{
  NotificationDao(Database db): super(db);

  Future<int> insertNoti(NotificationCompanion notiCompanion) => into(notification).insert(notiCompanion);

  Stream<List<NotificationData>>? getNotNotifiedNotiPaginationStream(int page, int limit) {
    final query = (select(notification)
      ..where((t) => t.status.equals(true) & t.date.isBiggerThanValue(DateTime.now()))
      ..limit(limit, offset: page * limit)
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]));

    return query.watch();
  }

  Future<List<NotificationData>>? getNotificationList(int page, int limit) {
    final query = (select(notification)
      ..where((t) => t.status.equals(true) & t.date.isBiggerThanValue(DateTime.now()))
      ..limit(limit, offset: page * limit)
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]));

    return query.get();
  }

  Future<NotificationData?> getNotification(int id) {
    final query = (select(notification)
      ..where((t) => t.id.equals(id))..limit(1));

    return query.getSingleOrNull();
  }

  Future<int> updateNoti(int id, NotificationCompanion notiCompanion) => (update(notification) ..where((t) => t.id.equals(id))).write(notiCompanion);

  Future<int> deleteNotification(int id) => (delete(notification)..where((t) => t.id.equals(id))).go();

  Future<List<NotificationData>>? getAllNotification(int page, int limit, String search, DateTime? start_day, DateTime? end_day) {
    final query = (select(notification)
      ..where((t) {
        final textMatch = t.title.like('%$search%') | t.contents.like('%$search%');
        // 날짜 필터가 있으면 함께 and로 묶고, 아니면 텍스트 필터만
        // 날짜 조건 조합
        final dateConditions = <Expression<bool>>[];

        if (start_day != null) {
          dateConditions.add(t.date.isBiggerOrEqualValue(start_day));
        }
        if (end_day != null) {
          dateConditions.add(t.date.isSmallerOrEqualValue(end_day));
        }

        final dateFilter = dateConditions.isNotEmpty
            ? dateConditions.reduce((a, b) => a & b)
            : const Constant(true); // 아무 조건도 없으면 항상 true

        return textMatch & dateFilter;

      })
      ..limit(limit, offset: page * limit)
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)]));

    return query.get();
  }

  Future<List<NotificationData>>? getPushNotification() {
    final query = (select(notification)
      ..where((t) =>
        t.date.isBiggerThanValue(DateTime.now()) &
        t.alarm.equals(true)
      )
    );

    return query.get();
  }
}

final notiDaoProvider = Provider<NotificationDao>((ref) {
  final notificationProvider = ref.watch(databaseProvider);
  return NotificationDao(notificationProvider);
});