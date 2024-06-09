import 'package:myfit/infrastructure/models/data/addresses.dart';
import 'package:myfit/infrastructure/models/data/subscribtion_card.dart';

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
