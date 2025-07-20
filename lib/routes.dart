import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pushnotification/ui/mainpage.dart';
import 'package:pushnotification/ui/notify/history/history.dart';
import 'package:pushnotification/ui/notify/setnotify.dart';
import 'package:pushnotification/ui/notify/updatenotify.dart';

/*
final GoRouter router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      name: "main",
      builder: (context, state) => MainPage(),
    ),
    GoRoute(
      path: "/setting",
      name: "setting",
      builder: (context, state) => SetNotify(),
    ),
  ]
);
*/
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        name: "main",
        builder: (context, state) => MainPage(),
      ),
      GoRoute(
        path: "/history",
        name: "history",
        builder: (context, state) => History(),
      ),
      GoRoute(
          path: "/setting",
          name: "setting",
          builder: (context, state) => SetNotify(),
      ),
      GoRoute(
        path: "/setting/:id",
        name: "update",
        builder: (context, state) {
          return UpdateNotify(
              id: state.pathParameters['id'] ?? '',
              title: (state.extra as Map<String, dynamic>)["title"] ?? '',
          );
        }
      ),
    ]
  );
});