part of 'my_feed_bloc.dart';

@immutable
sealed class MyFeedState {}

final class MyFeedInitial extends MyFeedState {}

final class MyFeedLoading extends MyFeedState {}
final class MyFeedSuccess extends MyFeedState {
  final MyFeedModel feedModel;
  MyFeedSuccess(this.feedModel);
}
final class MyFeedError extends MyFeedState {
  final String error;
  MyFeedError(this.error);
}