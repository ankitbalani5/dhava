import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/updateEmailModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../repository/api.dart';

part 'update_email_event.dart';
part 'update_email_state.dart';

class UpdateEmailBloc extends Bloc<UpdateEmailEvent, UpdateEmailState> {
  UpdateEmailBloc() : super(UpdateEmailInitial()) {
    on<UpdateEmailEvent>(_updateEmail);
  }

  void _updateEmail(UpdateEmailEvent event, Emitter<UpdateEmailState> emit) async {
    emit(UpdateEmailLoading());
    try{

      var body = {
        'Email': event.email,
      };
      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.postApi(ApiEndPoint.updateEmail, body, headers, event.context);
      final result = UpdateEmailModel.fromJson(response);

      if(result.statusCode == 200){
        emit(UpdateEmailSuccess(result));
      }else{
        emit(UpdateEmailError(result.message.toString()));
      }
    }on SocketException{
      emit(UpdateEmailError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(UpdateEmailError(e.toString()));
    }
  }
}
