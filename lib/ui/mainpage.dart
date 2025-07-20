import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pushnotification/data/database/database.dart';
import 'package:pushnotification/ui/components/basedrawer.dart';
import 'package:pushnotification/ui/components/emptypage.dart';
import 'package:pushnotification/ui/components/detailbottomsheet.dart';
import 'package:pushnotification/data/database/daos/NotificationDao.dart';
import 'package:intl/intl.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MainPage> createState() => _MainPage();
}

class _MainPage extends ConsumerState<MainPage> {
  Widget emptyPage = EmptyPage();
  int page = 0;
  int limit = 8;
  bool loading = false, allLoaded = false;
  final List<NotificationData> list = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fatchList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          page++;
          fatchList();
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  fatchList() async {
    if(allLoaded) {
      return;
    }

    setState(() {
      loading = true;
    });

    final notiDao = ref.read(notiDaoProvider);
    await notiDao.getNotificationList(page, limit)?.then((value) =>
    {
      value.forEach((element) {
        list.add(element);
      })
    });

    setState(() {
      loading = false;
      allLoaded = list.isEmpty;
    });
  }

  Widget addlistView(List<dynamic> notiList) {
    return ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          DateTime date = notiList[index].date;
          String format = DateFormat('yyyy-MM-dd HH:mm').format(date);
          return GestureDetector(
              onTap: () async {
                DetailBottomSheet()
                  ..showBottomSheet(context, notiList[index], index, ref)
                      .then((value) {
                    if (mounted) {
                      setState(() {
                        if (value != null) {
                          notiList.removeAt(value);
                        }
                      });
                    }
                  });
              },
              child: Card(
                  child: SizedBox(
                      height: 80,
                      child: ListTile(
                        /*
                        leading: const Image(
                            image: AssetImage('assets/images/timetable.png')),
                        */
                        title: Text("지정시간 : $format"),
                        subtitle: Text("알림 : ${notiList[index].title}"),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                      )
                  )
              )
          );
        },
        itemCount: notiList.length
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: Scaffold(
          //return Scaffold(
            appBar: AppBar(
              title: const Text("푸시 알림"),
            ),
            drawer: const BaseDrawer(),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => {
                context.pushNamed('setting')
                //Navigator.pushNamed(context, 'set')
              },
              label: const Text("작성하기"),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    // color: Colors.grey,
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: list.isEmpty ? emptyPage : addlistView(list),
                  ),
                  flex: 9,
                )
              ],
            )
        )
    );
  }
}