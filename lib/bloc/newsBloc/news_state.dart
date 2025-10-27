part of 'news_bloc.dart';

@immutable
sealed class NewsState {}

final class NewsInitial extends NewsState {}
final class NewsLoading extends NewsState {}
final class NewsSuccess extends NewsState {
  final NewsModel newsModel;
  NewsSuccess(this.newsModel);
}
final class NewsError extends NewsState {
  final String error;
  NewsError(this.error);
}
