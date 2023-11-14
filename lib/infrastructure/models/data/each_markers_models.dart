import 'package:equatable/equatable.dart';


/// Модель точки на карте
class EachMarkersModel extends Equatable {
  EachMarkersModel({
  this.isOpened = false,
   required this.name,
   required this.latitude,
   required this.longitude,
   required this.address,
   required this.id,
 });


 /// Название населенного пункта
 final String name;


 /// Широта
 final double latitude;


 /// Долгота
 final double longitude;

 // status
 bool isOpened;

 // address
 final String address;

 // id
 final int id;


 @override
 List<Object?> get props => [name, latitude, longitude, isOpened, address];
}