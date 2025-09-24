import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/suggested_event.dart';
import 'package:coherent_endurance/bloc/challengesBloc/suggested_state.dart';
import 'package:coherent_endurance/models/postSuggestedModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/foundation.dart';



class SuggestedBloc extends Bloc<PostSuggestedEvent, SuggestedState> {
  PostSuggestedModel? suggestedModel;

  SuggestedBloc() : super(PostSuggestedInitial()) {
    on<PostSuggestedEvent>(_postSuggestedChallenges);

  }


  Future<void> _postSuggestedChallenges(PostSuggestedEvent event, Emitter<SuggestedState> emit) async {
    final headers = {'Content-Type': 'application/json'};



    emit(PostSuggestedLoading());

    try {
      var category = event.categoryId.isNotEmpty ? "&category_id=${event.categoryId}" :  "" ;
      var url = '${ApiEndPoint.postAllChallenges}?per_page=${event.perPage}&page=${event.page}$category';

      final response = await Api.getApi(url, headers,event.context,);

      final result = PostSuggestedModel.fromJson(response);

      if (result.statusCode == 200) {
        if (event.isPagination == true && suggestedModel != null) {
          suggestedModel!.data!.data!.addAll(result.data!.data!);
          emit(PostSuggestedSuccess(suggestedModel!));
        } else {
          suggestedModel = result;
          emit(PostSuggestedSuccess(suggestedModel!));
        }
      } else {
        emit(PostSuggestedError(result.message ?? "Something went wrong"));
      }
    } on SocketException {
      emit(PostSuggestedError('Please check your internet connection'));
    } catch (e, stacktrace) {
      if (kDebugMode) print(stacktrace);
      emit(PostSuggestedError(e.toString()));
    }
  }


}
