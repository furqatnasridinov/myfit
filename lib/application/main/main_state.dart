import 'package:myfit/infrastructure/models/data/activity_near_client.dart';
import 'package:myfit/infrastructure/models/data/each_markers_models.dart';
import 'package:myfit/infrastructure/models/response/get_advantages_response.dart';
import 'package:myfit/infrastructure/models/response/get_comments_response.dart';
import 'package:myfit/infrastructure/models/response/get_subscribtions_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default(false) bool isloading,
     @Default(false) bool getNearestActivitiesLoading,
    @Default(null) GetAdvantagesResponse? advantages,
    @Default(null) GetSubscribtionsResponse? subscribtions,
    @Default(null) GetCommentsResponse? comments,
    @Default(1) int activeStepState,
    @Default(true) bool advantagesAutoPlayMode,
    @Default(0) int commentActiveStepper,
    @Default(true) bool commentsAutoPlayMode,
    @Default([]) List<ActivityNearClient> activitiesNearClient,
    @Default([]) List<EachMarkersModel>listOfMarkers,
    @Default(0) double? commentsContainerHeight,  
    @Default("")String latlongsYandexApi,
  }) = _MainState;
  const MainState._();
}
