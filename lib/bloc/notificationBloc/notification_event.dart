part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class GetNotificationEvent extends NotificationEvent{
  final BuildContext context;
  final String perPage;
  final String page;
  GetNotificationEvent({required this.context, required this.perPage, required this.page});
}

class FollowApproveEvent extends NotificationEvent{
  final BuildContext context;
  final String fromUserId;
  FollowApproveEvent({required this.context, required this.fromUserId});
}

class FollowCancelEvent extends NotificationEvent{
  final BuildContext context;
  final String fromUserId;
  FollowCancelEvent({required this.context, required this.fromUserId});
}
