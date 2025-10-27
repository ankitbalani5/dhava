part of 'news_detail_bloc.dart';

@immutable
sealed class NewsDetailEvent {}

class FetchNewsDetailEvent extends NewsDetailEvent{
  final BuildContext context;
  final String newsId;
  FetchNewsDetailEvent({required this.context, required this.newsId});
}