import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          path: "/",
        ),
        AutoRoute(
          page: ActivityRoute.page,
          //path: '/',
        ),
        CustomRoute(
          page: ScheduleRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
          path: '/schedule',
        ),
        AutoRoute(
          page: MainRoute.page,
          path: "/main",
        ),
        AutoRoute(
          page: NotesRoute.page,
          path: "/notes",
        ),
        AutoRoute(
          page: Main2Route.page,
          path: "/main2"
        ),
        CustomRoute(
            page: MapRoute.page,
            transitionsBuilder: TransitionsBuilders.slideLeft,
            path: "/map"
            
            ),
        AutoRoute(
          page: RegistrationRoute.page,
          path: "/registration"
          
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
         
        ),
        AutoRoute(
          page: Registration4Route.page,
          path: "/registration4",
         
        ),
        AutoRoute(
          page: SettingsRoute.page,
          path: "/settings"
          
        )
      ];
}
