import 'package:activity/infrastructure/models/data/addresses.dart';
import 'package:activity/infrastructure/models/data/calendar.dart';
import 'package:activity/infrastructure/models/data/schedule.dart';

class DummyData {
  final List<Calendar> dates = [
    Calendar(weekDay: "Пн", daysOfMonth: "20", month: "Cен"),
    Calendar(weekDay: "Вт", daysOfMonth: "21", month: "Cен"),
    Calendar(weekDay: "Ср", daysOfMonth: "22", month: "Cен"),
    Calendar(weekDay: "Чт", daysOfMonth: "23", month: "Cен"),
    Calendar(weekDay: "Пт", daysOfMonth: "24", month: "Cен"),
    Calendar(weekDay: "Сб", daysOfMonth: "25", month: "Cен"),
    Calendar(weekDay: "Вс", daysOfMonth: "26", month: "Cен"),
  ];
  final List<Schedule> schedules = [
    Schedule(
      startingTime: "12:45",
      title: "Общая тренировка в зале",
      finishingTime: "14:10",
    ),
    Schedule(
      startingTime: "13:50",
      title: "Персональная тренировка c тренером сборной России",
      finishingTime: "14:50",
    ),
    Schedule(
      startingTime: "14:45",
      title: "Спарринги",
      finishingTime: "15:20",
    ),
    Schedule(
      startingTime: "15:20",
      title: "Валяемся на татами",
      finishingTime: "15:40",
    ),
    Schedule(
      startingTime: "16:35",
      title: "Персональная тренировка c тренером сборной России",
      finishingTime: "17:35",
    ),
  ];
    final List<Addresses> dummyAddresses = [
    Addresses(
      name: "Зал Чердак",
      destination: "234м от вас",
    ),
    Addresses(
      name: "Спорткомплекс “Газпром”",
      destination: "570м от вас",
    ),
    Addresses(
      name: "Элитный массажный салон “Дикая Выдрочка”",
      destination: "624м от вас",
    ),
    Addresses(
      name: "Зал “Фиолетка”",
      destination: "686м от вас",
    ),
    Addresses(
      name: "Бассейн “Таёжный”",
      destination: "1,2км от вас",
    ),
  ];
}
