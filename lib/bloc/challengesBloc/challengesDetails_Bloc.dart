import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/challengesDetails_Event.dart';
import 'package:coherent_endurance/bloc/challengesBloc/challengesDetails_State.dart';
import 'package:coherent_endurance/models/challengesDetailsModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/foundation.dart';



class ChallengesDetailsBloc extends Bloc<GetChallengesDetailsEvent, ChallengesDetailsState> {


  ChallengesDetailsBloc() : super(ChallengesDetailsInitial()) {
    on<GetChallengesDetailsEvent>(getChallengesDetails);

  }


  Future<void> getChallengesDetails(GetChallengesDetailsEvent event, Emitter<ChallengesDetailsState> emit) async {
    final headers = {'Content-Type': 'application/json'};
    emit(ChallengesDetailsLoading());

    try {
      var challengeId = event.challengeId!.isNotEmpty ? "challenge_id=${event.challengeId}" :  "" ;
      var url = '${ApiEndPoint.challengesDetail}?$challengeId';

      final response = await Api.getApi(url, headers,event.context,);

      final result = ChallengesDetailModel.fromJson(response);

      if (result.statusCode == 200) {
        emit(ChallengesDetailsSuccess(result));
      } else {
        emit(ChallengesDetailsError(result.message ?? "Something went wrong"));
      }
    } on SocketException {
      emit(ChallengesDetailsError('Please check your internet connection'));
    } catch (e, stacktrace) {
      if (kDebugMode) print(stacktrace);
      emit(ChallengesDetailsError(e.toString()));
    }
  }


}
