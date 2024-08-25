// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfit/application/membership/membership_state.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/membership.dart';
import 'package:myfit/infrastructure/models/data/lesson.dart';
import 'package:myfit/infrastructure/models/data/membership.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/infrastructure/services/connectivity.dart';
import 'package:myfit/infrastructure/services/local_storage.dart';

class MembershipNotifier extends StateNotifier<MembershipState>{
  MembershipNotifier(this.membershipRepositoryInterface) : super(const MembershipState());
  final MembershipRepositoryInterface membershipRepositoryInterface;

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
              state = state.copyWith(
                gymIds: gymsWithMembership,
                getAllMembershipsLoading: false,
              );
            }
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
              state = state.copyWith(membershipsOfUser: data);
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

  void setSelectedActivity(String value){
    state = state.copyWith(selectedActivity: value);
  }

  void resetSelectedActivity(){
    state = state.copyWith(selectedActivity: "");
  }

  void setSelectedSubCategory(Subcategory value){
    state = state.copyWith(selectedSubCategory: value);
  }

  void resetSelectedSubCategory(){
    state = state.copyWith(selectedSubCategory: null);
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

}