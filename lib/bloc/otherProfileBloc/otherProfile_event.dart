

import 'package:flutter/cupertino.dart';

@immutable
sealed class OtherProfileEvent {}

class OtherProfileDataEvent extends OtherProfileEvent{
  final BuildContext context;
  final String userId;
  OtherProfileDataEvent({required this.context,
    required this.userId, });
}


