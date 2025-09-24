import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/activityLikeModel.dart';
import 'package:coherent_endurance/models/feedModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../repository/api.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  FeedModel? feedModel;
  FeedModel? myFeedModel;
  ActivityBloc() : super(ActivityInitial()) {
    on<GetFeedEvent>(_getFeed);
    on<GetMyFeedEvent>(_getMyFeed);
    on<ActivityLikeEvent>(_likeFeed);
  }

  Future<void> _getFeed(GetFeedEvent event, Emitter<ActivityState> emit) async {
    var body = {
      'per_page': event.perPage,
      'page': event.page,
      'category_id': event.categoryId
    };
    final headers = {
      'Content-Type': 'application/json'
    };
    if(feedModel != null){
      final response = await Api.getApiWithQuery(ApiEndPoint.getFeed, body, headers, event.context);
      final result = FeedModel.fromJson(response);
      if(event.isPagination == true){
        feedModel!.data!.data!.addAll(result.data!.data!);
        emit(FeedSuccess(feedModel!));
      }else{
        feedModel = result;
        emit(FeedSuccess(feedModel!));
      }

    }else{

      emit(FeedLoading());
      try{

        final response = await Api.getApiWithQuery(ApiEndPoint.getFeed, body, headers, event.context);
        final result = FeedModel.fromJson(response);

        if(result.statusCode == 200){
          feedModel = result;
          emit(FeedSuccess(result));
        }else{
          emit(FeedError(result.message.toString()));
        }
      }on SocketException{
        emit(FeedError('Please check your internet connection'));
      }catch(e, stacktrace){
        if (kDebugMode) {
          print(stacktrace);
        }
        emit(FeedError(e.toString()));
      }
    }

  }

  Future<void> _getMyFeed(GetMyFeedEvent event, Emitter<ActivityState> emit) async {
    var body = {
      'per_page': event.perPage,
      'page': event.page,
      'category_id': event.categoryId,
      'user_id': event.userId
    };
    final headers = {
      'Content-Type': 'application/json'
    };
    if(myFeedModel != null){
      final response = await Api.getApiWithQuery(ApiEndPoint.getMyFeed, body, headers, event.context);
      final result = FeedModel.fromJson(response);
      if(event.isPagination == true){
        myFeedModel!.data!.data!.addAll(result.data!.data!);
        emit(MyFeedSuccess(myFeedModel!));
      }else{
        myFeedModel = result;
        emit(MyFeedSuccess(myFeedModel!));
      }

    }else{

      emit(MyFeedLoading());
      try{

        final response = await Api.getApiWithQuery(ApiEndPoint.getFeed, body, headers, event.context);
        final result = FeedModel.fromJson(response);

        if(result.statusCode == 200){
          myFeedModel = result;
          emit(MyFeedSuccess(result));
        }else{
          emit(MyFeedError(result.message.toString()));
        }
      }on SocketException{
        emit(MyFeedError('Please check your internet connection'));
      }catch(e, stacktrace){
        if (kDebugMode) {
          print(stacktrace);
        }
        emit(MyFeedError(e.toString()));
      }
    }

  }

  Future<void> _likeFeed(ActivityLikeEvent event, Emitter<ActivityState> emit) async {
    emit(LikeFeedLoading());
    try{

      var body = {
        'activity_id': event.activityId,
      };
      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.postApi(ApiEndPoint.activityLike, body, headers, event.context);
      final result = ActivityLikeModel.fromJson(response);

      if(result.statusCode == 200){
        emit(LikeFeedSuccess(result));
      }else{
        emit(LikeFeedError(result.message.toString()));
      }
    }on SocketException{
      emit(LikeFeedError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(LikeFeedError(e.toString()));
    }
  }

}
