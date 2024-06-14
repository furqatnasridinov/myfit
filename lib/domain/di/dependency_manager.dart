import 'package:myfit/application/notification/notification_notifier.dart';
import 'package:myfit/domain/handlers/http_service.dart';
import 'package:myfit/domain/interface/activity.dart';
import 'package:myfit/domain/interface/main.dart';
import 'package:myfit/domain/interface/notification.dart';
import 'package:myfit/domain/interface/register.dart';
import 'package:myfit/domain/interface/schedule.dart';
import 'package:myfit/domain/interface/settings.dart';
import 'package:myfit/infrastructure/repository/activity_repository.dart';
import 'package:myfit/infrastructure/repository/main_repository.dart';
import 'package:myfit/infrastructure/repository/notification_repository.dart';
import 'package:myfit/infrastructure/repository/register_repository.dart';
import 'package:myfit/infrastructure/repository/schedule_repository.dart';
import 'package:myfit/infrastructure/repository/settings_respository.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerLazySingleton<HttpService>(() => HttpService());
  getIt.registerSingleton<ActivityRepositoryInterface>(ActivityRepository());
  getIt.registerSingleton<MainRepositoryInterface>(MainRepository());
  getIt.registerSingleton<ScheduleRepositoryInterface>(ScheduleRepository());
  getIt.registerSingleton<RegisterRepositoryInterface>(RegisterRepository());
  getIt.registerSingleton<SetttingsRepositoryInterface>(SettingsRepository());
  getIt.registerSingleton<NotificationRepositoryInterface>(NotificationRepository());
}

final gymRepo = getIt.get<ActivityRepositoryInterface>();
final notificationNotifier = getIt.get<NotificationNotifier>();
final mainRepo = getIt.get<MainRepositoryInterface>();
final scheduleRepo  =getIt.get<ScheduleRepositoryInterface>();
final registerRepo = getIt.get<RegisterRepositoryInterface>();
final settingsRepo = getIt.get<SetttingsRepositoryInterface>();
final notificationRepo = getIt.get<NotificationRepositoryInterface>();
