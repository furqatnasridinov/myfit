import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: ActivityRoute.page,
          path: '/',
        ),
        AutoRoute(
          page: ScheduleRoute.page,
          path: '/schedule',
          //path: '/',
        ),
        AutoRoute(
          page: MainRoute.page,
          //path: "/main",
          //path: "/"
        ),
        
      ];
}