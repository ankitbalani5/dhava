
import 'package:coherent_endurance/models/suggestionsModel.dart';
import 'package:coherent_endurance/models/unfollowModel.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class SuggestionState {}

final class SuggestionInitial extends SuggestionState {}
final class SuggestionLoading extends SuggestionState {}
final class SuggestionSuccess extends SuggestionState {
  final SuggestionsModel suggestionModel;
  SuggestionSuccess(this.suggestionModel);
}
final class SuggestionError extends SuggestionState {
  final String error;
  SuggestionError(this.error);
}



final class UnfollowInitial extends SuggestionState {}
final class UnfollowLoading extends SuggestionState {}
final class UnfollowSuccess extends SuggestionState {
  final UnfollowModel unfollowModel;
  UnfollowSuccess(this.unfollowModel);
}
final class UnfollowError extends SuggestionState {
  final String error;
  UnfollowError(this.error);
}