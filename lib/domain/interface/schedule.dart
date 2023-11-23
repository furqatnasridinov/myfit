import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/infrastructure/models/request/add_note_request.dart';
import 'package:activity/infrastructure/models/response/add_note_response.dart';
import 'package:activity/infrastructure/models/response/cancel_response.dart';
import 'package:activity/infrastructure/models/response/get_nearest_lesson_response.dart';
import 'package:activity/infrastructure/models/response/get_user_stats_month_response.dart';

abstract class ScheduleRepositoryInterface {
  Future<ApiResult<Map<String, dynamic>>> getUsersSchedules();
  Future<ApiResult<GetNearestLesson>> getNearestLesson();
  Future<ApiResult<GetUserStatsMonthResponse>> getUserStatsMonth();
  Future<ApiResult<AddNoteResponse>> addNotes(AddNoteRequest addNoteRequest);
  Future<ApiResult<Map<String, dynamic>>>getNotes();
  Future<ApiResult<CancelellationResponse>> cancelActivity(int id);
}
