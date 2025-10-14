import 'dart:convert';
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
part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {

  ProfileModel? profileModel;
  SummaryModel? summaryModel;

  UpdateProfileBloc() : super(UpdateProfileInitial()) {
    on<UpdateProfileEvent>(_updateProfile);
  }

  Future<void> _updateProfile(UpdateProfileEvent event, Emitter<UpdateProfileState> emit) async {
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
        'primary_category_id': event.primaryCategoryId
      };

      print(jsonEncode(body));

      var headers = {
        'authorization' : 'Bearer ${Constant.access_token}'
      };
      final response = await Api.updateProfileApi(ApiEndPoint.updateProfile, body, headers, event.context);
      final result = ProfileModel.fromJson(response);
      if (kDebugMode) {
        print('_updateProfile:::$result');
      }
      if(result.statusCode == 200){
        //event.context.read<ProfileBloc>().add(GetProfileEvent(event.context, ''));
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

}
