import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

// ignore: must_be_immutable
class Main2Map extends StatelessWidget {
  final Widget child;
  Main2Map({
    super.key,
    required this.child,
  });
  YandexMapController? yandexMapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 147.w,
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border.all(
          width: 3.w,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(16.0),
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
    );
  }
}
