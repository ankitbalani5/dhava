import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/otherProfileBloc/otherProfile_event.dart';
import 'package:coherent_endurance/bloc/otherProfileBloc/otherProfile_state.dart';
import 'package:coherent_endurance/models/otherProfileModel.dart';
import 'package:coherent_endurance/models/postSuggestedModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/foundation.dart';

import '../../models/summaryModel.dart';


class OtherProfileBloc extends Bloc<OtherProfileEvent, OtherProfileState> {
  OtherProfileModel? profileModel;
  SummaryModel? summaryModel;
  OtherProfileBloc() : super(OtherProfileInitial()) {
    on<OtherProfileDataEvent>(getOtherProfile);
    on<GetOtherProfileSummary>(_getOtherProfileSummary);
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
        profileModel = result;
        emit(OtherProfileSuccess(profileModel, summaryModel));
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

  Future<void> _getOtherProfileSummary(GetOtherProfileSummary event, Emitter<OtherProfileState> emit) async {
    emit(OtherProfileLoading());

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
        emit(OtherProfileSuccess(profileModel, summaryModel));
      }else{
        emit(OtherProfileError(result.message.toString()));
      }
    }on SocketException{
      emit(OtherProfileError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(OtherProfileError(e.toString()));
    }
  }




}
