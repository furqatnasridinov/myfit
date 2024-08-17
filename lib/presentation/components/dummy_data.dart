import 'package:myfit/infrastructure/models/data/addresses.dart';
import 'package:myfit/infrastructure/models/data/payment.dart';
import 'package:myfit/infrastructure/models/data/subscribtion_card.dart';

import '../../infrastructure/models/response/user_schedules_response.dart';

class DummyData {
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


  final List<SubscribtionCard> dummySubscribtionCards = [
    SubscribtionCard(
      title: "За 1 день можно посетить одно и то же заведение не более 1 раза",
      description:
          "Например, если вы сегодня уже сходили в Бассейн спортивного центра “Газпром”, то сходить в их же тренажёрный зал не получится, сегодня вы можете пойти потренироваться в другое заведение или прийти в зал “Газпрома” завтра.",
      description2: "",
    ),
    SubscribtionCard(
      title: "В каждом заведении есть своё количество посещений в месяц",
      description:
          "Как правило, каждое заведение выделяет для пользователей MyFit от 8 до 12 посещений в месяц. Если в одном зале посещения закончились - вы можете пойти в другой, заведений очень много, пробуйте новое без переплат!",
      description2:
          "Количество оставшихся посещений всегда отображается на экране поиска занятий и в подробной карточке заведения.",
    ),
    SubscribtionCard(
      title: "Бонусные занятия!",
      description2: "",
      description:
          "Каждый тип бонусного занятия можно посетить два раза в месяц. Это отличный способ попробовать что то новое, не доплачивая. Например вы можете взять в прокат велосипед или сходить в баню!",
    )
  ];

  final List<String> genders = ["Мужчина", "Женщина"];

  static final List<Map<String, dynamic>> weekdays = [
    {
      "name" : "Пн",
      "id" : 1,
    },
    {
      "name" : "Вт",
      "id" : 2,
    },
    {
      "name" : "Ср",
      "id" : 3,
    },
    {
      "name" : "Чт",
      "id" : 4,
    },
    {
      "name" : "Пт",
      "id" : 5,
    },
    {
      "name" : "Сб",
      "id" : 6,
    },
    {
      "name" : "Вс",
      "id" : 7,
    },
  ];

  static final List<Gym> dummyGyms = [
    Gym(
      name: "Crystall",
      address: "ул. Лёни Ленина, д. 12, БЦ “Big Мук”",
      mainPictureUrl: "GYMS/35/mainPicture/09_03_2024_15_40_56_985.jpg",
      id: 35
    ),
    Gym(
      name: "Top DOG Fight Club",
      address: "ул. Лёни Ленина, д. 12, БЦ “Big Мук”",
    ),
    Gym(
      name: "Crystall",
      address: "ул. Лёни Ленина, д. 12, БЦ “Big Мук”",
      mainPictureUrl: "GYMS/35/mainPicture/09_03_2024_15_40_56_985.jpg",
    )
  ];

