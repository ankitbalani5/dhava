import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/myJoinedChallengesBloc/myJoinedChallenges_Event.dart';
import 'package:coherent_endurance/bloc/myJoinedChallengesBloc/myJoinedChallenges_State.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/models/myJoinedAllChallengesModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/foundation.dart';



class MyjoinedChallengesBloc extends Bloc<MyjoinedChallengesEvent, MyjoinedChallengesState> {
  MyJoinedAllChallengesModel? myJoinedChallengesModel;
  MyjoinedChallengesBloc() : super(MyjoinedChallengesInitial()) {
    on<GetMyjoinedChallengesEvent>(getMyjoinedChallenges);

  }

  Future<void> getMyjoinedChallenges(GetMyjoinedChallengesEvent event, Emitter<MyjoinedChallengesState> emit) async {

    final headers = {
      'Content-Type': 'application/json'
    };

    if(myJoinedChallengesModel != null){
      Constant.loadingDialog(event.context);
      final response =await Api.getApi('${ApiEndPoint.myJoinedChallenges}?per_page=${event.perPage}&page=${event.page}&category_id=${event.categoryId}', headers, event.context);
      final result = MyJoinedAllChallengesModel.fromJson(response);
      if(event.isPagination == true){
        Constant.closeLoadingDialog(event.context);
        myJoinedChallengesModel!.data!.data!.addAll(result.data!.data!);
        emit(MyjoinedChallengesSuccess(myJoinedChallengesModel!));
      }else{
        Constant.closeLoadingDialog(event.context);
        myJoinedChallengesModel = result;
        emit(MyjoinedChallengesSuccess(myJoinedChallengesModel!));
      }

    }
    else{

      emit(MyjoinedChallengesLoading());
      try{

        final response = await Api.getApi('${ApiEndPoint.myJoinedChallenges}?per_page=${event.perPage}&page=${event.page}&category_id=${event.categoryId}', headers, event.context);
        final result = MyJoinedAllChallengesModel.fromJson(response);

        if(result.statusCode == 200){
          myJoinedChallengesModel = result;
          emit(MyjoinedChallengesSuccess(result));
        }else{
          emit(MyjoinedChallengesError(result.message.toString()));
        }
      }on SocketException{
        emit(MyjoinedChallengesError('Please check your internet connection'));
      }catch(e, stacktrace){
        if (kDebugMode) {
          print(stacktrace);
        }
        emit(MyjoinedChallengesError(e.toString()));
      }
    }

  }



}
