
import 'package:flutter/cupertino.dart';

@immutable
sealed class SuggestionEvent {}

class GetSuggestionEvent extends SuggestionEvent{
  final BuildContext context;
  final String perPage;
  final String page;
  final bool isPagination;
  GetSuggestionEvent({required this.context, required this.perPage, required this.page, this.isPagination = false});
}

class UnfollowRequestEvent extends SuggestionEvent{
  final BuildContext context;
  final String to_user_id ;
  UnfollowRequestEvent({required this.context, required this.to_user_id,});
}
