import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/feedDetailModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../models/activityLikeModel.dart';
import '../../repository/api.dart';

part 'feed_detail_event.dart';
part 'feed_detail_state.dart';

class FeedDetailBloc extends Bloc<FeedDetailEvent, FeedDetailState> {
  FeedDetailModel? feedDetailModel;
  FeedDetailBloc() : super(FeedDetailInitial()) {
    on<FetchFeedDetailEvent>(_fetchFeedDetail);
    on<ActivityLikeEvent>(_likeFeed);
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
        feedDetailModel = result;
        emit(FeedDetailSuccess(feedDetailModel!));
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
  Future<void> _likeFeed(ActivityLikeEvent event, Emitter<FeedDetailState> emit) async {
    try {
      final body = {
        'activity_id': event.activityId,
      };
      final headers = {
        'Content-Type': 'application/json'
      };

      final response = await Api.postApi(ApiEndPoint.activityLike, body, headers, event.context);
      final result = ActivityLikeModel.fromJson(response);

      if (result.statusCode == 200) {
        if (feedDetailModel?.data != null) {
          feedDetailModel!.data!.isLiked = !(feedDetailModel!.data!.isLiked ?? false);
          feedDetailModel!.data!.totalLike =
              (feedDetailModel!.data!.totalLike ?? 0) +
                  (feedDetailModel!.data!.isLiked! ? 1 : -1);

          emit(FeedDetailSuccess(feedDetailModel!));
        } else {
          emit(LikeFeedError("Activity data is missing"));
        }

        // emit(FeedDetailSuccess(updatedFeedDetail));
      } else {
        emit(LikeFeedError(result.message.toString()));
      }
    } on SocketException {
      emit(LikeFeedError('Please check your internet connection'));
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(LikeFeedError(e.toString()));
    }
  }


// Future<void> _likeFeed(ActivityLikeEvent event, Emitter<FeedDetailState> emit) async {
  //   // emit(LikeFeedLoading());
  //   try{
  //
  //     var body = {
  //       'activity_id': event.activityId,
  //     };
  //     final headers = {
  //       'Content-Type': 'application/json'
  //     };
  //     final response = await Api.postApi(ApiEndPoint.activityLike, body, headers, event.context);
  //     final result = ActivityLikeModel.fromJson(response);
  //
  //     if(result.statusCode == 200){
  //
  //       var feedDetailCopy = FeedDetailModel(
  //         data: Data(
  //
  //         )
  //         /*data: Data(
  //           data: List<FeedModelData>.from(feedDetailModel?.data?.data ?? []),
  //         ),*/
  //       );
  //
  //       for (var item in feedModelCopy.data!.data!) {
  //         if (item.activityId == event.activityId) {
  //           if(item.isLiked == false){
  //
  //             item.isLiked = !item.isLiked!;
  //             item.totalLike = (item.totalLike ?? 0) + 1;
  //           }else{
  //
  //             item.isLiked = !item.isLiked!;
  //             item.totalLike = (item.totalLike ?? 0) - 1;
  //           }
  //           break;
  //         }
  //       }
  //       emit(FeedDetailSuccess(feedModelCopy));
  //     }else{
  //       emit(LikeFeedError(result.message.toString()));
  //     }
  //   }on SocketException{
  //     emit(LikeFeedError('Please check your internet connection'));
  //   }catch(e, stacktrace){
  //     if (kDebugMode) {
  //       print(stacktrace);
  //     }
  //     emit(LikeFeedError(e.toString()));
  //   }
  // }

}
