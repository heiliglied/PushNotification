import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pushnotification/extra/SchedulePushNotification.dart';
import 'package:pushnotification/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:pushnotification/data/database/database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initNotification() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();

  const initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}

Future<void> requestNotificationAndSchedule(BuildContext context, WidgetRef ref) async {
  bool permissionGranted = false;
  bool exactAlarmAllowed = true;

  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      final status = await Permission.notification.request();
      permissionGranted = status.isGranted;
    } else {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      permissionGranted = await androidPlugin?.areNotificationsEnabled() ?? false;
    }
  } else if (Platform.isIOS) {
    permissionGranted = true; // iOS는 initNotification()에서 이미 권한 요청
  }

  if (permissionGranted) {
    final db = ref.read(databaseProvider);
    await SchedulePushNotification(db);
  } else {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('알림 권한 또는 알람 권한 거부됨'),
        content: const Text('앱을 사용하려면 알림 및 정확한 알람 권한이 필요합니다.'),
        actions: [
          TextButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else {
                exit(0);
              }
            },
            child: const Text('앱 종료'),
          ),
        ],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotification();

  runApp(
    const ProviderScope(
      child: Main(),
    ),
  );
}

class Main extends ConsumerStatefulWidget {
  const Main({super.key});

  @override
  ConsumerState<Main> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await requestNotificationAndSchedule(context, ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: '일정 푸시 알림이',
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', '')],
    );
  }
}