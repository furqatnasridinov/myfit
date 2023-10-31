import 'package:activity/domain/handlers/http_service.dart';
import 'package:activity/domain/interface/activity.dart';
import 'package:activity/domain/interface/main.dart';
import 'package:activity/infrastructure/repository/activity_repository.dart';
import 'package:activity/infrastructure/repository/main_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerLazySingleton<HttpService>(() => HttpService());
  getIt.registerSingleton<ActivityRepositoryInterface>(ActivityRepository());
  getIt.registerSingleton<MainRepositoryInterface>(MainRepository());
}

final gymRepo = getIt.get<ActivityRepositoryInterface>();
final mainRepo = getIt.get<MainRepositoryInterface>();
