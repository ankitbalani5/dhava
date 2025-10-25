import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/newsDetailModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'news_detail_event.dart';
part 'news_detail_state.dart';

class NewsDetailBloc extends Bloc<NewsDetailEvent, NewsDetailState> {
  NewsDetailBloc() : super(NewsDetailInitial()) {
    on<FetchNewsDetailEvent>(_fetchNews);
  }

  Future<void> _fetchNews(FetchNewsDetailEvent event, Emitter<NewsDetailState> emit) async {
    emit(NewsDetailLoading());
    try{

      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.getApi('${ApiEndPoint.newsDetail}?news_id=${event.newsId}', headers, event.context);
      final result = NewsDetailModel.fromJson(response);

      if(result.statusCode == 200){
        emit(NewsDetailSuccess(result));
      }else{
        emit(NewsDetailError(result.message.toString()));
      }
    }on SocketException{
      emit(NewsDetailError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(NewsDetailError(e.toString()));
    }
  }
}
