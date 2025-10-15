part of 'my_feed_bloc.dart';

@immutable
sealed class MyFeedEvent {}

class GetMyFeedEvent extends MyFeedEvent{
  final BuildContext context;
  final String perPage;
  final String page;
  final String categoryId;
  final String userId;
  final bool isPagination;
  GetMyFeedEvent({required this.context, required this.perPage, required this.page, required this.categoryId,required this.userId, this.isPagination = false});
}

class MyFeedLikeEvent extends MyFeedEvent{
  final BuildContext context;
  final String activityId;
  MyFeedLikeEvent({required this.context, required this.activityId});
}