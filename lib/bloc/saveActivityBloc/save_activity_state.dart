part of 'save_activity_bloc.dart';

@immutable
sealed class SaveActivityState {}

final class SaveActivityInitial extends SaveActivityState {}
final class SaveActivityLoading extends SaveActivityState {}
final class SaveActivitySuccess extends SaveActivityState {
  final SaveActivityModel saveActivityModel;
  SaveActivitySuccess(this.saveActivityModel);
}
final class SaveActivityError extends SaveActivityState {
  final String error;
  SaveActivityError(this.error);
}
