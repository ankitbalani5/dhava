import 'dart:io';

import 'package:coherent_endurance/bloc/challengesBloc/challenges_event.dart';
import 'package:coherent_endurance/bloc/challengesBloc/challenges_state.dart';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/foundation.dart';

class GetAllChallengesBloc extends Bloc<GetAllChallengesEvent,GetAllChallengesState>{
  GetAllChallengesBloc() : super(GetAllChallengesInitial()) {
    on<GetAllChallengesEvent>(getAllChallenges);
  }


  Future<void> getAllChallenges(GetAllChallengesEvent event, Emitter<GetAllChallengesState> emit) async {
    emit(GetAllChallengesLoading());
    try{

      var header = {
        'Content-Type': 'application/json'
      };
      var context = event.context;

      final response = await Api.getApi(EndPoint.getAllChallenges, header ,context);

      if (kDebugMode) {
        print('getAllChallenges:::$response');
      }

      if (response != null) {
        if (response.statusCode == 200 && response.status == true) {
          emit(GetAllChallengesLoaded(response));
        } else {
          emit(GetAllChallengesError(response.message.toString()));
        }
      } else {
        emit(
          GetAllChallengesError(
            "Response not available, Please try again after some time",
          ),
        );
      }

    }on SocketException{
      emit(GetAllChallengesError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(GetAllChallengesError(e.toString()));
    }
  }


}