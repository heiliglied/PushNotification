import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  EmptyPage({Key? key}) :  super(key: key);

  Widget emptyWidget = const CustomScrollView(
    scrollDirection: Axis.vertical,
    slivers: [
      SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("내역을 찾을 수 없습니다.", style: TextStyle(fontSize: 24),),
          ],
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return emptyWidget;
  }
}