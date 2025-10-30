
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/deleteAccountBloc/deleteAccount_event.dart';
import 'package:coherent_endurance/bloc/deleteAccountBloc/deleteAccount_state.dart';
import 'package:coherent_endurance/models/deleteAccountModel.dart';
import 'package:flutter/foundation.dart';
import '../../repository/api.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc() : super(DeleteAccountInitial()) {
    on<PostDeleteAccountEvent>(deleteAccount);
  }

  Future<void> deleteAccount(PostDeleteAccountEvent event, Emitter<DeleteAccountState> emit) async {
    emit(DeleteAccountLoading());
    try{

      var body = {
        'remark': event.remark,
      };
      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.postApi(ApiEndPoint.deleteAccount, body, headers, event.context);
      final result = DeleteAccountModel.fromJson(response);

      if(result.statusCode == 200){
        emit(DeleteAccountSuccess(result));
      }else{
        emit(DeleteAccountError(result.message.toString()));
      }
    }on SocketException{
      emit(DeleteAccountError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(DeleteAccountError(e.toString()));
    }
  }


}
