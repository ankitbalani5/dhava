import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/otherProfile_event.dart';
import 'package:coherent_endurance/bloc/profileBloc/otherProfile_state.dart';
import 'package:coherent_endurance/models/followRequestModel.dart';
import 'package:coherent_endurance/models/otherProfileModel.dart';
import 'package:coherent_endurance/models/postSuggestedModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class OtherProfileBloc extends Bloc<OtherProfileEvent, OtherProfileState> {
  PostSuggestedModel? suggestedModel;

  OtherProfileBloc() : super(OtherProfileInitial()) {
    on<OtherProfileDataEvent>(getOtherProfile);
    on<FollowRequestDataEvent>(followRequest);
  }


  Future<void> getOtherProfile(OtherProfileDataEvent event,
      Emitter<OtherProfileState> emit) async {
   // emit(OtherProfileLoading());

    try {
      final headers = {
        'Content-Type': 'application/json'
      };


      var url = '${ApiEndPoint.otherProfile}?user_id=${event.userId}';

      final response = await Api.getApi(url, headers, event.context);
      final result = OtherProfileModel.fromJson(response);

      if (result.statusCode == 200) {
        emit(OtherProfileSuccess(result));
      } else {
        emit(OtherProfileError(result.message.toString()));
      }
    } on SocketException {
      emit(OtherProfileError('Please check your internet connection'));
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(OtherProfileError(e.toString()));
    }
  }


  Future<void> followRequest(FollowRequestDataEvent event,
      Emitter<OtherProfileState> emit) async {
    emit(FollowRequestLoading());
    try {
      final headers = {'Content-Type': 'application/json'};
      var body = {"to_user_id": event.toUserId};

      final response = await Api.postApi(
          ApiEndPoint.followRequest, body, headers,event.context);
      final result = FollowRequestModel.fromJson(response);

      if (result.statusCode == 200) {
        emit(FollowRequestSuccess(result));
      } else {
        emit(FollowRequestError(result.message.toString()));
      }
    } on SocketException {
      emit(FollowRequestError('Please check your internet connection'));
    } catch (e) {
      emit(FollowRequestError(e.toString()));
    }
  }


}
