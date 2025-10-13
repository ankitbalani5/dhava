import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/challengeDetailModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../repository/api.dart';

part 'challenge_detail_event.dart';
part 'challenge_detail_state.dart';

class ChallengeDetailBloc extends Bloc<ChallengeDetailEvent, ChallengeDetailState> {
  ChallengeDetailBloc() : super(ChallengeDetailInitial()) {
    on<ChallengeDetailEvent>(_challengeDetailFetch);
  }


  Future<void> _challengeDetailFetch(ChallengeDetailEvent event, Emitter<ChallengeDetailState> emit) async {
    emit(ChallengeDetailLoading());
    try{

      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.getApi('${ApiEndPoint.challengeDetail}?challenge_id=${event.challengeId}',
          headers, event.context);
      final result = ChallengeDetailModel.fromJson(response);

      if(result.statusCode == 200){
        emit(ChallengeDetailSuccess(result));
      }else{
        emit(ChallengeDetailError(result.message.toString()));
      }
    }on SocketException{
      emit(ChallengeDetailError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(ChallengeDetailError(e.toString()));
    }
  }

}
