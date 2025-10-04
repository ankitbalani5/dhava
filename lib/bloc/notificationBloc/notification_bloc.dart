import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/notificationModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../repository/api.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationModel? notificationModel;
  NotificationBloc() : super(NotificationInitial()) {
    on<GetNotificationEvent>(_fetchNotification);
    on<FollowApproveEvent>(_followApprove);
    on<FollowCancelEvent>(_followCancel);
  }

  Future<void> _fetchNotification(GetNotificationEvent event, Emitter<NotificationState> emit) async {

    emit(NotificationLoading());
    try{

      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.getApi('${ApiEndPoint.notification}?per_page=${event.perPage}&page=${event.page}', headers, event.context);
      final result = NotificationModel.fromJson(response);

      if(result.statusCode == 200){
        notificationModel = result;
        emit(NotificationSuccess(notificationModel!));
      }else{
        emit(NotificationError(result.message.toString()));
      }
    }on SocketException{
      emit(NotificationError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _followApprove(FollowApproveEvent event, Emitter<NotificationState> emit) async {

    try{

      final body = {
        'from_user_id': event.fromUserId
      };

      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.postApi(ApiEndPoint.followApprove, body, headers, event.context);
      final result = NotificationModel.fromJson(response);

      if(result.statusCode == 200){

        if (notificationModel != null && notificationModel!.data != null && notificationModel!.data!.data != null) {
          for (var notif in notificationModel!.data!.data!) {
            if (notif.notificaionType == "Follow Request" && notif.fromUserId == event.fromUserId) {
              notif.notificaionType = "Follow Approved";
            }
          }
        }
        emit(NotificationSuccess(notificationModel!));
      }else{
        emit(NotificationError(result.message.toString()));
      }
    }on SocketException{
      emit(NotificationError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _followCancel(FollowCancelEvent event, Emitter<NotificationState> emit) async {

    try{

      final body = {
        'from_user_id': event.fromUserId
      };
      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.postApi(ApiEndPoint.followCancel, body, headers, event.context);
      final result = NotificationModel.fromJson(response);

      if(result.statusCode == 200){
        if (notificationModel != null && notificationModel!.data != null && notificationModel!.data!.data != null) {
          for (var notif in notificationModel!.data!.data!) {
            if (notif.notificaionType == "Follow Request" && notif.fromUserId == event.fromUserId) {
              notif.notificaionType = "Follow Approved";
            }
          }
        }

        emit(NotificationSuccess(notificationModel!));
        // Fluttertoast.showToast(msg: result.data.)
      }else{
        emit(NotificationError(result.message.toString()));
      }
    }on SocketException{
      emit(NotificationError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(NotificationError(e.toString()));
    }
  }
}
