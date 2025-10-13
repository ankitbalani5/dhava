part of 'my_all_challenge_bloc.dart';

@immutable
class MyAllChallengeEvent {
  final BuildContext context;
  final String page;
  final String perPage;
  final String categoryId;
  final bool isPagination;
  MyAllChallengeEvent({required this.context, required this.page,
    required this.perPage, required this.categoryId, this.isPagination = false});
}
