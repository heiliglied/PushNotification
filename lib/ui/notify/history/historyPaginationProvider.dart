import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pushnotification/ui/notify/history/historyNotifier.dart';
import 'package:pushnotification/ui/notify/history/historyState.dart';
import 'package:pushnotification/services/PaginationService.dart';
import 'package:pushnotification/ui/notify/history/historyProvider.dart';

final historyPaginationProvider = Provider<PaginationService<HistoryNotifier, HistoryState>>((ref) {
  final notifier = ref.read(historyProvider.notifier) as HistoryNotifier;

  return PaginationService<HistoryNotifier, HistoryState>(
    notifier: notifier,
    fetchNextFn: (n) => n.fetchNext(),
  );
});
