import 'package:activity/infrastructure/models/data/addresses.dart';
import 'package:activity/infrastructure/models/data/calendar.dart';
import 'package:activity/infrastructure/models/data/gym_activity.dart';
import 'package:activity/infrastructure/models/data/map_dummy_activity.dart';
import 'package:activity/infrastructure/models/data/schedule.dart';
import 'package:flutter/material.dart';

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
  final List<GymActivity> listOFDummyActivities = [
    GymActivity(name: "POOL", count: "3", icon: Icons.waves),
    GymActivity(name: "MASSAGE", count: "2", icon: Icons.hotel_sharp),
    GymActivity(name: "GYM", count: "1", icon: Icons.sports_handball_sharp),
  ];
  final List<String> days30 = [
    "2023-12-01",
    "2023-12-02",
    "2023-12-03",
    "2023-12-04",
    "2023-12-05",
    "2023-12-06",
    "2023-12-07",
    "2023-12-08",
    "2023-12-09",
    "2023-12-10",
    "2023-12-11",
    "2023-12-12",
    "2023-12-13",
    "2023-12-14",
  ];
  final List<String> days15 = [
     "2023-11-24",
    "2023-11-25",
    "2023-11-26",
    "2023-11-27",
    "2023-11-28",
    "2023-11-29",
    "2023-11-30",
    "2023-12-01",
    "2023-12-02",
    "2023-12-03",
    "2023-12-04",
    "2023-12-05",
    "2023-12-06",
    "2023-12-07",
    "2023-12-08",
  ];
  
  final List<MapDummyActivity> mapDummyActivities = [
    MapDummyActivity(
      distance: "230",
      icon: "assets/svg/activity.svg",
      title: "Бокс на пресненской",
    ),
    MapDummyActivity(
      distance: "230",
      icon: "assets/svg/activity.svg",
      title: "Бокс на пресненской",
    ),
    MapDummyActivity(
      distance: "230",
      icon: "assets/svg/activity.svg",
      title: "Бокс на пресненской",
    ),
    MapDummyActivity(
      distance: "230",
      icon: "assets/svg/activity.svg",
      title: "Бокс на пресненской",
    ),
    MapDummyActivity(
      distance: "230",
      icon: "assets/svg/activity.svg",
      title: "Бокс на пресненской",
    ),
    MapDummyActivity(
      distance: "230",
      icon: "assets/svg/activity.svg",
      title: "Бокс на пресненской",
    ),
    MapDummyActivity(
      distance: "230",
      icon: "assets/svg/activity.svg",
      title: "Бокс на пресненской",
    ),
    MapDummyActivity(
      distance: "230",
      icon: "assets/svg/activity.svg",
      title: "Бокс на пресненской",
    ),
  ];
  final List<String> cityNames = [
        "Москва",
        "Санкт-Петербург",
        "Новосибирск",
        "Екатеринбург",
        "Нижний Новгород",
        "Казань",
        "Челябинск",
        "Омск",
        "Самара",
        "Ростов-на-Дону",
        "Уфа",
        "Красноярск",
        "Воронеж",
        "Волгоград",
        "Пермь",
  ];
}
