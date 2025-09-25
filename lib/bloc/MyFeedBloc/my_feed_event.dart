part of 'my_feed_bloc.dart';

@immutable
sealed class MyFeedEvent {}

class GetMyFeedEvent extends MyFeedEvent{
  final BuildContext context;
  final String perPage;
  final String page;
  final String categoryId;
  final dynamic userId;
  final bool isPagination;
  GetMyFeedEvent({required this.context, required this.perPage, required this.page, required this.categoryId, this.userId, this.isPagination = false});
}