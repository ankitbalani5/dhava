part of 'active_challenge_bloc.dart';

@immutable
sealed class ActiveChallengeEvent {}

class FetchActiveChallengeEvent extends ActiveChallengeEvent{
  final BuildContext context;
  final String perPage;
  final String page;
  final String categoryId;
  final bool isPagination;
  FetchActiveChallengeEvent({required this.context,
    required this.perPage, required this.page,
    required this.categoryId, this.isPagination = false});
}