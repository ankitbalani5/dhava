

import 'package:flutter/material.dart';

@immutable
sealed class UserJoinedChallengesEvent {}

class GetUserJoinedChallengesEvent extends UserJoinedChallengesEvent{
  final BuildContext context;
  final String perPage;
  final String page;
  final String user_id;
  final bool isPagination;
  GetUserJoinedChallengesEvent({required this.context, required this.perPage, required this.page, required this.user_id, this.isPagination = false});
}

