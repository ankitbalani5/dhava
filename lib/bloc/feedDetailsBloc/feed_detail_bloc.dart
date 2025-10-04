import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/feedDetailModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../repository/api.dart';

part 'feed_detail_event.dart';
part 'feed_detail_state.dart';

class FeedDetailBloc extends Bloc<FeedDetailEvent, FeedDetailState> {
  FeedDetailBloc() : super(FeedDetailInitial()) {
    on<FetchFeedDetailEvent>(_fetchFeedDetail);
  }

  Future<void> _fetchFeedDetail(FetchFeedDetailEvent event, Emitter<FeedDetailState> emit) async {
    emit(FeedDetailLoading());
    try{

      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.getApi('${ApiEndPoint.getFeedDetail}?activity_id=${event.activityId}', headers, event.context);
      final result = FeedDetailModel.fromJson(response);

      if(result.statusCode == 200){
        emit(FeedDetailSuccess(result));
      }else{
        emit(FeedDetailError(result.message.toString()));
      }
    }on SocketException{
      emit(FeedDetailError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(FeedDetailError(e.toString()));
    }
  }
}
