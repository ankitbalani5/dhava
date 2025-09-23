import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/profileModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../constant/Constant.dart';
import '../../models/categoryModel.dart';
import '../../repository/api.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<UpdateProfileEvent>(_updateProfile);
    on<GetProfileEvent>(_getProfile);
    on<CategoryEvent>(_getCategory);
  }

  Future<void> _getProfile(GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try{

      var body = {
        'user_id': event.userId,
      };
      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.getApiWithQuery(ApiEndPoint.getProfile, body, headers, event.context);
      final result = ProfileModel.fromJson(response);
      if (kDebugMode) {
        print('_getProfile:::$result');
      }
      if(result.statusCode == 200){
        Constant.getProfile = result;
        emit(ProfileSuccess(result));
      }else{
        emit(ProfileError(result.message.toString()));
      }
    }on SocketException{
      emit(ProfileError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _updateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(UpdateProfileLoading());

    try{

      var body = {
        'first_name': event.firstName,
        'last_name': event.lastName,
        'profile_pic': event.profilePic,
        'city': event.city,
        'state': event.state,
        'country': event.country,
        'address': event.address,
        'bio': event.bio,
        'dob': event.dob,
        'height': event.height,
        'height_unit_id': event.heightUnitId,
        'weight': event.weight,
        'weight_unit_id': event.weightUnitId,
        'gender': event.gender,
        'latitude': event.latitude,
        'longitude': event.longitude,
        'fitness_level': event.fitnessLevel,
        'plan_to_use': event.planToUse,
        'category_str': event.categoryIds,
      };
      var headers = {
        'authorization' : 'Bearer ${Constant.access_token}'
      };
      final response = await Api.updateProfileApi(ApiEndPoint.updateProfile, body, headers, event.context);
      final result = ProfileModel.fromJson(response);
      if (kDebugMode) {
        print('_updateProfile:::$result');
      }
      if(result.statusCode == 200){
        emit(UpdateProfileSuccess(result));
      }else{
        emit(UpdateProfileError(result.message.toString()));
      }
    }on SocketException{
      emit(UpdateProfileError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(UpdateProfileError(e.toString()));
    }
  }


  Future<void> _getCategory(CategoryEvent event, Emitter<ProfileState> emit) async {
    emit(CategoryLoading());
    try{

      // var body = {
      //   'email': event.email,
      //   'password': event.password,
      //   'confirm_password': event.confirmPassword,
      // };
      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.getApi(ApiEndPoint.getCategory, headers, event.context);
      final result = CategoryModel.fromJson(response);
      if (kDebugMode) {
        print('_getCategory:::$result');
      }
      if(result.statusCode == 200){

        Constant.getCategory = result;
        emit(CategorySuccess(result));
      }else{
        emit(CategoryError(result.message.toString()));
      }
    }on SocketException{
      emit(CategoryError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(CategoryError(e.toString()));
    }
  }

}
