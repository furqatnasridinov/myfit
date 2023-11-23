import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: ActivityRoute.page,
          //path: '/',
        ),
        AutoRoute(
          page: ScheduleRoute.page,
          path: '/schedule',
          //path: '/',
        ),
        AutoRoute(
          page: MainRoute.page,
          //path: "/main",
          //path: "/",
        ),
        AutoRoute(
          page: NotesRoute.page,
          //path: "/",
        ),
        AutoRoute(
          page: Main2Route.page,
          //path: "/"
        ),
        AutoRoute(
          page: MapRoute.page,
          //path: "/map"
          //path: "/",
        ),
        AutoRoute(
          page: RegistrationRoute.page,
          path: "/",
        ),
        AutoRoute(
          page: Registration1Route.page,
          path: "/registration1",
        ),
        AutoRoute(
          page: Registration2Route.page,
          path: "/registration2",
        ),
        AutoRoute(
          page: Registration3Route.page,
          path: "/registration3",
         // path: "/",
        ),
        AutoRoute(
          page: Registration4Route.page,
          path: "/registration4",
          //path: "/",
        ),
      ];
}
