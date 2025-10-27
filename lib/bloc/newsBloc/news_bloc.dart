import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/newsModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsModel? newsModel;
  NewsBloc() : super(NewsInitial()) {
    on<FetchNewsEvent>(_fetchNews);
  }

  Future<void> _fetchNews(FetchNewsEvent event, Emitter<NewsState> emit) async {
    if(event.isPagination != true){
      emit(NewsLoading());
    }
    try{

      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.getApi('${ApiEndPoint.newsAll}?per_page=${event.perPage}&page=${event.page}', headers, event.context);
      final result = NewsModel.fromJson(response);
      if(event.isPagination == true){
        print('pagination');
        newsModel!.data!.data!.addAll(result.data!.data!);
      }else{
        newsModel = result;
      }
      emit(NewsSuccess(newsModel!));
      // if(result.statusCode == 200){
      //   emit(NewsSuccess(result));
      // }else{
      //   emit(NewsError(result.message.toString()));
      // }
    }on SocketException{
      emit(NewsError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(NewsError(e.toString()));
    }
  }

}
