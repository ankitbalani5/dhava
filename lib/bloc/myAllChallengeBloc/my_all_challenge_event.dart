part of 'my_all_challenge_bloc.dart';

@immutable
abstract class ChallengeEvent{}
class MyAllChallengeEvent extends ChallengeEvent {
  final BuildContext context;
  final String page;
  final String perPage;
  final String categoryId;
  final String userId;
  final bool isPagination;
  MyAllChallengeEvent({required this.context, required this.page,
    required this.perPage, required this.categoryId, required this.userId, this.isPagination = false});
}
class UserAllChallengeEvent extends ChallengeEvent{
  final BuildContext context;
  final String page;
  final String perPage;
  final String categoryId;
  final String userId;
  final bool isPagination;
  UserAllChallengeEvent({required this.context, required this.page,
    required this.perPage, required this.categoryId, required this.userId, this.isPagination = false});
}
