import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationService<N extends StateNotifier<S>, S> {
  final N notifier;
  final Future<void> Function(N notifier) fetchNextFn;

  PaginationService({
    required this.notifier,
    required this.fetchNextFn,
    Duration throttleDuration = const Duration(milliseconds: 500),
  }) {
    _throttle = Throttle<void>(
      throttleDuration,
      initialValue: null,
      checkEquality: false,
    )..values.listen((_) => fetchNextFn(notifier));
  }

  late final Throttle<void> _throttle;

  void fetchNextThrottled() {
    _throttle.setValue(null);
  }
}
