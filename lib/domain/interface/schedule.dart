import 'package:activity/domain/handlers/api_result.dart';

abstract class ScheduleRepositoryInterface{
  Future<ApiResult<Map<String,dynamic>>>getUsersSchedules();
}