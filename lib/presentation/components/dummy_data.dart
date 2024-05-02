import 'package:myfit/infrastructure/models/data/addresses.dart';
import 'package:myfit/infrastructure/models/data/subscribtion.dart';
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

  final List<Subscribtion> dummySubscribtions = [
    Subscribtion(
      id: 1,
      description: "Оплата раз в месяц и посещение сотен разных активностей",
      price: "10000",
      durationInMonths: "1",
    ),
    Subscribtion(
      id: 2,
      description: "Оплата раз в 3 месяца и посещение сотен разных активностей",
      price: "24000",
      durationInMonths: "3",
    ),
    Subscribtion(
      id: 3,
      description:
          "Оплата раз в 6 месяцев и посещение сотен разных активностей",
      price: "36000",
      durationInMonths: "6",
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
}
