import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/otherProfileBloc/otherProfile_event.dart';
import 'package:coherent_endurance/bloc/otherProfileBloc/otherProfile_state.dart';
import 'package:coherent_endurance/models/otherProfileModel.dart';
import 'package:coherent_endurance/models/postSuggestedModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/foundation.dart';


class OtherProfileBloc extends Bloc<OtherProfileEvent, OtherProfileState> {
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




}
