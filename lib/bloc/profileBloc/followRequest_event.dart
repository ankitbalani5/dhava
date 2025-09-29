
import 'package:flutter/cupertino.dart';

@immutable
sealed class FollowRequestEvent {}


class FollowRequestDataEvent extends FollowRequestEvent{
  final BuildContext context;
  final String toUserId;
  FollowRequestDataEvent({required this.context,
    required this.toUserId, });
}