  static final List<Payment> payments = [
    Payment(
      id: 1,
      source: "Оплата за посещение зала",
      description: "Абонемент: Бойцовский клуб. Вечер",
      amount: 500,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      
      pic: "GYMS/35/mainPicture/09_03_2024_15_40_56_985.jpg",
    ),
    Payment(
      id: 2,
      source: "Оплата за посещение зала",
      description: "Абонемент: Бойцовский клуб. Вечер",
      amount: 500,
      date: DateTime.now().subtract(const Duration(days: 1)),
      pic: "GYMS/35/mainPicture/09_03_2024_15_40_56_985.jpg",
    ),
    Payment(
      id: 3,
      source: "Оплата за посещение зала",
      description: "Абонемент: Бойцовский клуб. Вечер",
      amount: 500,
      date: DateTime.now().subtract(const Duration(days: 2)),
      pic: "GYMS/35/mainPicture/09_03_2024_15_40_56_985.jpg",
    ),
    Payment(
      id: 4,
      source: "Оплата за посещение зала",
      description: "Абонемент: Бойцовский клуб. Вечер",
      amount: 500,
      date: DateTime.now().subtract(const Duration(days: 2)),
      pic: "GYMS/35/mainPicture/09_03_2024_15_40_56_985.jpg",
    ),
    Payment(
      id: 5,
      source: "Оплата за посещение зала",
      description: "Абонемент: Бойцовский клуб. Вечер",
      amount: 500,
      date: DateTime.now().subtract(const Duration(days: 3)),
      pic: "GYMS/35/mainPicture/09_03_2024_15_40_56_985.jpg",
    ),
    Payment(
      id: 6,
      source: "Оплата за посещение зала",
      description: "Абонемент: Бойцовский клуб. Вечер",
      amount: 500,
      date: DateTime.now().subtract(const Duration(days: 3)),
      pic: "GYMS/35/mainPicture/09_03_2024_15_40_56_985.jpg",
    )
  ];
  /* final List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      type: NotificationType.lessonCompleted,
      lessonType: "Силовые тренировки",
      iSread: false,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
      title: "",
      description: "",
      gymName: "Crystall",
      gymId: 35,
      updates: {},
      visitPerMonth: 12,
      visitedCount: 5,
    ),
    NotificationModel(
      id: 2,
      type: NotificationType.lessonConfirmed,
      lessonType: "Силовые тренировки",
      iSread: false,
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: "",
      description: "Занятие начинается 27 мая в 14:40.",
      gymName: "Crystall",
      gymId: 35,
      updates: {},
      visitPerMonth: 12,
      visitedCount: 5,
    ),
    NotificationModel(
      id: 3,
      type: NotificationType.lessonChanged,
      lessonType: "Силовые тренировки",
      iSread: true,
      date: DateTime.now().subtract(const Duration(days: 2)),
      title: "",
      description: "",
      gymName: "Crystall",
      gymId: 35,
      updates: {
        "oldTime" : "21.03 в 15:00",
        "newTime" : "22.03 в 15:00",
        "oldDescription" : "Описание старое",
        "newDescription" : "Массаж - это метод механического воздействия на мягкие ткани тела человека с помощью рук.",
      },
      visitPerMonth: 12,
      visitedCount: 5,
    ),
     NotificationModel(
      id: 4,
      type: NotificationType.visitsCountIsGettingLowOrEnded,
      lessonType: "Силовые тренировки",
      iSread: true,
      date: DateTime.now().subtract(const Duration(days: 2)),
      title: "Заканчиваются посещения в зале “Crystall”. Осталось 2.",
      description: "Запас посещений пополнится 27 мая в 16:40",
      gymName: "Crystall",
      gymId: 35,
      updates: {},
      visitPerMonth: 12,
      visitedCount: 5,
    ),
    NotificationModel(
      id: 5,
      type: NotificationType.visitsCountIsGettingLowOrEnded,
      lessonType: "Силовые тренировки",
      iSread: true,
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: "В зале “Crystall” закончились посещения!",
      description: "Запас посещений пополнится 27 мая в 16:40",
      gymName: "Crystall",
      gymId: 35,
      updates: {},
      visitPerMonth: 12,
      visitedCount: 5,
    ),
    NotificationModel(
      id: 6,
      type: NotificationType.lessonStartsWithin15minutes,
      lessonType: "Силовые тренировки",
      iSread: true,
      date: DateTime.now().subtract(const Duration(days: 3)),
      title: "",
      description: "",
      gymName: "Crystall",
      gymId: 35,
      updates: {},
      visitPerMonth: 12,
      visitedCount: 5,
    ),
    NotificationModel(
      id: 7,
      type: NotificationType.lessonCancelled,
      lessonType: "Силовые тренировки",
      iSread: true,
      date: DateTime.now().subtract(const Duration(days: 4)),
      title: "",
      description: "",
      reason: "no_places_left",
      gymName: "Crystall",
      gymId: 35,
      updates: {},
      visitPerMonth: 12,
      visitedCount: 5,
    ),
    NotificationModel(
      id: 8,
      type: NotificationType.lessonCancelled,
      lessonType: "Силовые тренировки",
      iSread: true,
      date: DateTime.now().subtract(const Duration(days: 4)),
      title: "",
      description: "",
      reason: "lesson_deleted",
      gymName: "Crystall",
      gymId: 35,
      updates: {},
      visitPerMonth: 12,
      visitedCount: 5,
    ),
  ]; */
}
