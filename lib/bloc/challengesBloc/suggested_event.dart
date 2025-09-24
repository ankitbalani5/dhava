

import 'package:flutter/cupertino.dart';

@immutable
sealed class SuggestedEvent {}

class PostSuggestedEvent extends SuggestedEvent{
  final BuildContext context;
  final String perPage;
  final String page;
  final String categoryId;
  final bool isPagination;
  PostSuggestedEvent({required this.context,
    required this.perPage, required this.page,
    required this.categoryId, this.isPagination = false});
}
