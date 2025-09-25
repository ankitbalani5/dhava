import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/suggested_event.dart';
import 'package:coherent_endurance/bloc/challengesBloc/suggested_state.dart';
import 'package:coherent_endurance/bloc/profileBloc/otherProfile_event.dart';
import 'package:coherent_endurance/bloc/profileBloc/otherProfile_state.dart';

import 'package:coherent_endurance/models/postSuggestedModel.dart';
import 'package:coherent_endurance/models/profileModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/foundation.dart';



class OtherProfileBloc extends Bloc<OtherProfileDataEvent, OtherProfileState> {
  PostSuggestedModel? suggestedModel;

  OtherProfileBloc() : super(OtherProfileInitial()) {
    on<OtherProfileDataEvent>(getOtherProfile);

  }


  Future<void> getOtherProfile(OtherProfileDataEvent event, Emitter<OtherProfileState> emit) async {
    emit(OtherProfileLoading());

    try {
      final headers = {
        'Content-Type': 'application/json'
      };


      var url = '${ApiEndPoint.otherProfile}?user_id=${event.userId}';

      final response = await Api.getApi(url, headers, event.context);
      final result = ProfileModel.fromJson(response);

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


}
