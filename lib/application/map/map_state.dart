import 'dart:typed_data';

import 'package:activity/infrastructure/models/data/each_markers_models.dart';
import 'package:activity/infrastructure/models/data/gym_data.dart';
import 'package:activity/infrastructure/models/data/lessontype_with_gyms_inside.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'map_state.freezed.dart';

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(false) bool isloading,
    @Default(null) Position? userPosition,
    @Default([]) List<EachMarkersModel> listOfMarkers,
    @Default(null) EachMarkersModel? activeMarker,
    @Default([]) List<double> distances,
    @Default(5) double selectedDiapozone,
    @Default(false) bool locationPermissionIsNOtGiven,
    @Default(false) bool locationServiceIsNotEnabled,
    @Default([false, false, false, true]) List<bool> listOfBool,
    @Default([]) List<GymData> gymFoundBySearching,
    @Default(false) bool isSearchbarOpened,
    @Default([]) List<LessonTypeWithGymsInside> activitiesWithGymsInsideAll,
    @Default([])
    List<LessonTypeWithGymsInside>
        activitiesWithGymsInsideFromSelectedDiapozone,
    @Default(false) bool showMapOnly,
    @Default(null) Uint8List? mapScreenShot,
    @Default(2) int topFlex,
    @Default(6) int bottomFlex,
    @Default(false) bool isLocationIconHidden,
  }) = _MapState;
  const MapState._();
}
