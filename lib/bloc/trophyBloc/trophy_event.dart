part of 'trophy_bloc.dart';

@immutable
sealed class TrophyEvent {}

class MyTrophyEvent extends TrophyEvent{
  final BuildContext context;
  final String page;
  final String perPage;
  final String categoryId;
  MyTrophyEvent({required this.context, required this.page, required this.perPage, required this.categoryId});
}