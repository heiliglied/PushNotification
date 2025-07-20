import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pushnotification/ui/notify/history/historySearch.dart';
import 'package:pushnotification/ui/notify/history/historyState.dart';
import 'package:pushnotification/data/database/repository/NotificationRepository.dart';

class HistoryNotifier extends StateNotifier<HistoryState>{
  final NotificationRepository notificationRepository;
  HistoryNotifier(this.notificationRepository) : super(const HistoryState(notifications: []));

  Future<void> fetchNext() async {
    if (state.loading || state.allLoaded) return;
    state = state.copyWith(loading: true);
    final data = await notificationRepository.getAllNotification(
        state.page, state.limit, state.condition.search, state.condition.start_day, state.condition.end_day);

    if (data == null || data.isEmpty) {
      state = state.copyWith(loading: false, allLoaded: true);
    } else {
      state = state.copyWith(
        loading: false,
        notifications: [...state.notifications, ...data],
        page: state.page + 1,
      );
    }
  }

  void reset({HistorySearch? condition}) {
    state = HistoryState(
      notifications: [],
      page: 0,
      limit: state.limit,
      loading: false,
      allLoaded: false,
      condition: condition ?? state.condition
    );
  }
}