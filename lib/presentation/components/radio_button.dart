import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadioButton700 extends StatelessWidget {
  const RadioButton700({
    super.key,
    required this.title,
    required this.ontap,
    required this.isSelected,
  });
  final String title;
  final Function() ontap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          5.verticalSpace,
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2), // Цвет тени
                        spreadRadius: 2, // Распространение тени
                        blurRadius: 1, // Размытие тени
                        offset: const Offset(0, 0), // Смещение тени по X и Y
                      )
                    ]
                  : null,
            ),
            child: CircleAvatar(
              radius: 7,
              backgroundColor:
                  isSelected ? Colors.white : const Color(0xff77AAF9),
              child: isSelected
                  ? const CircleAvatar(
                      radius: 6,
                      backgroundColor: Color(0xff77AAF9),
                    )
                  : const CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
