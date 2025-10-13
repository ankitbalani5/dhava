

import 'package:coherent_endurance/models/myJoinedAllChallengesModel.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class MyjoinedChallengesState {}

final class MyjoinedChallengesInitial extends MyjoinedChallengesState {}

final class MyjoinedChallengesLoading extends MyjoinedChallengesState {}
final class MyjoinedChallengesSuccess extends MyjoinedChallengesState {
  final MyJoinedAllChallengesModel myJoinedChallengesModel;
  MyjoinedChallengesSuccess(this.myJoinedChallengesModel);
}
final class MyjoinedChallengesError extends MyjoinedChallengesState {
  final String error;
  MyjoinedChallengesError(this.error);
}