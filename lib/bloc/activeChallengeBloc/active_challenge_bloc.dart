import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/activeChallengeModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'active_challenge_event.dart';
part 'active_challenge_state.dart';

class ActiveChallengeBloc extends Bloc<ActiveChallengeEvent, ActiveChallengeState> {
  ActiveChallengeModel? activeChallengeModel;
  ActiveChallengeBloc() : super(ActiveChallengeInitial()) {
    on<FetchActiveChallengeEvent>(_fetchActiveChallenge);
  }


  Future<void> _fetchActiveChallenge(FetchActiveChallengeEvent event, Emitter<ActiveChallengeState> emit) async {
    final headers = {'Content-Type': 'application/json'};



    emit(ActiveChallengeLoading());

    try {
      var category = event.categoryId.isNotEmpty ? "&category_id=${event.categoryId}" :  "" ;
      var url = '${ApiEndPoint.activeChallenge}?per_page=${event.perPage}&page=${event.page}$category';

      final response = await Api.getApi(url, headers,event.context,);

      final result = ActiveChallengeModel.fromJson(response);

      if (result.statusCode == 200) {
        if (event.isPagination == true && activeChallengeModel != null) {
          activeChallengeModel!.data!.data!.addAll(result.data!.data!);
          emit(ActiveChallengeSuccess(activeChallengeModel!));
        } else {
          activeChallengeModel = result;
          emit(ActiveChallengeSuccess(activeChallengeModel!));
        }
      } else {
        emit(ActiveChallengeError(result.message ?? "Something went wrong"));
      }
    } on SocketException {
      emit(ActiveChallengeError('Please check your internet connection'));
    } catch (e, stacktrace) {
      if (kDebugMode) print(stacktrace);
      emit(ActiveChallengeError(e.toString()));
    }
  }

}
