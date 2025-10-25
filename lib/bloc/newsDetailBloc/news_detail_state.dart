part of 'news_detail_bloc.dart';

@immutable
sealed class NewsDetailState {}

final class NewsDetailInitial extends NewsDetailState {}
final class NewsDetailLoading extends NewsDetailState {}
final class NewsDetailSuccess extends NewsDetailState {
  final NewsDetailModel newsDetailModel;
  NewsDetailSuccess(this.newsDetailModel);
}
final class NewsDetailError extends NewsDetailState {
  final String error;
  NewsDetailError(this.error);
}
