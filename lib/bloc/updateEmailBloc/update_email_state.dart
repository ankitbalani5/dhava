part of 'update_email_bloc.dart';

@immutable
sealed class UpdateEmailState {}

final class UpdateEmailInitial extends UpdateEmailState {}
final class UpdateEmailLoading extends UpdateEmailState {}
final class UpdateEmailSuccess extends UpdateEmailState {
  final UpdateEmailModel updateEmailModel;
  UpdateEmailSuccess(this.updateEmailModel);
}
final class UpdateEmailError extends UpdateEmailState {
  final String error;
  UpdateEmailError(this.error);
}
