import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfit/infrastructure/models/data/gym_data.dart';
import 'package:myfit/infrastructure/models/data/lessontype_with_gyms_inside.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myfit/infrastructure/models/response/user_schedules_response.dart';

part 'map_state.freezed.dart';

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(false) bool isloading,
    @Default(null) Position? userPosition,
    @Default({}) Set<Marker> listOfMarkers,
    @Default(null) Marker? activeMarker,
    @Default([]) List<double> distances,
    @Default(5) double selectedDiapozone,
    @Default(false) bool locationPermissionDenied,
    @Default(false) bool locationServiceIsNotEnabled,
    @Default([false, false, false, true]) List<bool> listOfBool,
    @Default([]) List<GymData> gymFoundBySearching,
    @Default(false) bool isSearchbarOpened,
    @Default(false) bool showOnlyKnown,
    @Default(false) bool showRecommended,
    @Default(null) Gym? selectedGym,
    @Default([]) List<LessonTypeWithGymsInside> activitiesWithGymsInsideAll,
    @Default([])
    List<LessonTypeWithGymsInside>
        activitiesWithGymsInsideFromSelectedDiapozone,
    @Default(false) bool showMapOnly,
    @Default(null) Uint8List? mapScreenShot,
    @Default(0.21) double topFlexValue,
    @Default(0.6) double bottomFlexValue,
    @Default(false) bool isLocationIconHidden,
    @Default(false) bool isGymsPopupShown,
    @Default("") String selectedLessonTypeFromMap,
  }) = _MapState;
  const MapState._();
}
