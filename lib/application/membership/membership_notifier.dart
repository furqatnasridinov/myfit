// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfit/application/membership/membership_state.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/activity.dart';
import 'package:myfit/domain/interface/membership.dart';
import 'package:myfit/infrastructure/models/data/lesson.dart';
import 'package:myfit/infrastructure/models/data/membership.dart';
import 'package:myfit/infrastructure/models/response/user_schedules_response.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/infrastructure/services/connectivity.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';

import '../../infrastructure/models/data/gym_with_activities_data.dart';

class MembershipNotifier extends StateNotifier<MembershipState>{
  MembershipNotifier(this.membershipRepositoryInterface, this.activityRepositoryInterface) : super(const MembershipState());
  final MembershipRepositoryInterface membershipRepositoryInterface;
  final ActivityRepositoryInterface activityRepositoryInterface;

  void resetLastInfos(){
    state = state.copyWith(
      selectedActivity: "",
      selectedSubCategory: null,
      subCategories: [],
    );
  }

  Future<void>getAllMemberships(BuildContext context)async{
    final bool connected = await AppConnectivity().connectivity();
    if (connected) {
      try {
        state = state.copyWith(getAllMembershipsLoading: true);
        final response = await membershipRepositoryInterface.getAllMemberships();
        response.when(
          success: (data){
            if (data.isNotEmpty) {
              // collect id of gyms that have membership
              List<int> gymsWithMembership = [];
              for (var element in data) {
                if (element.gyms!.isNotEmpty) {
                  for (var gym in element.gyms!) {
                    if (!gymsWithMembership.contains(gym.id)) {
                      gymsWithMembership.add(gym.id ?? 0);
                    }
                  }
                }
              }
              state = state.copyWith(gymIds: gymsWithMembership);
            }
            state = state.copyWith(getAllMembershipsLoading: false);
          }, 
          failure: (error, statusCode, info) {
            state = state.copyWith(getAllMembershipsLoading: false);
           // AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
          },
        );
      } catch (e) {
        debugPrint("getAllMemberships error: $e");
      }
    }else{
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getMembershipByGymId(BuildContext context,{required int gymId}) async{
    final bool connected = await AppConnectivity().connectivity();
    if (connected) {
      try {
        final response = await membershipRepositoryInterface.getMemberShipByGymId(gymId: gymId);
        response.when(
          success: (data){
            if (data.isNotEmpty) {
              state = state.copyWith(memberships: data);
            }
            debugPrint("getMembershipByGymId data: $data");
          }, 
          failure: (error, statusCode, info) {
            AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
          },
        );
      } catch (e) {
        debugPrint("getMembershipByGymId error: $e");
      }
    }else{
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getMembershipByUserId(BuildContext context) async{
    final bool connected = await AppConnectivity().connectivity();
    if (connected) {
      try {
        setUserMembershipsLoading(true);
        final int crmUserId = LocalStorage.getUserCrmId();
        final response = await membershipRepositoryInterface.getMemberShipByUserId(userId: crmUserId);
        response.when(
          success: (data){
            if (data.isNotEmpty) {
              final List<MemberShip> activesOnly = data.where((element) => element.state == "ACTIVE").toList();
              state = state.copyWith(membershipsOfUser: activesOnly);
            }
            setUserMembershipsLoading(false);
          }, 
          failure: (error, statusCode, info) {
            setUserMembershipsLoading(false);
            //AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
          },
        );
      } catch (e) {
        setUserMembershipsLoading(false);
        debugPrint("getMembershipByUserId error: $e");
      }
    }else{
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> buyMemberShip(BuildContext context,{required int membershipId, Function? onSuccess}) async{
    final bool connected = await AppConnectivity().connectivity();
    if (connected) {
      try {
        setBuyLoading(true);
        final response = await membershipRepositoryInterface.buyMembership(membershipId: membershipId);
        response.when(
          success: (data){
            if (data.isNotEmpty) {
              AppHelpers.showSuccessSnack(context, "Абонемент успешно куплен");
              onSuccess?.call();
            }
          }, 
          failure: (error, statusCode, info) {
            AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
            setBuyLoading(false);
          },
        );
      } catch (e) {
        debugPrint("buyMemberShip error: $e");
        setBuyLoading(false);
      }
    }else{
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  void setBuyLoading(bool value){
    state = state.copyWith(buyMembershipLoading: value);
  }

  void setUserMembershipsLoading(bool value){
    state = state.copyWith(getUserMembershipsLoading: value);
  }

  void getMembershipsToShow(){
    final List<MemberShip> memberships = state.memberships;
    final Subcategory? selectedSubCategory = state.selectedSubCategory;
    final String selectedActivity = state.selectedActivity;
    final List<MemberShip> membershipsToShow = [];
    if (selectedActivity.isNotEmpty && memberships.isNotEmpty) {
      if (selectedSubCategory != null) {
        for (var membership in memberships) {
          if (membership.lessonTypes!.contains(selectedActivity) && membership.lessonSubTypes?.any((element) => element.id == selectedSubCategory.id) == true) {
            membershipsToShow.add(membership);
          }
        }
      } else {
        for (var membership in memberships) {
          if (membership.lessonTypes!.contains(selectedActivity)) {
            membershipsToShow.add(membership);
          }
        }
      }
      
    }
    state = state.copyWith(membershipsToShow: membershipsToShow);
  }

  void setLoading(bool value){
    state = state.copyWith(isloading: value);
  }

  void setSelectedActivity(String value, {bool selectGym = false}){
    state = state.copyWith(selectedActivity: value);
    if (selectGym) {
      final List<GymWithActivitiesData> list = state.gymsWithActivitiesdatas;
      if (list.isNotEmpty) {
        final GymWithActivitiesData gymWithActivitiesData = list.firstWhere((element) => element.activitiesWithAllInfos.any((element) => element.activityName == value));
        state = state.copyWith(selectedGym: gymWithActivitiesData.gym);
      }
    }
  }

  void resetSelectedActivity(){
    state = state.copyWith(selectedActivity: "");
  }

  void setSelectedSubCategory(Subcategory value, {bool selectGym = false}){
    state = state.copyWith(selectedSubCategory: value);
    if (selectGym) {
      final List<GymWithActivitiesData> list = state.gymsWithActivitiesdatas;
      if (list.isNotEmpty) {
        final GymWithActivitiesData gymWithActivitiesData = list.firstWhere((element) => element.activitiesWithAllInfos.any((element) => element.subs?.any((element) => element.id == value.id) == true));
        state = state.copyWith(selectedGym: gymWithActivitiesData.gym);
      }
    }
  }

  void resetSelectedSubCategory(){
    if (state.selectedSubCategory != null) {
      state = state.copyWith(selectedSubCategory: null);
    }
  }

  void setSubCategories(Map<String, dynamic> data){
    if (data.isEmpty) {
      state = state.copyWith(subCategories: []);
    } else {
      final String selectedActivity = state.selectedActivity;
      final List<Subcategory> subCategories = [];
      data[selectedActivity].forEach((subCategory) {
      final List<MemberShip> memberships = state.memberships;
      for (var e in memberships) {
        if (e.lessonSubTypes?.any((element) => element.id == subCategory["id"]) == true) {
          subCategories.add(Subcategory.fromJson(subCategory));
        }
      }
      });
      state = state.copyWith(subCategories: subCategories);
      if (subCategories.isEmpty) {
        getMembershipsToShow();
      }
      if (subCategories.length == 1) {
        state = state.copyWith(selectedSubCategory: subCategories.first);
        getMembershipsToShow();
      }
    }
  }



  Future<void> getAllActivityDatas({required MemberShip membership}) async {
  final List<Gym>? gyms = membership.gyms;
  final List<String> activities = membership.lessonTypes ?? [];
  List<GymWithActivitiesData> resultList = [];
  if (gyms != null && gyms.isNotEmpty) {
    state = state.copyWith(activityDatasLoading: true);
    for (var gym in gyms) {
      GymWithActivitiesData gymWithActivitiesData = GymWithActivitiesData(gym: gym, activitiesWithAllInfos: []);
      List<ActivityWithAllInfos> listOfActivity = [];
      final Map<String, dynamic> infosForType = await getInfoForType(gymId: gym.id ?? 0);
      if (infosForType.isNotEmpty) {
        final List<String> keys = infosForType.keys.toList(); // activity names
        for (var key in keys) {
          if (activities.contains(key)) {
            final Map<String, dynamic> infos = infosForType[key][0] as Map<String, dynamic>;
            ActivityWithAllInfos activityWithAllInfos = ActivityWithAllInfos(
              activityName: key,
              infoForType: InfoForType.fromJson(infos),
            );
            listOfActivity.add(activityWithAllInfos);
          }
        }
      }
      final Map<String, dynamic> photos = await getPhotos(gymId: gym.id ?? 0);
      if (photos.isNotEmpty) {
        final List<String> keys = photos.keys.toList(); // activity names
        for (var key in keys) {
          if (activities.contains(key)) {
            final bool isExist = listOfActivity.any((activity) => activity.activityName == key);
            if (isExist) {
              listOfActivity.firstWhere((activity) => activity.activityName == key).photos = photos[key];
            } else {
              ActivityWithAllInfos activityWithAllInfos = ActivityWithAllInfos(
                activityName: key,
                photos: photos[key],
              );
              listOfActivity.add(activityWithAllInfos);
            }
          }
        }
      }
      final Map<String, dynamic> subCategoriesResultJson = await getSubCategories(gymId: gym.id ?? 0);
      if (subCategoriesResultJson.isNotEmpty) {
        final List<String> keys = subCategoriesResultJson.keys.toList(); // activity names
        for (var key in keys) {
          if (activities.contains(key)) {
            final bool isExist = listOfActivity.any((activity) => activity.activityName == key);
            if (isExist) {
              final List subs = subCategoriesResultJson[key];
              listOfActivity.firstWhere((activity) => activity.activityName == key).subs = subs.map((e) => Subs.fromJson(e)).toList();
            } else {
              final List subs = subCategoriesResultJson[key];
              ActivityWithAllInfos activityWithAllInfos = ActivityWithAllInfos(
                activityName: key,
                subs: subs.map((e) => Subs.fromJson(e)).toList(),
              );
              listOfActivity.add(activityWithAllInfos);
            }
          }
        }
      }
      gymWithActivitiesData.gym = gym;
      gymWithActivitiesData.activitiesWithAllInfos = listOfActivity;
      resultList.add(gymWithActivitiesData);
    }
    debugPrint("getAllActivityDatas resultList: $resultList");
    state = state.copyWith(gymsWithActivitiesdatas: resultList, activityDatasLoading: false);
  }
}


  Future<Map<String, dynamic>> getInfoForType({required int gymId}) async{
    final bool connected = await AppConnectivity().connectivity();
    if (connected) {
      try {
        final response = await activityRepositoryInterface.getInfoForType(id: gymId);
        return response.when(
          success: (data){
            if (data.isNotEmpty) {
              return data["object"];
            }else{
              return {};
            }
          }, 
          failure: (error, statusCode, info) {
            debugPrint("getInfoForType error: $error");
            return {};
          },
        );
      } catch (e) {
        debugPrint("getInfoForType error: $e");
        return {};
      }
    }else{
      return {};
    }
  }

  // get photos of gym => Map<String, dynamic> key: activity name, value: List<String> photos
  Future<Map<String, dynamic>> getPhotos({required int gymId}) async{
    final bool connected = await AppConnectivity().connectivity();
    if (connected) {
      try {
        final response = await activityRepositoryInterface.getGymPhotos(gymId: gymId);
        return response.when(
          success: (data){
            if (data.isNotEmpty) {
              return data["object"];
            }else{
              return {};
            }
          }, 
          failure: (error, statusCode, info) {
            debugPrint("getPhotos error: $error");
            return {};
          },
        );
      } catch (e) {
        debugPrint("getPhotos error: $e");
        return {};
      }
    }else{
      return {};
    }
  }

  // get subcategories of gym => Map<String, dynamic> key: activity name, value: List<Subcategory> subcategories
  Future<Map<String, dynamic>> getSubCategories({required int gymId}) async{
    final bool connected = await AppConnectivity().connectivity();
    if (connected) {
      try {
        final response = await activityRepositoryInterface.getActivities(gymId: gymId);
        return response.when(
          success: (data){
            if (data.isNotEmpty) {
              return data["object"];
            }else{
              return {};
            }
          }, 
          failure: (error, statusCode, info) {
            debugPrint("getSubCategories error: $error");
            return {};
          },
        );
      } catch (e) {
        debugPrint("getSubCategories error: $e");
        return {};
      }
    }else{
      return {};
    }
  }

  void setSelectedGym(Gym value){
    state = state.copyWith(selectedGym: value);
  }

  String getDescriptionToShow(){
    final list = state.gymsWithActivitiesdatas;
    final Gym? selectedGym = state.selectedGym;
    final String selectedActivity = state.selectedActivity;
    final Subcategory? selectedSubCategory = state.selectedSubCategory;
    final List<GymWithActivitiesData> listOfDAtas = state.gymsWithActivitiesdatas;
    String res = "";
    if (selectedActivity.isNotEmpty && selectedGym != null) {
       res =  list.firstWhere((element) => element.gym.id == selectedGym?.id).
          activitiesWithAllInfos.firstWhere((element) => element.activityName == selectedActivity)
          .infoForType?.typeDescription ?? "";
    }
    if (selectedSubCategory != null) {
      final bool? isInherited = selectedSubCategory.inheritance;
      if (isInherited == false) {
        res =  selectedSubCategory.typeDescription ?? "";
      }else if(isInherited == true){
        if (listOfDAtas.isNotEmpty) {
          for (var element in listOfDAtas) {
            if (element.gym.id == selectedGym?.id) {
              res = element.activitiesWithAllInfos.firstWhere((element) => element.activityName == selectedActivity)
              .infoForType?.typeDescription ?? "";
            }
          }
        }
      }
    }
    return res;
  }

  String getPeculiarityToShow(){
    final list = state.gymsWithActivitiesdatas;
    final Gym? selectedGym = state.selectedGym;
    final String selectedActivity = state.selectedActivity;
    final Subcategory? selectedSubCategory = state.selectedSubCategory;
    final List<GymWithActivitiesData> listOfDAtas = state.gymsWithActivitiesdatas;
    String res = "";
    if (selectedActivity.isNotEmpty && selectedGym != null) {
       res =  list.firstWhere((element) => element.gym.id == selectedGym.id).
          activitiesWithAllInfos.firstWhere((element) => element.activityName == selectedActivity)
          .infoForType?.peculiarities ?? "";
    }
    if (selectedSubCategory != null) {
      final bool? isInherited = selectedSubCategory.inheritance;
      if (isInherited == false) {
        res =  selectedSubCategory.peculiarities ?? "";
      }else if(isInherited == true){
        if (listOfDAtas.isNotEmpty) {
          for (var element in listOfDAtas) {
            if (element.gym.id == selectedGym?.id) {
              res = element.activitiesWithAllInfos.firstWhere((element) => element.activityName == selectedActivity)
              .infoForType?.peculiarities ?? "";
            }
          }
        }
      }
    }
    return res;
  }

  List<String> getPhotosToShow(){
    final list = state.gymsWithActivitiesdatas;
    final Gym? selectedGym = state.selectedGym;
    final String selectedActivity = state.selectedActivity;
    final Subcategory? selectedSubCategory = state.selectedSubCategory;
    final List<GymWithActivitiesData> listOfDAtas = state.gymsWithActivitiesdatas;
    List<String> res = [];
    if (selectedActivity.isNotEmpty && selectedGym != null) {
       res = List<String>.from(list.firstWhere((element) => element.gym.id == selectedGym.id).
          activitiesWithAllInfos.firstWhere((element) => element.activityName == selectedActivity).photos ?? []);
    }
    if (selectedSubCategory != null) {
      final bool? isInherited = selectedSubCategory.inheritance;
      if (isInherited == false) {
        List<String> photosToCollect = [];
        final List<GymSubActivePictures>? photos = listOfDAtas
            .firstWhere((element) => element.gym.id == selectedGym?.id).activitiesWithAllInfos
            .firstWhere((el) => el.subs!.any((sub) => sub.id == selectedSubCategory.id))
            .subs!.firstWhere((sub) => sub.id == selectedSubCategory.id).gymSubActivePictures;
        if (photos != null && photos.isNotEmpty) {
          for (var element in photos) {
            photosToCollect.add(element.pictureUrl ?? "");
          }
        }
        res = photosToCollect;
      }else if(isInherited == true){
        if (listOfDAtas.isNotEmpty) {
          for (var element in listOfDAtas) {
            if (element.gym.id == selectedGym?.id) {
              res = List<String>.from(element.activitiesWithAllInfos.firstWhere((element) => element.activityName == selectedActivity)
              .photos ?? []);
            }
          }
        }
      }
    }
    return res;
  }
}