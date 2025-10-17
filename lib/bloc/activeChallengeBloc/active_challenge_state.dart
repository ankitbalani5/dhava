part of 'active_challenge_bloc.dart';

@immutable
sealed class ActiveChallengeState {}

final class ActiveChallengeInitial extends ActiveChallengeState {}

final class ActiveChallengeLoading extends ActiveChallengeState {}
final class ActiveChallengeSuccess extends ActiveChallengeState {
  final ActiveChallengeModel activeChallengeModel;
  ActiveChallengeSuccess(this.activeChallengeModel);
}
final class ActiveChallengeError extends ActiveChallengeState {
  final String error;
  ActiveChallengeError(this.error);
}