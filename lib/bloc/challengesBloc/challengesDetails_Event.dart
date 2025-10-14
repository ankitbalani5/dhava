

import 'package:flutter/cupertino.dart';

@immutable
sealed class ChallengesDetailsEvent {}

class GetChallengesDetailsEvent extends ChallengesDetailsEvent{
  final BuildContext context;
  final String? challengeId;

  GetChallengesDetailsEvent({required this.context, required this.challengeId});
}
