import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';



part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    // on<UserLoginEvent>(_login);
    // on<UserRegisterEvent>(_register);
    // on<SendOtpEvent>(_sendOtp);
    // on<VerifyOtpEvent>(_verifyOtp);
    // on<PasswordResetEvent>(_resetPassword);
    // on<ChangePasswordResetEvent>(_changePassword);
  }

  // Future<void> _login(UserLoginEvent event, Emitter<LoginState> emit) async {
  //   emit(LoginLoading());
  //   try{
  //
  //     var body = {
  //       'Email': event.email,
  //       'Password': event.password,
  //       'FCMToken': event.fcmToken,
  //       'DeviceId': event.deviceId,
  //       'DeviceType': event.deviceType,
  //     };
  //     final headers = {
  //       'Content-Type': 'application/json'
  //     };
  //     final response = await Api.postApi(ApiEndPoint.login, body, headers, event.context);
  //     final result = LoginResponse.fromJson(response);
  //
  //     if(result.statusCode == 200){
  //       emit(LoginSuccess(result));
  //     }else{
  //       emit(LoginError(result.message.toString()));
  //     }
  //   }on SocketException{
  //     emit(LoginError('Please check your internet connection'));
  //   }catch(e, stacktrace){
  //     if (kDebugMode) {
  //       print(stacktrace);
  //     }
  //     emit(LoginError(e.toString()));
  //   }
  // }
  //
  // Future<void> _register(UserRegisterEvent event, Emitter<LoginState> emit) async {
  //   emit(LoginLoading());
  //   try{
  //     var body = {
  //       'Email': event.email,
  //       'Password': event.password,
  //       'RoleID': event.roleId,
  //       'Uuid': event.uuid,
  //       'UserType': event.userType,
  //       'FCMToken': event.fcmToken,
  //       'DeviceId': event.deviceId,
  //       'DeviceType': event.deviceType,
  //     };
  //     final headers = {
  //       'Content-Type': 'application/json'
  //     };
  //     final response = await Api.postApi(ApiEndPoint.register, body, headers, event.context);
  //     final result = LoginResponse.fromJson(response);
  //     if (kDebugMode) {
  //       print('_register:::$result');
  //     }
  //     if(result.statusCode == 200){
  //       emit(RegisterSuccess(result));
  //     }else{
  //       emit(LoginError(result.message.toString()));
  //     }
  //   }on SocketException{
  //     emit(LoginError('Please check your internet connection'));
  //   }catch(e, stacktrace){
  //     if (kDebugMode) {
  //       print(stacktrace);
  //     }
  //     emit(LoginError(e.toString()));
  //   }
  // }
  //
  // Future<void> _sendOtp(SendOtpEvent event, Emitter<LoginState> emit) async {
  //   emit(LoginLoading());
  //   try{
  //
  //     var body = {
  //       'phoneNumber': event.phoneNumber,
  //     };
  //     final headers = {
  //       'Content-Type': 'application/json'
  //     };
  //     final response = await Api.postApi(ApiEndPoint.sendOtp, body, headers, event.context);
  //     final result = CommonResponseModel.fromJson(response);
  //     if (kDebugMode) {
  //       print('_sendOtp:::$result');
  //     }
  //     if(result.statusCode == 200){
  //       emit(SendOtpSuccess(result));
  //     }else{
  //       emit(SendOtpError(result.message.toString()));
  //     }
  //   }on SocketException{
  //     emit(SendOtpError('Please check your internet connection'));
  //   }catch(e, stacktrace){
  //     if (kDebugMode) {
  //       print(stacktrace);
  //     }
  //     emit(SendOtpError(e.toString()));
  //   }
  // }
  //
  // Future<void> _verifyOtp(VerifyOtpEvent event, Emitter<LoginState> emit) async {
  //   emit(LoginLoading());
  //   try{
  //
  //     var body = {
  //       'otp': event.otp,
  //     };
  //     final headers = {
  //       'Content-Type': 'application/json'
  //     };
  //     final response = await Api.postApi(ApiEndPoint.sendOtp, body, headers, event.context);
  //     final result = CommonResponseModel.fromJson(response);
  //     if (kDebugMode) {
  //       print('_verifyOtp:::$result');
  //     }
  //     if(result.statusCode == 200){
  //       emit(VerifyOtpSuccess(result));
  //     }else{
  //       emit(VerifyOtpError(result.message.toString()));
  //     }
  //   }on SocketException{
  //     emit(VerifyOtpError('Please check your internet connection'));
  //   }catch(e, stacktrace){
  //     if (kDebugMode) {
  //       print(stacktrace);
  //     }
  //     emit(VerifyOtpError(e.toString()));
  //   }
  // }
  //
  // Future<void> _resetPassword(PasswordResetEvent event, Emitter<LoginState> emit) async {
  //   emit(LoginLoading());
  //   try{
  //
  //     var body = {
  //       'Email': event.email,
  //     };
  //     final headers = {
  //       'Content-Type': 'application/json'
  //     };
  //     final response = await Api.postApi(ApiEndPoint.forgotPassword, body, headers, event.context);
  //     final result = CommonResponseModel.fromJson(response);
  //     if (kDebugMode) {
  //       print('_resetPassword:::$result');
  //     }
  //     if(result.statusCode == 200){
  //       emit(ResetPasswordSuccess(result));
  //     }else{
  //       emit(LoginError(result.message.toString()));
  //     }
  //   }on SocketException{
  //     emit(LoginError('Please check your internet connection'));
  //   }catch(e, stacktrace){
  //     if (kDebugMode) {
  //       print(stacktrace);
  //     }
  //     emit(LoginError(e.toString()));
  //   }
  // }
  //
  // Future<void> _changePassword(ChangePasswordResetEvent event, Emitter<LoginState> emit) async {
  //   emit(LoginLoading());
  //   try{
  //
  //     var body = {
  //       'OldPassword': event.currentPassword,
  //       'NewPassword': event.newPassword,
  //       'ConfirmPassword': event.confirmPassword,
  //       'token': event.securityCode,
  //     };
  //     final headers = {
  //       'Content-Type': 'application/json'
  //     };
  //     final response = await Api.postApi(ApiEndPoint.changePassword, body, headers, event.context);
  //     final result = CommonResponseModel.fromJson(response);
  //     if (kDebugMode) {
  //       print('_changePassword:::$result');
  //     }
  //     if(result.statusCode == 200){
  //       emit(ChangePasswordSuccess(result));
  //     }else{
  //       emit(LoginError(result.message.toString()));
  //     }
  //   }on SocketException{
  //     emit(LoginError('Please check your internet connection'));
  //   }catch(e, stacktrace){
  //     if (kDebugMode) {
  //       print(stacktrace);
  //     }
  //     emit(LoginError(e.toString()));
  //   }
  // }
}
