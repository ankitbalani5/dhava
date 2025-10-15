import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/trophyModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../repository/api.dart';

part 'trophy_event.dart';
part 'trophy_state.dart';

class TrophyBloc extends Bloc<TrophyEvent, TrophyState> {
  TrophyBloc() : super(TrophyInitial()) {
    on<MyTrophyEvent>(_myTrophyFetch);
  }

  Future<void> _myTrophyFetch(MyTrophyEvent event, Emitter<TrophyState> emit) async {
    emit(MyTrophyLoading());
    try{

      final headers = {
        'Content-Type': 'application/json'
      };
      var userId = "";
      var endPointUrl = ApiEndPoint.myTrophy;
      if(event.userId.isNotEmpty){
        userId = "&user_id=${event.userId}";
        endPointUrl = ApiEndPoint.userTrophy;
      }
      final response = await Api.getApi('$endPointUrl?per_page=${event.perPage}&page=${event.page}&category_id=${event.categoryId}$userId', headers, event.context);
      final result = TrophyModel.fromJson(response);

      if(result.statusCode == 200){
        emit(MyTrophySuccess(result));
      }else{
        emit(MyTrophyError(result.message.toString()));
      }
    }on SocketException{
      emit(MyTrophyError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(MyTrophyError(e.toString()));
    }
  }

}
