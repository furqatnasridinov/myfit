import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main(){
  String formatOriginalToCalendar(String inputDate) {
    try {
      final List<String> parts = inputDate.split("@");
      DateTime date = DateTime.parse(parts[0]);
      String day = DateFormat('d').format(date);
      String month = DateFormat('MMM').format(date);
      switch (month) {
        case 'Jan':
          month = 'Янв';
          break;
        case 'Feb':
          month = 'Фев';
          break;
        case 'Mar':
          month = 'Мар';
          break;
        case 'Apr':
          month = 'Апр';
          break;
        case 'May':
          month = 'Май';
          break;
        case 'Jun':
          month = 'Июн';
          break;
        case 'Jul':
          month = 'Июль';
          break;
        case 'Aug':
          month = 'Авг';
          break;
        case 'Sep':
          month = 'Сен';
          break;
        case 'Oct':
          month = 'Окт';
          break;
        case 'Nov':
          month = 'Ноя';
          break;
        case 'Dec':
          month = 'Дек';
          break;
      }
      String dayOfWeek = DateFormat.E().format(date);
      switch (dayOfWeek) {
        case "Mon":
          dayOfWeek = "Пн";
          break;
        case "Tue":
          dayOfWeek = "Вт";
          break;
        case "Wed":
          dayOfWeek = "Ср";
          break;
        case "Thu":
          dayOfWeek = "Чт";
          break;
        case "Fri":
          dayOfWeek = "Пт";
          break;
        case "Sat":
          dayOfWeek = "Сб";
          break;
        case "Sun":
          dayOfWeek = "Вс";
          break;
      } // Get the day of the week
      return '$dayOfWeek $day $month';
    } catch (e) {
      return "error";
    }
  }

  test("formatOriginalToCalendar", (){
    final result = formatOriginalToCalendar('2024-03-34@00:00:00.000');
    expect(result, 'Вт 26 Мар');
  });
}