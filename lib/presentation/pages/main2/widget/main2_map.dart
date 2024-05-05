import 'package:myfit/application/map/map_notifier.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class Main2Map extends StatelessWidget {
  final Widget child;
  final bool showRecommended;
  final bool showOnlyKnown;
  final MapNotifier mapEvent;
  const Main2Map({
    super.key,
    required this.child,
    required this.showRecommended,
    required this.showOnlyKnown,
    required this.mapEvent,
  });
  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context);
    return GestureDetector(
      onTap: () {
        if (showOnlyKnown) {
          mapEvent.setShowOnlyKnown(false);
        }
        if (showRecommended) {
          tabsRouter.setActiveIndex(2);
        }else{
          mapEvent.setShowRecommended(true);
          context.router.push(const MapRoute());
        }
      },
      child: Container(
        height: 147.w,
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(
            width: 3.w,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              spreadRadius: 0,
              blurRadius: 5.0,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: Color.fromRGBO(119, 170, 249, 1),
              spreadRadius: -15,
              blurRadius: 18.0,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: SizedBox(
            child: child,
          ),
        ),
      ),
    );
  }
}
