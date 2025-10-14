part of 'challenge_detail_bloc.dart';

@immutable
class ChallengeDetailEvent {
  final BuildContext context;
  final String challengeId;
  ChallengeDetailEvent({required this.context, required this.challengeId});
}
