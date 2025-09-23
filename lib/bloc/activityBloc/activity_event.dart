part of 'activity_bloc.dart';

@immutable
sealed class ActivityEvent {}

class GetFeedEvent extends ActivityEvent{
  final BuildContext context;
  final String perPage;
  final String page;
  final dynamic categoryId;
  final bool isPagination;
  GetFeedEvent({required this.context,
    required this.perPage, required this.page,
    required this.categoryId, this.isPagination = false});
}

class ActivityLikeEvent extends ActivityEvent{
  final BuildContext context;
  final String activityId;
  ActivityLikeEvent({required this.context, required this.activityId});
}

class GetMyFeedEvent extends ActivityEvent{
  final BuildContext context;
  final String perPage;
  final String page;
  final String categoryId;
  final dynamic userId;
  final bool isPagination;
  GetMyFeedEvent({required this.context, required this.perPage, required this.page, required this.categoryId, this.userId, this.isPagination = false});
}
