import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/userJoinedChallengesBloc/userJoinedChallenges_Event.dart';
import 'package:coherent_endurance/bloc/userJoinedChallengesBloc/userJoinedChallenges_State.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/models/userJoinedChallengesModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/foundation.dart';



class UserjoinedChallengesBloc extends Bloc<UserJoinedChallengesEvent, UserJoinedChallengesState> {
  UserJoinedChallengesModel? userJoinedChallengesModel;
  UserjoinedChallengesBloc() : super(UserJoinedChallengesInitial()) {
    on<GetUserJoinedChallengesEvent>(getUserjoinedChallenges);

  }

  Future<void> getUserjoinedChallenges(GetUserJoinedChallengesEvent event, Emitter<UserJoinedChallengesState> emit) async {

    final headers = {
      'Content-Type': 'application/json'
    };

    if(userJoinedChallengesModel != null){
      Constant.loadingDialog(event.context);
      final response =await Api.getApi('${ApiEndPoint.userJoinedChallenges}?per_page=${event.perPage}&page=${event.page}&user_id=${event.user_id}', headers, event.context);
      final result = UserJoinedChallengesModel.fromJson(response);
      if(event.isPagination == true){
        Constant.closeLoadingDialog(event.context);
        userJoinedChallengesModel!.data!.data!.addAll(result.data!.data!);
        emit(UserJoinedChallengesSuccess(userJoinedChallengesModel!));
      }else{
        Constant.closeLoadingDialog(event.context);
        userJoinedChallengesModel = result;
        emit(UserJoinedChallengesSuccess(userJoinedChallengesModel!));
      }

    }
    else{

      emit(UserJoinedChallengesLoading());
      try{

        final response = await Api.getApi('${ApiEndPoint.userJoinedChallenges}?per_page=${event.perPage}&page=${event.page}&user_id=${event.user_id}', headers, event.context);
        final result = UserJoinedChallengesModel.fromJson(response);

        if(result.statusCode == 200){
          userJoinedChallengesModel = result;
          emit(UserJoinedChallengesSuccess(result));
        }else{
          emit(UserJoinedChallengesError(result.message.toString()));
        }
      }on SocketException{
        emit(UserJoinedChallengesError('Please check your internet connection'));
      }catch(e, stacktrace){
        if (kDebugMode) {
          print(stacktrace);
        }
        emit(UserJoinedChallengesError(e.toString()));
      }
    }

  }



}
