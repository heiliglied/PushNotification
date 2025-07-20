import 'package:pushnotification/data/database/database.dart';
import 'package:pushnotification/ui/notify/history/historySearch.dart';

class HistoryState {
  final List<NotificationData> notifications;
  final int page;
  final int limit;
  final bool loading;
  final bool allLoaded;
  final HistorySearch condition;

  const HistoryState({
    required this.notifications,
    this.page = 0,
    this.limit = 8,
    this.loading = false,
    this.allLoaded = false,
    this.condition = const HistorySearch()
  });

  HistoryState copyWith({
    List<NotificationData>? notifications,
    int? page,
    int? limit,
    bool? loading,
    bool? allLoaded,
    HistorySearch? search,
  }) {
    return HistoryState(
      notifications: notifications ?? this.notifications,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      loading: loading ?? this.loading,
      allLoaded: allLoaded ?? this.allLoaded,
      condition: search ?? this.condition,
    );
  }
}
