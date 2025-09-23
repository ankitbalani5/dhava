part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class UserLoginEvent extends LoginEvent {
  final BuildContext context;
  final String email;
  final String password;
  final String fcmToken;
  final String deviceId;
  final String deviceType;

  UserLoginEvent({
    required this.context,
    required this.email,
    required this.password,
    required this.fcmToken,
    required this.deviceId,
    required this.deviceType,
  });
}

class ForgotPasswordEvent extends LoginEvent {
  final BuildContext context;
  final String email;

  ForgotPasswordEvent({
    required this.context,
    required this.email,
  });
}

class UserRegisterEvent extends LoginEvent {
  final BuildContext context;
  final String email;
  final String password;
  final String roleId;
  final String uuid;
  final String userType;
  final String fcmToken;
  final String deviceId;
  final String deviceType;

  UserRegisterEvent({
    required this.context,
    required this.email,
    required this.password,
    required this.roleId,
    required this.uuid,
    required this.userType,
    required this.fcmToken,
    required this.deviceId,
    required this.deviceType,
  });
}

class PasswordResetEvent extends LoginEvent {
  final BuildContext context;
  final String email;

  PasswordResetEvent({
    required this.context,
    required this.email,
  });
}

class SendOtpEvent extends LoginEvent {
  final BuildContext context;
  final String email;

  SendOtpEvent({
    required this.context,
    required this.email,
  });
}

class VerifyOtpEvent extends LoginEvent {
  final BuildContext context;
  final String email;
  final String otp;
  final String deviceId;
  final String fcmToken;
  final String deviceType;

  VerifyOtpEvent({
    required this.context,
    required this.email,
    required this.otp,
    required this.deviceId,
    required this.fcmToken,
    required this.deviceType,
  });
}

class CreatePasswordEvent extends LoginEvent {
  final BuildContext context;
  final String email;
  final String password;
  final String confirmPassword;

  CreatePasswordEvent({
    required this.context,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class ChangePasswordResetEvent extends LoginEvent {
  final BuildContext context;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final String securityCode;

  ChangePasswordResetEvent({
    required this.context,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.securityCode,
  });
}
