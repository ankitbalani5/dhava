
import 'package:coherent_endurance/models/userJoinedChallengesModel.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class UserJoinedChallengesState {}

final class UserJoinedChallengesInitial extends UserJoinedChallengesState {}

final class UserJoinedChallengesLoading extends UserJoinedChallengesState {}
final class UserJoinedChallengesSuccess extends UserJoinedChallengesState {
  final UserJoinedChallengesModel userJoinedChallengesModel;
  UserJoinedChallengesSuccess(this.userJoinedChallengesModel);
}
final class UserJoinedChallengesError extends UserJoinedChallengesState {
  final String error;
  UserJoinedChallengesError(this.error);
}