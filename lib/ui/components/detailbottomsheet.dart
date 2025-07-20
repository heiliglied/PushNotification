import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pushnotification/data/database/database.dart';
import 'package:pushnotification/extra/UniDialog.dart';
import 'package:pushnotification/data/database/provider/NotificationProvider.dart';

class DetailBottomSheet {
  Future showBottomSheet(BuildContext context, NotificationData item, int index, WidgetRef ref) {
    final notification = ref.read(notificationProvider);
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.6, // 모달 높이 크기
            decoration: const BoxDecoration(
              color: Colors.white, // 모달 배경색
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0), // 모달 좌상단 라운딩 처리
                topRight: Radius.circular(0), // 모달 우상단 라운딩 처리
              ),
            ),
            child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: Colors.lightBlue,
                                width: 2,
                              )
                          )
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text("지정시간", style: TextStyle(fontSize: 18)),
                          ),
                          Expanded(
                              child: Text(DateFormat('yyyy-MM-dd HH:mm').format(item.date), style: const TextStyle(fontSize: 18))
                          )
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 40, // 최소 높이 설정
                      ),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: Colors.lightBlue,
                                width: 2,
                              )
                          )
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text("제목", style: TextStyle(fontSize: 18)),
                          ),
                          Expanded(
                              child: Text(item.title, style: const TextStyle(fontSize: 18))
                          )
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 40, // 최소 높이 설정
                      ),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: Colors.lightBlue,
                                width: 2,
                              )
                          )
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text("알림음", style: TextStyle(fontSize: 18)),
                          ),
                          Expanded(
                              child: Text(item.sound.split('/').last, style: const TextStyle(fontSize: 18))
                          )
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 40, // 최소 높이 설정
                      ),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                color: Colors.lightBlue,
                                width: 2,
                              )
                          )
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text("알람사용", style: TextStyle(fontSize: 18)),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start, // 가로 방향으로 왼쪽 정렬
                              children: [
                                Switch(
                                  value: item.alarm,
                                  onChanged: (bool value) {
                                    // 원하는 동작
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 100,
                                    child: Text("내용", style: TextStyle(fontSize: 18)),
                                  ),
                                  Expanded(
                                      child: Text(item.contents, style: const TextStyle(fontSize: 18))
                                  )
                                ],
                              ),
                            )
                        )
                    ),
                    Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                  color: Colors.lightBlue,
                                  width: 2,
                                )
                            )
                        ),
                        height: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                child: const Text("알림 수정"),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightBlueAccent
                                ),
                                onPressed: () {
                                  context.go('/setting/' + item.id.toString(), extra: {"title": "알림 수정"});
                                }
                            ),
                            Container(
                              width: 5,
                            ),
                            ElevatedButton(
                                child: const Text("알림 끄기"),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black12
                                ),
                                onPressed: () {
                                  UniDialog.callDialog(
                                      context,
                                      title: "경고",
                                      content: "알림을 끄시겠습니까?",
                                      positiveText: "예",
                                      positive: () {
                                        notification.updateStatus(item.id,
                                          {
                                            'alarm': false,
                                            'status': false,
                                          }
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context, index);
                                      },
                                      negativeText: "아니오",
                                  );
                                }
                            ),
                            Container(
                              width: 5,
                            ),
                            ElevatedButton(
                                child: const Text("알림 삭제"),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent
                                ),
                                onPressed: () async {
                                  UniDialog.callDialog(
                                    context,
                                    title: "경고",
                                    content: "알림을 삭제하시겠습니까?",
                                    positiveText: "예",
                                    positive: () {
                                      notification.deleteNotification(item.id);
                                      Navigator.pop(context);
                                      Navigator.pop(context, index);
                                    },
                                    negativeText: "아니오",
                                  );


                                }
                            )
                          ],
                        )
                    ),
                  ],
                )
            )
        );
      },
    );
  }

}
