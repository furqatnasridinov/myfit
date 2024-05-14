import 'package:myfit/domain/handlers/api_result.dart';
import 'package:myfit/infrastructure/models/request/add_note_request.dart';
import 'package:myfit/infrastructure/models/request/rate_request.dart';
import 'package:myfit/infrastructure/models/response/add_note_response.dart';
import 'package:myfit/infrastructure/models/response/cancel_response.dart';
import 'package:myfit/infrastructure/models/response/get_nearest_lesson_response.dart';
import 'package:myfit/infrastructure/models/response/get_user_stats_month_response.dart';

abstract class ScheduleRepositoryInterface {
  Future<ApiResult<Map<String, dynamic>>> getUsersSchedules();
  Future<ApiResult<Map<String, dynamic>>> getCompletedSchedules();
  Future<ApiResult<Map<String, dynamic>>> makeRate(
      {required RateRequest request});
  Future<ApiResult<Map<String, dynamic>>> deleteRate({required int id});
  Future<ApiResult<GetNearestLesson>> getNearestLesson();
  Future<ApiResult<GetUserStatsMonthResponse>> getUserStatsMonth();
  Future<ApiResult<AddNoteResponse>> addNotes(AddNoteRequest addNoteRequest);
  Future<ApiResult<Map<String, dynamic>>> getNotes();
  Future<ApiResult<CancelellationResponse>> cancelActivity(int id);
  Future<ApiResult<Map<String, dynamic>>> searchingForSchedules(
      {required String schedule});
  Future<ApiResult<Map<String, dynamic>>> makeLessonInProgress({required int gymId, required int lessonId});
  Future<ApiResult<Map<String, dynamic>>> makeLessonCompleted({required int gymId, required int lessonId});  
}
