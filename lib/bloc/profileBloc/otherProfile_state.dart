
import 'package:coherent_endurance/models/followRequestModel.dart';
import 'package:coherent_endurance/models/otherProfileModel.dart';

import 'package:flutter/cupertino.dart';

@immutable
sealed class OtherProfileState {}

final class OtherProfileInitial extends OtherProfileState {}
final class OtherProfileLoading extends OtherProfileState {}
final class OtherProfileSuccess extends OtherProfileState {
  final OtherProfileModel otherProfileModel;
  OtherProfileSuccess(this.otherProfileModel);
}
final class OtherProfileError extends OtherProfileState {
  final String error;
  OtherProfileError(this.error);
}








