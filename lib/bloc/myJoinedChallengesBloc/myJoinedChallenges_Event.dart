

import 'package:flutter/material.dart';

@immutable
sealed class MyjoinedChallengesEvent {}

class GetMyjoinedChallengesEvent extends MyjoinedChallengesEvent{
  final BuildContext context;
  final String perPage;
  final String page;
  final String categoryId;
  final bool isPagination;
  GetMyjoinedChallengesEvent({required this.context, required this.perPage, required this.page, required this.categoryId, this.isPagination = false});
}

