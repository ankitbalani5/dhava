import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../models/MyFeedModel.dart' as myFeed;
import '../../models/MyFeedModel.dart';
import '../../models/activityLikeModel.dart';
import '../../repository/api.dart';

part 'my_feed_event.dart';
part 'my_feed_state.dart';

class MyFeedBloc extends Bloc<MyFeedEvent, MyFeedState> {
  myFeed.MyFeedModel? myFeedModel;
  MyFeedBloc() : super(MyFeedInitial()) {
    on<GetMyFeedEvent>(_getMyFeed);
    on<MyFeedLikeEvent>(_likeFeed);
  }

  Future<void> _getMyFeed(GetMyFeedEvent event, Emitter<MyFeedState> emit) async {
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
      Constant.loadingDialog(event.context);
      var userId = "";
      var endPointUrl = ApiEndPoint.getMyFeed;
      if(event.userId.isNotEmpty){
        userId = "&user_id=${event.userId}";
        endPointUrl = ApiEndPoint.getUserFeed;
      }
      final response = await Api.getApi('$endPointUrl?per_page=${event.perPage}&page=${event.page}&category_id=${event.categoryId}$userId', headers, event.context);
      final result = MyFeedModel.fromJson(response);
      if(event.isPagination == true){
        Constant.closeLoadingDialog(event.context);
        myFeedModel!.data!.data!.addAll(result.data!.data!);
        emit(MyFeedSuccess(myFeedModel!));
      }else{
        Constant.closeLoadingDialog(event.context);
        myFeedModel = result;
        emit(MyFeedSuccess(myFeedModel!));
      }

    }
    else{

      emit(MyFeedLoading());
      try{

        var userId = "";
        var endPointUrl = ApiEndPoint.getMyFeed;
        if(event.userId.isNotEmpty){
          userId = "&user_id=${event.userId}";
          endPointUrl = ApiEndPoint.getUserFeed;
        }
        final response = await Api.getApi('$endPointUrl?per_page=${event.perPage}&page=${event.page}&category_id=${event.categoryId}$userId', headers, event.context);
        final result = MyFeedModel.fromJson(response);

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


  Future<void> _likeFeed(MyFeedLikeEvent event, Emitter<MyFeedState> emit) async {
    // emit(LikeFeedLoading());
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

        var feedModelCopy = myFeed.MyFeedModel(
          data: myFeed.Data(
            data: List<myFeed.MyFeedModelData>.from(myFeedModel?.data?.data ?? []),
          ),
        );

        for (var item in feedModelCopy.data!.data!) {
          if (item.activityId == event.activityId) {
            if(item.isLiked == false){

              item.isLiked = !item.isLiked!;
              item.totalLike = (item.totalLike ?? 0) + 1;
            }else{

              item.isLiked = !item.isLiked!;
              item.totalLike = (item.totalLike ?? 0) - 1;
            }
            break;
          }
        }
        emit(MyFeedSuccess(feedModelCopy));
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
