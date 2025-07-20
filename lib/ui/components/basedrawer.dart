import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:pushnotification/extra/UniDialog.dart';

//import '../../routes.dart';

class BaseDrawer extends StatelessWidget {
  const BaseDrawer({Key? key, Widget? child, String? semanticLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 80,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.amber),
              child: Text('메뉴'),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 160,
            child:SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text('홈'),
                      onTap: () {
                        context.goNamed('main', queryParameters: {"title": "홈"});
                        //Navigator.pushNamed(context, Routes.mainPage, arguments: {"title": "홈"});
                      },
                    ),
                    ListTile(
                      title: const Text('알림 내역'),
                      onTap: () {
                        context.goNamed('history', queryParameters: {"title": "알림 내역"});
                        //Navigator.pushNamed(context, Routes.calendar, arguments: {"title": "알림 내역"});
                      },
                    ),
                    ListTile(
                      title: const Text('신규 알림 추가'),
                      onTap: () {
                        context.goNamed('setting', extra: {'title': '', 'id': 0});
                        //Navigator.pushNamed(context, Routes.set, arguments: {"title": "신규 알림 추가"});
                      },
                    ),
                  ],
                )
            ),
          ),
          SizedBox(
            height: 80,
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  const Divider(),
                  ListTile(
                    title: const Text('종료'),
                    onTap: () {
                      UniDialog.callDialog(
                          context,
                          title: "경고",
                          content: "앱을 종료하시겠습니까?",
                          positiveText: "예",
                          positive: () {
                            SystemNavigator.pop(); // 앱 종료
                            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                          },
                          negativeText: "아니오"
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}