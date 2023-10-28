import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UiVerticalStepper extends StatelessWidget {
  UiVerticalStepper({super.key});

  final List<int> steps = [1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox(
            width: 10.0,
            child: VerticalDivider(
              color: Color.fromRGBO(119, 170, 249, 1),
              thickness: 2,
            ),
          ),
          const SizedBox(height: 2.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var step in steps)
                Icon(
                  Icons.circle,
                  color: step == 1
                      ? const Color.fromRGBO(62, 134, 245, 1)
                      : Colors.grey,
                  size: step == 1 ? 7.0 : 7.0,
                )
            ],
          )
        ],
      ),
    );
  }
}
