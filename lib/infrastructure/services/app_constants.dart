class AppConstants {
  //  urls
  static const String baseUrl = "http://77.222.53.122:/";
  static const String getYandexMapImage = "https://static-maps.yandex.ru/1.x/";
  static const String getAdvantages = "api/main/advantages";
  static const String getSubscribtions = "api/main/subscription";
  static const String getComments = "api/main/comments";
  static const String getGymsList = "api/gym/gymActiveList";
  static const String searchGym = "api/gym/search";
  static const String getSchedulesSearch = "api/schedule/search";
  static const String getUserSchedules = "api/schedule/user";
  static const String getNearestLesson = "api/user/lessons/nearest";
  static const String getUserStatsMonth = "api/user/stat/month";
  static const String addNote = "api/schedule/addNote";
  static const String sendPhoneNumber = "api/user/loginCode";
  static const String sendCodeConfirmation = "api/user/loginCodeConfirmation";
  //static const String enrollToGym = "api/schedule/1/add";

  // photo
  static const String placeholderPhoto = 'assets/images/first.png';
  static const String cristianBale = "assets/images/american_psycho.jpg";

  // map data
  static const double moscowLat = 55.7522200;
  static const double moscowLon = 37.6155600;
  static const double maktabi21Lat = 40.305577268511364;
  static const double maktabi21Lon = 69.6473696903535;
  static const double panjshanbeLat = 40.278860846791375;
  static const double panjshanbeLon = 69.63038731695158;

  // shared prefs keys
  static const String keyPhoneNumber = "key_phone_number";
  static const String keyUserId = "key_user_id";
  static const String keyToken = "key_token";
  static const String keyUserName = "key_username";
  static const String keyCity = "key_city";
  static const String keyAge = "key_age";
  static const String keyWeight = "key_weight";
  static const String keyHeight = "key_height";
  static const String keyAvatar = "key_avatar";

  // long texts
  static const String confirmationText =
      "Нажимая на кнопку «Продолжить» - я даю согласие на обработку персональных данных и подтверждаю, что прочитал(а) ";
  static const String userAgreement =
      "к MyFIT (временно или навсегда). Будет не круто, поэтому используй приложение с умом и по правилам.  Третье правило: всякое бывает. Мы живём в непредсказуемом мире. Если случится какая-нибудь безумная хрень (войны, землетрясения, наводнения, порабощение человечества искусственным интеллектом… ну ладно, про интеллект я загнул, надеюсь), ни ты, ни компания не будете нести ответственности за невыполнение обязательств. Да, в жизни бывает всякая фигня. Мы постарались сделать соглашение максимально простым с юридической точки зрения, а также добавили пояснения нормальным человеческим языком (сами знаем, многим юридическим документам этого очень не хватает).";
  static const String warningText =
      "Если вы пропускаете регистрацию по номеру телефона - то при следующем входе система может вас не узнать, все данные удалятся а оплаченный период будет утерян.";
}
