part of 'my_all_challenge_bloc.dart';

@immutable
sealed class MyAllChallengeState {}

final class MyAllChallengeInitial extends MyAllChallengeState {}
final class MyAllChallengeLoading extends MyAllChallengeState {}
final class MyAllChallengeSuccess extends MyAllChallengeState {
  final MyAllChallengeModel myAllChallengeModel;
  MyAllChallengeSuccess(this.myAllChallengeModel);
}
final class MyAllChallengeError extends MyAllChallengeState {
  final String error;
  MyAllChallengeError(this.error);
}
