import 'dart:io';
import 'package:coherent_endurance/bloc/activityBloc/challenges_event.dart';
import 'package:coherent_endurance/bloc/activityBloc/challenges_state.dart';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/getAllChallengesResponse.dart';
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

      final response = await Api.getApi(ApiEndPoint.getRecommendedChallenges, header ,context);

      final result = GetAllChallengesResponse.fromJson(response);
      if (kDebugMode) {
        print('getAllChallenges:::$response');
      }

      if(result.statusCode == 200){
        // suggestedModel = result;
        emit(GetAllChallengesLoaded(result));
      }else{
        emit(GetAllChallengesError(result.message.toString()));
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