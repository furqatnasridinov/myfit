import 'package:activity/domain/handlers/http_service.dart';
import 'package:activity/domain/interface/gym.dart';
import 'package:activity/infrastructure/repository/gym_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerLazySingleton<HttpService>(() => HttpService());
  getIt.registerSingleton<GymRepositoryInterface>(GymRepository());
}

final gymRepo = getIt.get<GymRepositoryInterface>();
