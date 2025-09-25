import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/joinChallenges_Event.dart';
import 'package:coherent_endurance/bloc/challengesBloc/joinChallenges_State.dart';
import 'package:coherent_endurance/models/joinChallengesModel.dart';
import 'package:coherent_endurance/repository/api.dart';
import 'package:flutter/foundation.dart';

class JoinChalllengesBloc extends Bloc<PostJoinChallengesEvent, JoinchallengesState> {
  JoinChalllengesBloc() : super(PostJoinchallengesInitial()) {
    on<PostJoinChallengesEvent>(joinChallenges);
  }

  Future<void> joinChallenges(
      PostJoinChallengesEvent event, Emitter<JoinchallengesState> emit) async {

    emit(PostJoinchallengesLoading(event.challenges_Id));

    try {
      final headers = {
        'Content-Type': 'application/json'
      };

      var body = {
        'challenge_id': event.challenges_Id
      };

      final response = await Api.postApi(
        ApiEndPoint.joinChallenges,
        body,
        headers,
        event.context,
      );

      final result = JoinChallengesModel.fromJson(response);

      if (result.statusCode == 200) {

        emit(PostJoinchallengesSuccess(
          challengeId: event.challenges_Id,
          joinChallengesModel: result,
        ));
      } else {
        emit(PostJoinchallengesError(
          challengeId: event.challenges_Id,
          error: result.message.toString(),
        ));
      }
    } on SocketException {
      emit(PostJoinchallengesError(
        challengeId: event.challenges_Id,
        error: 'Please check your internet connection',
      ));
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(PostJoinchallengesError(
        challengeId: event.challenges_Id,
        error: e.toString(),
      ));
    }
  }
}
