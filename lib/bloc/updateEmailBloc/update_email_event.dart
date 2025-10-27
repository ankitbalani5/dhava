part of 'update_email_bloc.dart';

@immutable
class UpdateEmailEvent {
  final BuildContext context;
  final String email;
  const UpdateEmailEvent(this.context, this.email);
}
