import 'package:coherent_endurance/bloc/MyFeedBloc/my_feed_bloc.dart';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/suggestionBloc/suggestion_event.dart';
import 'package:coherent_endurance/bloc/suggestionBloc/suggestion_state.dart';
import 'package:coherent_endurance/constant/Constant.dart';
import 'package:coherent_endurance/models/suggestionsModel.dart';
import 'package:coherent_endurance/models/unfollowModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/foundation.dart';


class SuggestionBloc extends Bloc<SuggestionEvent, SuggestionState>{

  SuggestionsModel? suggestionModel;
  SuggestionBloc() : super(SuggestionInitial()) {
    on<GetSuggestionEvent>(getSuggestion);
    on<UnfollowRequestEvent>(unfollowRequest);

  }
  Future<void> getSuggestion(GetSuggestionEvent event, Emitter<SuggestionState> emit) async {

    final headers = {
      'Content-Type': 'application/json'
    };

    if(suggestionModel != null){
      Constant.loadingDialog(event.context);
      final response = await Api.getApi('${ApiEndPoint.suggestions}?per_page=${event.perPage}&page=${event.page}', headers, event.context);

      final result = SuggestionsModel.fromJson(response);
      if(event.isPagination == true){
        Constant.closeLoadingDialog(event.context);

       suggestionModel?.data?.data!.addAll(result.data!.data!);
        emit(SuggestionSuccess(suggestionModel!));
      }else{
        Constant.closeLoadingDialog(event.context);
        suggestionModel = result;
        emit(SuggestionSuccess(suggestionModel!));
      }

    }else{

      emit(SuggestionLoading());
      try{

        final response = await Api.getApi('${ApiEndPoint.suggestions}?per_page=${event.perPage}&page=${event.page}', headers, event.context);
        final result = SuggestionsModel.fromJson(response);

        if(result.statusCode == 200){
          suggestionModel = result;
          emit(SuggestionSuccess(result));
        }else{
          emit(SuggestionError(result.message.toString()));
        }
      }on SocketException{
        emit(SuggestionError('Please check your internet connection'));
      }catch(e, stacktrace){
        if (kDebugMode) {
          print(stacktrace);
        }
        emit(SuggestionError(e.toString()));
      }
    }

  }


  Future<void> unfollowRequest(UnfollowRequestEvent event,
      Emitter<SuggestionState> emit) async {
    emit(UnfollowLoading());
    try {
      final headers = {'Content-Type': 'application/json'};
      var body = {"to_user_id": event.to_user_id};

      final response = await Api.postApi(
          ApiEndPoint.unfollow, body, headers,event.context);
      final result = UnfollowModel.fromJson(response);

      if (result.statusCode == 200) {
        print("➡️ Unfollow API triggered for user: ${event.to_user_id}");
        emit(UnfollowSuccess(result));
      } else {
        emit(UnfollowError(result.message.toString()));
      }
    } on SocketException {
      emit(UnfollowError('Please check your internet connection'));
    } catch (e) {
      emit(UnfollowError(e.toString()));
    }
  }

}