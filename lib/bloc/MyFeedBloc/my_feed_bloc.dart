import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../models/MyFeedModel.dart';
import '../../repository/api.dart';

part 'my_feed_event.dart';
part 'my_feed_state.dart';

class MyFeedBloc extends Bloc<MyFeedEvent, MyFeedState> {
  MyFeedModel? myFeedModel;
  MyFeedBloc() : super(MyFeedInitial()) {
    on<GetMyFeedEvent>(_getMyFeed);
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
      final response = await Api.getApi('${ApiEndPoint.getMyFeed}?per_page=${event.perPage}&page=${event.page}&category_id=${event.categoryId}&user_id=', headers, event.context);
      final result = MyFeedModel.fromJson(response);
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

        final response = await Api.getApi('${ApiEndPoint.getMyFeed}?per_page=${event.perPage}&page=${event.page}&category_id=${event.categoryId}&user_id=', headers, event.context);
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
}
