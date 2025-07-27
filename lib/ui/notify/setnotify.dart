import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pushnotification/ui/components/basedrawer.dart';
import 'package:pushnotification/extra/UniDialog.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:pushnotification/data/database/provider/NotificationProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pushnotification/extra/NotificationHelper.dart';

class SetNotify extends ConsumerStatefulWidget
{
  const SetNotify({Key? key}) : super(key: key);

  @override
  ConsumerState<SetNotify> createState() => _SetNotify();
}

class _SetNotify extends ConsumerState<SetNotify> {
  bool isInit = true;
  DateTime alertDate = DateTime.now();
  TimeOfDay alertTime = TimeOfDay.now();
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController alertName = TextEditingController();
  TextEditingController alertContents = TextEditingController();
  bool alert = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double widgetWidth = MediaQuery
        .of(context)
        .size
        .width;
    double widgetHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("알림 작성"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pushNamed('main');
              //Navigator.pushNamed(context, Routes.mainPage);
            }
        ),
      ),
      endDrawer: const BaseDrawer(),
      body: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                      width: widgetWidth,
                      //height: widgetHeight - AppBar().preferredSize.height,
                      child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '신규 알림 작성',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24.0),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                controller: dateinput,
                                readOnly: true,
                                //obscureText: true,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '날짜 선택'
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    locale: const Locale('ko', 'KR'),
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    //firstDate: DateTime.now().subtract(Duration(days: 365)),
                                    lastDate: DateTime.now().add(
                                        const Duration(days: 365 * 10)),
                                  );
                                  if (pickedDate != null) {
                                    alertDate = pickedDate;
                                    setState(() {
                                      dateinput.text =
                                          DateFormat('yyyy-MM-dd').format(
                                              pickedDate);
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                controller: timeinput,
                                readOnly: true,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '시간 선택'
                                ),
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    cancelText: '취소',
                                    confirmText: '확인',
                                    helpText: '시간 선택',
                                    errorInvalidText: '에러',
                                    hourLabelText: '시',
                                    minuteLabelText: '분',
                                    initialEntryMode: TimePickerEntryMode.input,
                                  );
                                  if (pickedTime != null) {
                                    alertTime = pickedTime;
                                    String selectHour = alertTime.hour
                                        .toString().padLeft(2, '0');
                                    String selectTime = alertTime.minute
                                        .toString().padLeft(2, '0');
                                    if (selectHour != '' && selectTime != '') {
                                      String timeSelect = selectHour + '시 ' +
                                          selectTime + '분';
                                      setState(() {
                                        timeinput.text = timeSelect;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(

                                controller: alertName,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '알림 이름'
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                controller: alertContents,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '알림 내용'
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("알림 사용여부 : ", style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  ),
                                  Switch(
                                    value: alert,
                                    onChanged: (value) {
                                      setState(() {
                                        alert = value;
                                      });
                                    }
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: widgetWidth,
                              height: widgetHeight * 0.15 -
                                  AppBar().preferredSize.height,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10),
                              child: ElevatedButton(
                                child: const Text("등록", style: TextStyle(fontSize: 20.0, color: Colors.limeAccent)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlueAccent,
                                ),
                                onPressed: () async {
                                  if (dateinput.text.trim() == '') {
                                    UniDialog.showToast(
                                        "날짜를 입력해 주세요.", 'short');
                                    return;
                                  }
                                  if (timeinput.text.trim() == '') {
                                    UniDialog.showToast(
                                        "시간을 입력해 주세요.", 'short');
                                    return;
                                  }
                                  if (alertName.text.trim() == '') {
                                    UniDialog.showToast(
                                        "알림을 입력해 주세요.", 'short');
                                    return;
                                  }
                                  DateTime selecteDate = DateTime(
                                      alertDate.year,
                                      alertDate.month,
                                      alertDate.day,
                                      alertTime.hour,
                                      alertTime.minute
                                  );

                                  final notification = ref.watch(notificationProvider);
                                  try {
                                    final result = await notification.addNotificationWithAlarm({
                                      'date': selecteDate,
                                      'title': alertName.text,
                                      'contents': alertContents.text,
                                      'alarm': alert,
                                    });

                                    if (result != null) {
                                      UniDialog.showToast("등록 되었습니다.", 'short');
                                      resetInput();
                                    } else {
                                      UniDialog.showToast("등록에 실패했습니다.", 'short');
                                    }
                                  } catch (e) {
                                    debugPrint('예외 발생: ${e.toString()}');

                                    if (e.toString().contains("SqliteException(2067)")) {
                                      UniDialog.showToast("이미 등록된 날짜입니다.", 'short');
                                    } else {
                                      UniDialog.showToast("등록에 실패했습니다.", 'short');
                                    }
                                  }
                                },
                              ),
                            )
                          ]
                      )
                  ),
                )
            ),
          ]
      ),
    );
  }

  void resetInput() {
    dateinput.text = '';
    timeinput.text = '';
    alertName.text = '';
    alertContents.text = '';
  }
}