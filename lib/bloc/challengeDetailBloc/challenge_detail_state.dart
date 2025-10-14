part of 'challenge_detail_bloc.dart';

@immutable
sealed class ChallengeDetailState {}

final class ChallengeDetailInitial extends ChallengeDetailState {}
final class ChallengeDetailLoading extends ChallengeDetailState {}
final class ChallengeDetailSuccess extends ChallengeDetailState {
  final ChallengeDetailModel challengeDetailModel;
  ChallengeDetailSuccess(this.challengeDetailModel);
}
final class ChallengeDetailError extends ChallengeDetailState {
  final String error;
  ChallengeDetailError(this.error);
}
