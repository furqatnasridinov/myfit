import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/infrastructure/models/response/get_nearest_lesson_response.dart';
import 'package:activity/infrastructure/models/response/get_user_stats_month_response.dart';

abstract class ScheduleRepositoryInterface{
  Future<ApiResult<Map<String,dynamic>>>getUsersSchedules();
  Future<ApiResult<GetNearestLesson>>getNearestLesson();
  Future<ApiResult<GetUserStatsMonthResponse>>getUserStatsMonth();
}