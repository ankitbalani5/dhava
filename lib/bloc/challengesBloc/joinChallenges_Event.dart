import 'package:flutter/cupertino.dart';

@immutable
sealed class JoinChallengesEvent {}

class PostJoinChallengesEvent extends JoinChallengesEvent {
  final BuildContext context;
  final String challenges_Id;


  PostJoinChallengesEvent({
    required this.context,
    required this.challenges_Id,
  });
}