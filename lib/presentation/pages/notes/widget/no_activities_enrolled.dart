import 'package:activity/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';

class NoActivitiesEnrolled extends StatelessWidget {
  const NoActivitiesEnrolled({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(text: "У вас нет активных или завершенных занятий!"),
    );
  }
}
