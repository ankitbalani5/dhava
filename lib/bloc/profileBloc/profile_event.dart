part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class GetProfileEvent extends ProfileEvent{
  final BuildContext context;
  final String userId;
  GetProfileEvent(this.context, this.userId);
}


class CategoryEvent extends ProfileEvent{
  final BuildContext context;
  CategoryEvent(this.context);
}

class GetProfileSummary extends ProfileEvent{
  final BuildContext context;
  final String categoryId;
  GetProfileSummary(this.context, this.categoryId);
}