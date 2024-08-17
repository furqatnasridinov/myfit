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
        final response = await membershipRepositoryInterface.getMemberShipByUserId(userId: int.parse(LocalStorage.getUserId()));
        response.when(
          success: (data){
            if (data.isNotEmpty) {
              state = state.copyWith(membershipsOfUser: data);
            }
            debugPrint("getMembershipByUserId data: $data");
          }, 
          failure: (error, statusCode, info) {
            AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
          },
        );
      } catch (e) {
        debugPrint("getMembershipByUserId error: $e");
      }
    }else{
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> buyMemberShip(BuildContext context,{required int membershipId}) async{
    final bool connected = await AppConnectivity().connectivity();
    if (connected) {
      try {
        final int userId = int.parse(LocalStorage.getUserId());
        final response = await membershipRepositoryInterface.buyMembership(userId: userId, membershipId: membershipId);
        response.when(
          success: (data){
            //
            
          }, 
          failure: (error, statusCode, info) {
            AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
          },
        );
      } catch (e) {
        debugPrint("getMembershipByUserId error: $e");
      }
    }else{
      AppHelpers.showCheckTopSnackBar(context);
    }
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