import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pushnotification/data/database/provider/NotificationProvider.dart';
import 'package:pushnotification/ui/notify/history/historyNotifier.dart';
import 'package:pushnotification/ui/notify/history/historyState.dart';

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  final repository = ref.watch(notificationProvider); // repo 주입
  return HistoryNotifier(repository);
});