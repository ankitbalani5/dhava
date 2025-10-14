import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/followRequestBloc/followRequest_event.dart';
import 'package:coherent_endurance/bloc/followRequestBloc/followRequest_state.dart';
import 'package:coherent_endurance/models/followRequestModel.dart';
import 'package:coherent_endurance/repository/api.dart';




class FollowRequestBloc extends Bloc<FollowRequestEvent, FollowRequestState> {

  FollowRequestBloc() : super(FollowRequestInitial()) {
    on<FollowRequestDataEvent>(followRequest);
  }



  Future<void> followRequest(FollowRequestDataEvent event,
      Emitter<FollowRequestState> emit) async {
    emit(FollowRequestLoading());
    try {
      final headers = {'Content-Type': 'application/json'};
      var body = {"to_user_id": event.toUserId};

      final response = await Api.postApi(
          ApiEndPoint.followRequest, body, headers,event.context);
      final result = FollowRequestModel.fromJson(response);

      if (result.statusCode == 200) {
        emit(FollowRequestSuccess(result));
      } else {
        emit(FollowRequestError(result.message.toString()));
      }
    } on SocketException {
      emit(FollowRequestError('Please check your internet connection'));
    } catch (e) {
      emit(FollowRequestError(e.toString()));
    }
  }


}
