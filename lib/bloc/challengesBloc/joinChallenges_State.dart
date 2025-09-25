import 'package:coherent_endurance/models/joinChallengesModel.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class JoinchallengesState {}

final class PostJoinchallengesInitial extends JoinchallengesState {}

final class PostJoinchallengesLoading extends JoinchallengesState {
  final String challengeId;
  PostJoinchallengesLoading(this.challengeId);
}

final class PostJoinchallengesSuccess extends JoinchallengesState {
  final String challengeId;
  final JoinChallengesModel joinChallengesModel;
  PostJoinchallengesSuccess({
    required this.challengeId,
    required this.joinChallengesModel,
  });
}

final class PostJoinchallengesError extends JoinchallengesState {
  final String challengeId;
  final String error;
  PostJoinchallengesError({
    required this.challengeId,
    required this.error,
  });
}
