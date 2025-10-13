import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/myAllChallengeModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../repository/api.dart';

part 'my_all_challenge_event.dart';
part 'my_all_challenge_state.dart';

class MyAllChallengeBloc extends Bloc<MyAllChallengeEvent, MyAllChallengeState> {
  MyAllChallengeBloc() : super(MyAllChallengeInitial()) {
    on<MyAllChallengeEvent>(_myAllChallengeFetch);
  }

  Future<void> _myAllChallengeFetch(MyAllChallengeEvent event, Emitter<MyAllChallengeState> emit) async {
    emit(MyAllChallengeLoading());
    try{

      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.getApi('${ApiEndPoint.myAllChallenge}?per_page=${event.perPage}&page=${event.page}&category_id=${event.categoryId}',
          headers, event.context);
      final result = MyAllChallengeModel.fromJson(response);

      if(result.statusCode == 200){
        emit(MyAllChallengeSuccess(result));
      }else{
        emit(MyAllChallengeError(result.message.toString()));
      }
    }on SocketException{
      emit(MyAllChallengeError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(MyAllChallengeError(e.toString()));
    }
  }
}
