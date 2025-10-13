part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}
final class LoginLoading extends LoginState {}
final class SendOtpLoading extends LoginState {}
final class VerifyOtpLoading extends LoginState {}
final class ForgotPasswordLoading extends LoginState {}
final class CreatePasswordLoading extends LoginState {}
final class LoginSuccess extends LoginState {
  final LoginResponse loginModel;
  LoginSuccess(this.loginModel);
}
final class GoogleLoading extends LoginState{}
final class GoogleSuccess extends LoginState{
  final User? user;
  GoogleSuccess(this.user);
}
final class GoogleError extends LoginState{
  final String error;
  GoogleError(this.error);
}
final class ForgotPasswordSuccess extends LoginState {
  final SendOtpModel sendOtpModel;
  ForgotPasswordSuccess(this.sendOtpModel);
}
// final class RegisterSuccess extends LoginState {
//   final LoginResponse loginModel;
//   RegisterSuccess(this.loginModel);
// }
// final class ResetPasswordSuccess extends LoginState {
//   final CommonResponseModel commonResponseModel;
//   ResetPasswordSuccess(this.commonResponseModel);
// }
final class SendOtpSuccess extends LoginState {
  final SendOtpModel sendOtpModel;
  SendOtpSuccess(this.sendOtpModel);
}
final class VerifyOtpSuccess extends LoginState {
  final LoginResponse loginResponse;
  VerifyOtpSuccess(this.loginResponse);
}
final class CreatePasswordSuccess extends LoginState {
  final CreatePasswordModel createPasswordModel;
  CreatePasswordSuccess(this.createPasswordModel);
}
// final class ChangePasswordSuccess extends LoginState {
//   final CommonResponseModel commonResponseModel;
//   ChangePasswordSuccess(this.commonResponseModel);
// }
final class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}
final class ForgotPasswordError extends LoginState {
  final String error;
  ForgotPasswordError(this.error);
}
final class SendOtpError extends LoginState {
  final String error;
  SendOtpError(this.error);
}
final class VerifyOtpError extends LoginState {
  final String error;
  VerifyOtpError(this.error);
}
final class CreatePasswordError extends LoginState {
  final String error;
  CreatePasswordError(this.error);
}
