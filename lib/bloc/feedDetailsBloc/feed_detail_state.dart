part of 'feed_detail_bloc.dart';

@immutable
sealed class FeedDetailState {}

final class FeedDetailInitial extends FeedDetailState {}
final class FeedDetailLoading extends FeedDetailState {}
final class FeedDetailSuccess extends FeedDetailState {
  final FeedDetailModel feedDetailModel;
  FeedDetailSuccess(this.feedDetailModel);
}
final class FeedDetailError extends FeedDetailState {
  final String error;
  FeedDetailError(this.error);
}
final class LikeFeedLoading extends FeedDetailState {}
final class LikeFeedSuccess extends FeedDetailState {
  final ActivityLikeModel activityLikeModel;
  LikeFeedSuccess(this.activityLikeModel);
}
final class LikeFeedError extends FeedDetailState {
  final String error;
  LikeFeedError(this.error);
}
