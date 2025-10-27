part of 'news_bloc.dart';

@immutable
sealed class NewsEvent {}

class FetchNewsEvent extends NewsEvent{
  final BuildContext context;
  final String page;
  final String perPage;
  final bool isPagination;
  FetchNewsEvent({required this.context, required this.page, required this.perPage, this.isPagination = false});
}