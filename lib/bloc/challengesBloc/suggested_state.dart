

import 'package:coherent_endurance/models/postSuggestedModel.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class SuggestedState {}

final class PostSuggestedInitial extends SuggestedState {}
final class PostSuggestedLoading extends SuggestedState {}
final class PostSuggestedSuccess extends SuggestedState {
  final PostSuggestedModel suggestedModel;
  PostSuggestedSuccess(this.suggestedModel);
}
final class PostSuggestedError extends SuggestedState {
  final String error;
  PostSuggestedError(this.error);
}








