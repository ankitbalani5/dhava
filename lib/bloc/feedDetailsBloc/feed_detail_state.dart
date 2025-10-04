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
