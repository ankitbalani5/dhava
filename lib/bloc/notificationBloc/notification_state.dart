part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}
final class NotificationLoading extends NotificationState {}
final class NotificationSuccess extends NotificationState {
  final NotificationModel notificationModel;
  NotificationSuccess(this.notificationModel);
}
final class NotificationError extends NotificationState {
  final String error;
  NotificationError(this.error);
}
