import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final void Function(DateTime? start, DateTime? end) onDateChanged;

  const CalendarWidget({Key? key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidget();
}

class _CalendarWidget extends State<CalendarWidget> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.initialStartDate;
    _rangeEnd = widget.initialEndDate;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      calendarFormat: CalendarFormat.month,
      rangeSelectionMode: RangeSelectionMode.toggledOn,
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      onRangeSelected: (start, end, focusedDay) {
        setState(() {
          _rangeStart = start;
          _rangeEnd = end;
          _focusedDay = focusedDay;
        });

        // 날짜가 둘 중 하나만 선택되어도 콜백 전달
        widget.onDateChanged(start, end);
      },
    );
  }
}