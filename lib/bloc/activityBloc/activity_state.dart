part of 'activity_bloc.dart';

@immutable
sealed class ActivityState {}

final class ActivityInitial extends ActivityState {}
final class FeedLoading extends ActivityState {}
final class FeedSuccess extends ActivityState {
  final feed.FeedModel feedModel;
  FeedSuccess(this.feedModel);
}
final class FeedError extends ActivityState {
  final String error;
  FeedError(this.error);
}
final class LikeFeedLoading extends ActivityState {}
final class LikeFeedSuccess extends ActivityState {
  final ActivityLikeModel activityLikeModel;
  LikeFeedSuccess(this.activityLikeModel);
}
final class LikeFeedError extends ActivityState {
  final String error;
  LikeFeedError(this.error);
}

final class MyFeedLoading extends ActivityState {}
final class MyFeedSuccess extends ActivityState {
  final feed.FeedModel feedModel;
  MyFeedSuccess(this.feedModel);
}
final class MyFeedError extends ActivityState {
  final String error;
  MyFeedError(this.error);
}
