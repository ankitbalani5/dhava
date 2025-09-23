import 'package:flutter/material.dart';

abstract class AllChallengesEvent {}

class GetAllChallengesEvent extends AllChallengesEvent {
  BuildContext context;
  GetAllChallengesEvent(this.context);
}

