import 'package:flutter/material.dart';

class UiTimePicker {
  static openTimePicker(
    context,
    TimeOfDay? initTime,
  ) {
    final chosenTime = showTimePicker(
      context: context,
      initialTime: initTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          // data: Theme.of(context).copyWith(
          //   useMaterial3: true,
          // ),
          child: child ?? Container(),
        );
      },
    );
    return chosenTime;
  }
}
