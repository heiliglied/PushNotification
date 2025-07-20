class HistorySearch {
  final String search;
  final DateTime? start_day;
  final DateTime? end_day;

  const HistorySearch(
    {
      this.search = '',
      this.start_day,
      this.end_day,
    }
  );

  HistorySearch copyWith({
    String? search,
    DateTime? start_day,
    DateTime? end_day,
  }) {
    return HistorySearch(
      search: search ?? this.search,
      start_day: start_day ?? this.start_day,
      end_day: end_day ?? this.end_day,
    );
  }
}