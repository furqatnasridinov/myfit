import 'package:activity/infrastructure/models/data/addresses.dart';
import 'package:activity/infrastructure/models/data/city_to_select.dart';


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
  
  final List<String> days30 = [
    "2023-12-26",
    "2023-12-27",
    "2023-12-28",
    "2023-12-29",
    "2023-12-30",
    "2023-12-31",
    "2024-01-01",
    "2024-01-02",
    "2024-01-03",
    "2024-01-04",
    "2024-01-05",
    "2024-01-06",
    "2024-01-07",
    "2024-01-08",
  ];

  final List<CityToSelect> cityNames = [
    CityToSelect(name: "Москва", lat: 55.7634, lon: 37.6085),
    CityToSelect(name: "Санкт-Петербург", lat: 59.938784, lon: 30.314997),
    CityToSelect(name: "Новосибирск", lat: 55.030204, lon: 82.920430),
    CityToSelect(name: "Екатеринбург", lat: 56.838011, lon: 60.597474),
    CityToSelect(name: "Нижний Новгород", lat: 56.326797, lon: 44.006516),
    CityToSelect(name: "Казань", lat: 55.796127, lon: 49.106414),
    CityToSelect(name: "Челябинск", lat: 55.159902, lon: 61.402554),
    CityToSelect(name: "Омск", lat: 54.989347, lon: 73.368221),
    CityToSelect(name: "Самара", lat: 53.195878, lon: 50.100202),
    CityToSelect(name: "Ростов-на-Дону", lat: 47.222078, lon: 39.720358),
    CityToSelect(name: "Уфа", lat: 47.222078, lon: 39.720358),
    CityToSelect(name: "Красноярск", lat: 56.010569, lon: 92.852572),
    CityToSelect(name: "Воронеж", lat: 51.660781, lon: 39.200296),
    CityToSelect(name: "Волгоград", lat: 48.707067, lon: 44.516975),
    CityToSelect(name: "Пермь", lat: 58.010455, lon: 56.229443),
  ];
}
