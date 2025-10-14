import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/profileModel.dart';
import 'package:coherent_endurance/models/summaryModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constant/Constant.dart';
import '../../models/categoryModel.dart';
import '../../repository/api.dart';
import 'package:http/http.dart' as http;
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileModel? profileModel;
  SummaryModel? summaryModel;
  ProfileBloc() : super(ProfileInitial()) {
    on<GetProfileEvent>(_getProfile);
    on<CategoryEvent>(_getCategory);
    on<GetProfileSummary>(_getProfileSummary);
  }

  Future<void> _getProfile(GetProfileEvent event, Emitter<ProfileState> emit) async {
    if(profileModel != null){
      emit(ProfileSuccess(profileModel, summaryModel));
    }
    else {
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
          profileModel = result;
          emit(ProfileSuccess(profileModel, summaryModel));
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
  }

  Future<void> _getProfileSummary(GetProfileSummary event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try{
      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.getApi('${ApiEndPoint.profileSummary}?category_id=${event.categoryId}', headers, event.context);
      final result = SummaryModel.fromJson(response);
      if (kDebugMode) {
        print('_summaryResponse:::$result');
      }
      if(result.statusCode == 200){
        summaryModel = result;
        emit(ProfileSuccess(profileModel, summaryModel));
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


  Future<void> _getCategory(CategoryEvent event, Emitter<ProfileState> emit) async {
    emit(CategoryLoading());
    try{

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
