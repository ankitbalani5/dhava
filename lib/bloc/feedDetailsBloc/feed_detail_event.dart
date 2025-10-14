part of 'feed_detail_bloc.dart';

@immutable
sealed class FeedDetailEvent {}

class FetchFeedDetailEvent extends FeedDetailEvent{
  final BuildContext context;
  final String activityId;
  FetchFeedDetailEvent(this.context, this.activityId);
}

class ActivityLikeEvent extends FeedDetailEvent{
  final BuildContext context;
  final String activityId;
  ActivityLikeEvent({required this.context , required this.activityId});
}
