part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}
final class LoginLoading extends LoginState {}
final class SendOtpLoading extends LoginState {}
final class VerifyOtpLoading extends LoginState {}
// final class LoginSuccess extends LoginState {
//   final LoginResponse loginModel;
//   LoginSuccess(this.loginModel);
// }
// final class RegisterSuccess extends LoginState {
//   final LoginResponse loginModel;
//   RegisterSuccess(this.loginModel);
// }
// final class ResetPasswordSuccess extends LoginState {
//   final CommonResponseModel commonResponseModel;
//   ResetPasswordSuccess(this.commonResponseModel);
// }
// final class SendOtpSuccess extends LoginState {
//   final CommonResponseModel commonResponseModel;
//   SendOtpSuccess(this.commonResponseModel);
// }
// final class VerifyOtpSuccess extends LoginState {
//   final CommonResponseModel commonResponseModel;
//   VerifyOtpSuccess(this.commonResponseModel);
// }
// final class ChangePasswordSuccess extends LoginState {
//   final CommonResponseModel commonResponseModel;
//   ChangePasswordSuccess(this.commonResponseModel);
// }
final class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}
final class SendOtpError extends LoginState {
  final String error;
  SendOtpError(this.error);
}
final class VerifyOtpError extends LoginState {
  final String error;
  VerifyOtpError(this.error);
}
