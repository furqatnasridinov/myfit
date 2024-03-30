// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';


void main() {
String formatDuration(String time) {
    final parts = time.split(':');
    if (parts.length != 2) {
      throw const FormatException();
    }
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);

    if (hours == null || minutes == null) {
      throw const FormatException();
    }

    String hoursText = '';
    String minutesText = '';

    // Склонение часов
    if (hours > 0) {
      if (hours % 10 == 1 && hours % 100 != 11) {
        hoursText = '$hours час';
      } else if ([2, 3, 4].contains(hours % 10) &&
          ![12, 13, 14].contains(hours % 100)) {
        hoursText = '$hours часа';
      } else {
        hoursText = '$hours часов';
      }
    }

    // Склонение минут
    if (minutes % 10 == 1 && minutes % 100 != 11) {
      minutesText = '$minutes минута';
    } else if ([2, 3, 4].contains(minutes % 10) &&
        ![12, 13, 14].contains(minutes % 100)) {
      minutesText = '$minutes минуты';
    } else {
      minutesText = '$minutes минут';
    }

    return '${hoursText.isNotEmpty ? "$hoursText " : ""} ${minutesText != "0 минут" ? minutesText : ""}';
  }
  
  
  test("formatDuration", () {
    final result = formatDuration('00:00');
    expect(result, '1 час  45 минут');

  });
}
