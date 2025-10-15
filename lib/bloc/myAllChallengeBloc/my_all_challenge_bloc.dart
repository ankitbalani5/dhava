import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/myAllChallengeModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../repository/api.dart';

part 'my_all_challenge_event.dart';
part 'my_all_challenge_state.dart';

class MyAllChallengeBloc extends Bloc<ChallengeEvent, MyAllChallengeState> {
  MyAllChallengeBloc() : super(MyAllChallengeInitial()) {
    on<MyAllChallengeEvent>(_myAllChallengeFetch);
    // on<UserAllChallengeEvent>(_userAllChallengeFetch);
  }

  Future<void> _myAllChallengeFetch(MyAllChallengeEvent event, Emitter<MyAllChallengeState> emit) async {
    emit(MyAllChallengeLoading());
    try{

      final headers = {
        'Content-Type': 'application/json'
      };
      var userId = "";
      var endPointUrl = ApiEndPoint.myAllChallenge;
      if(event.userId.isNotEmpty){
        userId = "&user_id=${event.userId}";
        endPointUrl = ApiEndPoint.userAllChallenge;
      }
      final response = await Api.getApi('$endPointUrl?per_page=${event.perPage}&page=${event.page}&category_id=${event.categoryId}$userId',
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

  // Future<void> _userAllChallengeFetch(UserAllChallengeEvent event, Emitter<MyAllChallengeState> emit) async {
  //   emit(MyAllChallengeLoading());
  //   try{
  //
  //     final headers = {
  //       'Content-Type': 'application/json'
  //     };
  //     final response = await Api.getApi('${ApiEndPoint.userAllChallenge}?per_page=${event.perPage}&page=${event.page}&category_id=${event.categoryId}&user_id=${event.userId}',
  //         headers, event.context);
  //     final result = MyAllChallengeModel.fromJson(response);
  //
  //     if(result.statusCode == 200){
  //       emit(MyAllChallengeSuccess(result));
  //     }else{
  //       emit(MyAllChallengeError(result.message.toString()));
  //     }
  //   }on SocketException{
  //     emit(MyAllChallengeError('Please check your internet connection'));
  //   }catch(e, stacktrace){
  //     if (kDebugMode) {
  //       print(stacktrace);
  //     }
  //     emit(MyAllChallengeError(e.toString()));
  //   }
  // }
}
