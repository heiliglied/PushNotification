import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pushnotification/data/database/database.dart';
import 'package:pushnotification/ui/components/basedrawer.dart';
import 'package:pushnotification/ui/components/emptypage.dart';
import 'package:pushnotification/ui/components/detailbottomsheet.dart';
import 'package:intl/intl.dart';
import 'package:pushnotification/ui/notify/history/historyPaginationProvider.dart';
import 'package:pushnotification/ui/notify/history/historyProvider.dart';
import 'package:pushnotification/ui/notify/history/historySearch.dart';

import 'package:pushnotification/ui/components/calendarWidget.dart';

class History extends ConsumerStatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  ConsumerState<History> createState() => _History();
}

class _History extends ConsumerState<History> {
  Widget emptyPage = EmptyPage();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final pagination = ref.read(historyPaginationProvider);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        pagination.fetchNextThrottled();
      }
    });

    Future.microtask(() {
      pagination.fetchNextThrottled();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget addlistView(List<NotificationData> notiList) {
    return ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          DateTime date = notiList[index].date;
          String format = DateFormat('yyyy-MM-dd HH:mm').format(date);
          return GestureDetector(
              onTap: () async {
                DetailBottomSheet()
                  ..showBottomSheet(context, notiList[index], index, ref).then((value) {
                    if (mounted && value != null) {
                      setState(() {
                        notiList.removeAt(value);
                      });
                    }
                  });
              },
              child: Card(
                  child: SizedBox(
                      height: 80,
                      child: ListTile(
                        title: Text("지정시간 : $format"),
                        subtitle: Text("알림 : ${notiList[index].title}"),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                      ))));
        },
        itemCount: notiList.length);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyProvider);
    final notifications = state.notifications;

    return PopScope(
        canPop: true,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("알림 내역"),
            ),
            drawer: const BaseDrawer(),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: SearchBar(
                    trailing: [
                      const Icon(Icons.search),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? start;
                          DateTime? end;

                          final result = await showDialog<Map<String, DateTime?>>(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                insetPadding: const EdgeInsets.all(24),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                  constraints: const BoxConstraints(maxWidth: 400),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CalendarWidget(
                                        initialStartDate: state.condition.start_day,
                                        initialEndDate: state.condition.end_day,
                                        onDateChanged: (s, e) {
                                          start = s;
                                          end = e;
                                        },
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            child: const Text("취소"),
                                            onPressed: () => Navigator.of(context).pop(null),
                                          ),
                                          ElevatedButton(
                                            child: const Text("확정"),
                                            onPressed: () {
                                              Navigator.of(context).pop({
                                                'start': start,
                                                'end': end,
                                              });
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                          if (result != null) {
                            final notifier = ref.read(historyProvider.notifier);
                            final pagination = ref.read(historyPaginationProvider);

                            final newCondition = state.condition.copyWith(
                              start_day: result['start'],
                              end_day: result['end'],
                            );

                            notifier.reset(condition: newCondition);
                            pagination.fetchNextThrottled();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.restart_alt),
                        tooltip: '검색 조건 초기화',
                        onPressed: () {
                          final notifier = ref.read(historyProvider.notifier);
                          final pagination = ref.read(historyPaginationProvider);

                          notifier.reset(
                            condition: const HistorySearch(),
                          );
                          pagination.fetchNextThrottled();
                        },
                      ),
                    ],
                    onSubmitted: (value) {
                      final notifier = ref.read(historyProvider.notifier);
                      final pagination = ref.read(historyPaginationProvider);

                      final newCondition = state.condition.copyWith(
                        search: value,
                        start_day: state.condition.start_day,
                        end_day: state.condition.end_day,
                      );

                      notifier.reset(condition: newCondition);
                      pagination.fetchNextThrottled();
                    },
                  ),
                ),
                Expanded(
                  child: notifications.isEmpty
                      ? Center(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: emptyPage,
                    ),
                  )
                      : Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: addlistView(notifications), // ListView.builder를 직접 사용
                  ),
                ),
              ],
            )));
  }
}