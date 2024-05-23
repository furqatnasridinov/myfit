import 'package:myfit/infrastructure/models/data/addresses.dart';
import 'package:myfit/infrastructure/models/data/notification.dart';
import 'package:myfit/infrastructure/models/data/subscribtion_card.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';

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

  final List<Notification> notifications = [
    Notification(
      type: NotificationType.lessonCompleted,
      lessonType: "Силовые тренировки",
      unread: true,
      time: "20:30",
      title: "",
      description: "",
      gymName: "Crystall",
      gymId: 35,
      body: {},
      tottalVisits: 10,
      visitsLeft: 5,
    ),
    Notification(
      type: NotificationType.lessonConfirmed,
      lessonType: "Силовые тренировки",
      unread: true,
      time: "20:30",
      title: "",
      description: "Занятие начинается 27 мая в 14:40.",
      gymName: "Crystall",
      gymId: 35,
      body: {},
      tottalVisits: 10,
      visitsLeft: 5,
    ),
    Notification(
      type: NotificationType.lessonChanged,
      lessonType: "Силовые тренировки",
      unread: true,
      time: "20:30",
      title: "",
      description: "",
      gymName: "Crystall",
      gymId: 35,
      body: {
        "oldTime" : "21.03 в 15:00",
        "newTime" : "22.03 в 15:00",
        "oldDescription" : "Описание старое",
        "newDescription" : "Массаж - это метод механического воздействия на мягкие ткани тела человека с помощью рук.",
      },
      tottalVisits: 10,
      visitsLeft: 5,
    ),
     Notification(
      type: NotificationType.visitsCountIsGettingLowOrEnded,
      lessonType: "Силовые тренировки",
      unread: true,
      time: "20:30",
      title: "Заканчиваются посещения в зале “Crystall”. Осталось 2.",
      description: "Запас посещений пополнится 27 мая в 16:40",
      gymName: "Crystall",
      gymId: 35,
      body: {},
      tottalVisits: 10,
      visitsLeft: 5,
    ),
    Notification(
      type: NotificationType.visitsCountIsGettingLowOrEnded,
      lessonType: "Силовые тренировки",
      unread: true,
      time: "20:30",
      title: "В зале “Crystall” закончились посещения!",
      description: "Запас посещений пополнится 27 мая в 16:40",
      gymName: "Crystall",
      gymId: 35,
      body: {},
      tottalVisits: 10,
      visitsLeft: 5,
    ),
    Notification(
      type: NotificationType.lessonStartsWithin15minutes,
      lessonType: "Силовые тренировки",
      unread: true,
      time: "20:30",
      title: "",
      description: "",
      gymName: "Crystall",
      gymId: 35,
      body: {},
      tottalVisits: 10,
      visitsLeft: 5,
    ),
    Notification(
      type: NotificationType.lessonCancelled,
      lessonType: "Силовые тренировки",
      unread: true,
      time: "20:30",
      title: "",
      description: "",
      reason: "no_places_left",
      gymName: "Crystall",
      gymId: 35,
      body: {},
      tottalVisits: 10,
      visitsLeft: 5,
    ),
    Notification(
      type: NotificationType.lessonCancelled,
      lessonType: "Силовые тренировки",
      unread: true,
      time: "20:30",
      title: "",
      description: "",
      reason: "lesson_deleted",
      gymName: "Crystall",
      gymId: 35,
      body: {},
      tottalVisits: 10,
      visitsLeft: 5,
    ),
  ];
}
