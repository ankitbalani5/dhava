

import 'package:coherent_endurance/models/followRequestModel.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class FollowRequestState {}

final class FollowRequestInitial extends FollowRequestState {}
final class FollowRequestLoading extends FollowRequestState {}
final class FollowRequestSuccess extends FollowRequestState {
  final FollowRequestModel followRequestModel;
  FollowRequestSuccess(this.followRequestModel);
}
final class FollowRequestError extends FollowRequestState {
  final String error;
  FollowRequestError(this.error);
}