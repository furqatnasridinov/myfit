class AppConstants {
  //  urls
  static const String baseUrl = "https://myfit-russia.ru/";
  static const String getYandexMapImage = "https://static-maps.yandex.ru/1.x/";
  static const String getAdvantages = "api/main/advantages";
  static const String getSubscribtions = "api/main/subscription";
  static const String getComments = "api/main/comments";
  static const String getGymsList = "api/gym/gymActiveList";
  static const String searchGym = "api/gym/search";
  static const String getSchedulesSearch = "api/schedule/search";
  static const String getCompletedSchedules = "api/schedule/user/last";
  static const String   getUserSchedules = "api/schedule/user";
  static const String getNearestLesson = "api/user/lessons/nearest";
  static const String getUserStatsMonth = "api/user/stat/month";
  static const String makeRate = "api/schedule/addComment";
  static const String deleteRate = "api/schedule/user/delComment";
  static const String addNote = "api/schedule/addNote";
  static const String getCities = "api/main/city";
  static const String patchUser = "api/user/true";
  static const String getUser = "api/user/true";
  static const String changePhoneSendConfirmationCode = "api/user/changePhoneCodeConfirmation/2";
  static const String changePhoneSendPhoneNumber = "api/user/changePhone/2";
  static const String addPicture = "api/user/addPicture";
  static const String getCompletedLessonTypes = "api/user/lessons/similar/confirmed"; // maybe will change to completed
  static const String getWaitingLessonTypes = "api/user/lessons/similar/waiting";
  static const String getRecommendationForVisit = "api/user/recommendationForVisiting";
  static const String getUserSubscribtion = "api/subscription/user";
  static const String getAllAvailableSubscribtions = "api/subscription";
  static const String toggleAutoRenewal = "api/subscription/user";
  static const String searchForGymAndLesson= "api/main/search";
  static const String getNotifications = "api/notification/userNotifications";
  static const String markNotificationAsRead = "api/notification/markAsRead";
  static const String sendPhoneNumber = "api/user/loginCode";
  static const String sendCodeConfirmation = "api/user/loginCodeConfirmation";
  static const String updateFcmToken = "api/user/updateFcmToken";
  static const String searchMembership = "api/crm/membership/search";
  //static const String getInfoForType = "api/gym/3/infoForType";
  //static const String enrollToGym = "api/schedule/1/add";

  // photo
  static const String placeholderPhoto = 'assets/images/first.png';
  static const String cristianBale = "assets/images/placeholder.jpg";
  static const String defaultAvatar = "assets/images/default_avatar.png";

  // map data
  static const double moscowLat = 55.7522200;
  static const double moscowLon = 37.6155600;
  static const double maktabi21Lat = 40.305577268511364;
  static const double maktabi21Lon = 69.6473696903535;
  static const double panjshanbeLat = 40.278860846791375;
  static const double panjshanbeLon = 69.63038731695158;
  static const int userMarkerId = 0;

  // shared prefs keys
  static const String keyPhoneNumber = "key_phone_number";
  static const String keyUserId = "key_user_id";
  static const String keyToken = "key_token";
  static const String keyUserName = "key_username";
  static const String keyUserLastName = "key_user_lastname";
  static const String keyUserPatronomic = "key_user_patronomic";
  static const String keyGender = "key_gender";
  static const String keyCity = "key_city";
  static const String keyCityLat = "key_city_lat";
  static const String keyCityLon = "key_city_lon";
  static const String keyAge = "key_age";
  static const String keyWeight = "key_weight";
  static const String keyHeight = "key_height";
  static const String keyAvatar = "key_avatar";
  static const String keyLoginTime = "key_login_time";
  static const String keyKnownActivities = "key_activities";
  static const String keyIsNotificationDisabled ="key_is_notification_disabled";
  static const String keyNotificationTime = "key_notification_time";
  static const String keyWhenUploadingPhotoAccessOpens = "key_photo_access";
  static const String keyUserBirthday = "key_birthday";

  // hero animations tags
  static const String registration3Hero = "registration_3_hero";

  // notification

  static const int scheduledNotificationId = 1308;
  static const String scheduledNotificationChannelId = "tmpScheduledChanelId";
  static const String scheduledNotificationChannelName ="tmpScheduledChanelName";

  //  days
  static  DateTime myBitrh = DateTime.parse("2003-11-18 18:11:00");

    // long texts
    static const String confirmationText2 =
      "Продолжая вход я даю согласие на обработку персональных данных и принимаю";
  static const String confirmationText =
      "Нажимая на кнопку «Продолжить» - я даю согласие на обработку персональных данных и подтверждаю, что прочитал(а) ";
  static const String userAgreement =
      "к MyFIT (временно или навсегда). Будет не круто, поэтому используй приложение с умом и по правилам.  Третье правило: всякое бывает. Мы живём в непредсказуемом мире. Если случится какая-нибудь безумная хрень (войны, землетрясения, наводнения, порабощение человечества искусственным интеллектом… ну ладно, про интеллект я загнул, надеюсь), ни ты, ни компания не будете нести ответственности за невыполнение обязательств. Да, в жизни бывает всякая фигня. Мы постарались сделать соглашение максимально простым с юридической точки зрения, а также добавили пояснения нормальным человеческим языком (сами знаем, многим юридическим документам этого очень не хватает).";
  static const String warningText =
      "Если вы пропускаете регистрацию по номеру телефона - то при следующем входе система может вас не узнать, все данные удалятся а оплаченный период будет утерян.";
  static const String subscriptionText1 = "MyFit — это один абонемент на разные виды активностей. Вы можете выбрать занятия на каждый день и в любое время.";
  static const String subscriptionText2 = "Можно записаться на несколько занятий в день: утром на йогу, в обед на фитнес и вечером в бассейн.";
  static const String subscriptionText3 = "В абонементе нет ограничений по количеству посещений в месяц, но есть несколько правил, которые стоит помнить при посещении активностей MyFit:";
  static const String visitsCountIsEndingLongText = "Если до пополнения ещё долго - мы рекомендуем записаться в другой зал и попробовать что то новое. Движение - это жизнь!";
  static const String lessonChangedLongText = "Администратор заведения внёс изменения в занятие, на которое вы были записаны, по этому ваша запись отменена. Ознакомьтесь с изменениями и если вас всё устраивает - нажмите кнопку снизу этого уведомления.";
  static const String fiilYourProfileLongText = "Так мы сможем подобрать для вас предложения, которые с большей вероятностью смогут вас заинтересовать";
  static const String inviteFriendLongText = "Всё очень просто, если вы пригласите 3 новых пользователей в MyFit и они оформят подписку - то вы получите подписку на месяц в подарок.";
  static const String inviteFriendLongText2 = "Отправьте ссылку другу. Он получит скидку 10% на первое оформление подписки. Когда 3 друга впервые оформят подписку - вы получите подписку на месяц, бесплатно.";
  static const String promoLongText = "Промокоды на скидку активируются автоматически при следующей оплате. В первую очередь используется промокод с максимальной скидкой.";
  static const String autoRenewalLongText = "Для вашего удобства теперь мы будем автоматически списывать оплату за подписку.";
  static const String loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
}

enum NotificationType {
  lessonCompleted, // 
  lessonCancelled, //
  lessonConfirmed, // 
  lessonStartsWithin15minutes, //
  lessonChanged, // 
  visitsCountIsGettingLowOrEnded, //
  system,
}

enum PromocodeState{
  waiting,
  used,
  notUsed,
}
