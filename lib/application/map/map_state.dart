import 'package:activity/infrastructure/models/data/each_markers_models.dart';
import 'package:activity/infrastructure/models/data/gym_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'map_state.freezed.dart';

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(false) bool isloading,
    @Default(null) Position? userPosition,
    @Default([]) List<EachMarkersModel> listOfMarkers,
    @Default([]) List<GymData> listOfActivities,
    @Default(null) EachMarkersModel? activeMarker,
    @Default([]) List<double> distances,
    @Default(5) double selectedDiapozone,
    @Default([false, false,false,true]) List<bool> listOfBool,
    @Default([]) List<GymData> listOfActivitiesFromSelectedDiapozone,
    @Default([])List<GymData> gymFoundBySearching,
    @Default(false) bool isSearchbarOpened,
  }) = _MapState;
  const MapState._();
}
