import 'package:coherent_endurance/models/challengesDetailsModel.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class ChallengesDetailsState {}

final class ChallengesDetailsInitial extends ChallengesDetailsState {}
final class ChallengesDetailsLoading extends ChallengesDetailsState {}
final class ChallengesDetailsSuccess extends ChallengesDetailsState {
  final ChallengesDetailModel challengesDetailModel;
  ChallengesDetailsSuccess(this.challengesDetailModel);
}
final class ChallengesDetailsError extends ChallengesDetailsState {
  final String error;
  ChallengesDetailsError(this.error);
}








