import 'package:flutter/material.dart';

class UiDatePicker {
  static openDatePicker(context, DateTime? initDate) {
    final chosenDate = showDatePicker(
      context: context,
      initialDate: initDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            useMaterial3: true,
          ),
          child: child!,
        );
      },
    );
    return chosenDate;
  }
}
