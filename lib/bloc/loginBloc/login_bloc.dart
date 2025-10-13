import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/models/createPasswordModel.dart';
import 'package:coherent_endurance/models/loginResponse.dart';
import 'package:coherent_endurance/models/sendOtpModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/commonResponse.dart';
import '../../repository/api.dart';


import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<UserLoginEvent>(_login);
    // on<UserRegisterEvent>(_register);
    on<SendOtpEvent>(_sendOtp);
    on<VerifyOtpEvent>(_verifyOtp);
    on<CreatePasswordEvent>(_createPassword);
    on<ForgotPasswordEvent>(_forgotPassword);
    on<GoogleLoginEvent>(_loginWithGoogle);
    // on<FacebookLoginEvent>(_loginWithFacebook);
    // on<PasswordResetEvent>(_resetPassword);
    // on<ChangePasswordResetEvent>(_changePassword);
  }

  Future<void> _login(UserLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try{

      var body = {
        'Email': event.email,
        'Password': event.password,
        'FCMToken': event.fcmToken,
        'DeviceId': event.deviceId,
        'DeviceType': event.deviceType,
      };
      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.postApi(ApiEndPoint.login, body, headers, event.context);
      final result = LoginResponse.fromJson(response);

      if(result.statusCode == 200){
        emit(LoginSuccess(result));
      }else{
        emit(LoginError(result.message.toString()));
      }
    }on SocketException{
      emit(LoginError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(LoginError(e.toString()));
    }
  }

  // Future<void> _loginWithGoogle(GoogleLoginEvent event, Emitter<LoginState> emit) async {
  //   emit(GoogleLoading());
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   final GoogleSignIn _googleSignIn = GoogleSignIn();
  //   try{
  //
  //
  //     final googleUser = await _googleSignIn.signIn();
  //
  //     if (googleUser == null) return null;
  //
  //     final googleAuth = await googleUser.authentication;
  //
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     final userCredential = await _auth.signInWithCredential(credential);
  //
  //     var user = userCredential.user;
  //     if (user != null) {
  //       // Save user info locally
  //       final SharedPreferences pref = await SharedPreferences.getInstance();
  //       var fcmToken = pref.getString(PrefKey.fcmToken);
  //       pref.setString('first_name', user.displayName ?? '');
  //       pref.setString('email', user.email ?? '');
  //       pref.setString('image', user.photoURL ?? '');
  //       pref.setBool('login', true);
  //
  //       // Call your API
  //       await Api.socialLoginApi(
  //         socialMediaid: user.uid,
  //           socialMediaType: 'google',
  //           name: user.displayName.toString(),
  //           email: user.email.toString(),
  //           fcm_token: fcmToken.toString(),
  //           device_id: event.deviceId,
  //           device_type: event.deviceType,
  //           context: event.context
  //       ).then((response) async {
  //         if (response['status'] == true) {
  //           final data = response['data'];
  //           final accessToken = data['access_token'];
  //           final refreshToken = data['refresh_token'];
  //
  //           final SharedPreferences pref = await SharedPreferences.getInstance();
  //           pref.setString(PrefKey.accessToken, accessToken.toString());
  //           pref.setString(PrefKey.refreshToken, refreshToken.toString());
  //           pref.setBool(PrefKey.isLogin, true);
  //
  //           // Navigator.pushReplacementNamed(event.context, '/home');
  //
  //           emit(GoogleSuccess(userCredential.user));
  //         } else {
  //           ScaffoldMessenger.of(event.context).showSnackBar(
  //             SnackBar(content: Text(response['message'] ?? 'Login failed')),
  //           );
  //           emit(GoogleError(response['message']));
  //         }
  //       });
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

  Future<void> _loginWithGoogle(GoogleLoginEvent event, Emitter<LoginState> emit) async {
    emit(GoogleLoading());
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      // ✅ पहले से login हुआ है तो logout करा दो ताकि हर बार account dialog दिखे
      await _googleSignIn.signOut();

      // ✅ अब नया sign-in dialog खुलेगा
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        emit(GoogleError("Login cancelled by user"));
        return;
      }
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final SharedPreferences pref = await SharedPreferences.getInstance();
        final fcmToken = pref.getString(PrefKey.fcmToken) ?? "";


        var headers = {
          'Content-Type': 'application/json',
        };
        var body = {
          'social_media_type': 'google',
          'social_media_id': user.uid,
          'email': user.email ?? '',
          'name': user.displayName ?? '',
          'device_type': event.deviceType,
          'device_id': event.deviceId,
          'fcm_token': fcmToken,
        };

        final response = await Api.postApi(ApiEndPoint.socialLogin, body, headers, event.context);
        // final result = LoginResponse.fromJson(response);

        if (response != null && response['status'] == true) {
          final data = response['data'] ?? {};
          final accessToken = data['access_token'] ?? '';
          final refreshToken = data['refresh_token'] ?? '';

          pref.setString(PrefKey.accessToken, accessToken);
          pref.setString(PrefKey.refreshToken, refreshToken);
          pref.setBool(PrefKey.isLogin, true);
          emit(GoogleSuccess(user));
        }else{
            ScaffoldMessenger.of(event.context).showSnackBar(
              SnackBar(content: Text(response?['message'] ?? 'Login failed')),
            );
            emit(GoogleError(response?['message'] ?? 'Unknown error'));
        }
      }
    } on SocketException {
      emit(LoginError('Please check your internet connection'));
    } catch (e, stacktrace) {
      if (kDebugMode) print('Google login error: $e\n$stacktrace');
      emit(LoginError(e.toString()));
    }
  }


  // Future<void> _loginWithFacebook(FacebookLoginEvent event, Emitter<LoginState> emit) async {
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

  Future<void> _forgotPassword(ForgotPasswordEvent event, Emitter<LoginState> emit) async {
    emit(ForgotPasswordLoading());
    try{

      var body = {
        'Email': event.email,
      };
      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.postApi(ApiEndPoint.forgotPassword, body, headers, event.context);
      final result = SendOtpModel.fromJson(response);

      if(result.statusCode == 200){
        emit(ForgotPasswordSuccess(result));
      }else{
        emit(ForgotPasswordError(result.message.toString()));
      }
    }on SocketException{
      emit(ForgotPasswordError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(ForgotPasswordError(e.toString()));
    }
  }

  Future<void> _sendOtp(SendOtpEvent event, Emitter<LoginState> emit) async {
    emit(SendOtpLoading());
    try{

      var body = {
        'email': event.email,
      };
      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.postApi(ApiEndPoint.sendOtp, body, headers, event.context);
      final result = SendOtpModel.fromJson(response);
      if (kDebugMode) {
        print('_sendOtp:::$result');
      }
      if(result.statusCode == 200){
        emit(SendOtpSuccess(result));
      }else{
        emit(SendOtpError(result.message.toString()));
      }
    }on SocketException{
      emit(SendOtpError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(SendOtpError(e.toString()));
    }
  }

  Future<void> _verifyOtp(VerifyOtpEvent event, Emitter<LoginState> emit,) async {
    emit(VerifyOtpLoading());

    try {
      var body = {
        "email": event.email,
        "otp": event.otp,
        "device_id": event.deviceId,
        "fcm_token": event.fcmToken,
        "device_type": event.deviceType,
      };

      final headers = {'Content-Type': 'application/json'};

      final response = await Api.postApi(
        ApiEndPoint.verifyOtp,
        body,
        headers,
        event.context,
      );

      print("VERIFY OTP RAW RESPONSE: $response");

      Map<String, dynamic> decoded = {};

      if (response == null) {

        emit(VerifyOtpError("Otp is Required"));
        return;
      } else if (response is String) {
        decoded = jsonDecode(response);
      } else if (response is Map<String, dynamic>) {
        decoded = response;
      } else {
        emit(VerifyOtpError("Unexpected response format"));
        return;
      }

      print("DECODED RESPONSE: $decoded");

      // 🔹 Validation error (OTP missing)
      if (decoded.containsKey("errors") || decoded['status'] == 400) {
        final otpError = decoded["errors"]?["otp"]?.join(", ");
        emit(VerifyOtpError(otpError ?? decoded["title"] ?? "Validation error"));
        return;
      }

      // 🔹 Normal success response
      final result = LoginResponse.fromJson(decoded);

      if (result.statusCode == 200 || result.status == true) {
        emit(VerifyOtpSuccess(result));
      } else {
        emit(VerifyOtpError(
          result.errorMessage ?? result.message ?? "Something went wrong",
        ));
      }
    } on SocketException {
      emit(VerifyOtpError("Please check your internet connection"));
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print("VERIFY OTP STACKTRACE: $stacktrace");
      }
      emit(VerifyOtpError("Failed: $e"));
    }
  }

  Future<void> _createPassword(CreatePasswordEvent event, Emitter<LoginState> emit) async {
    emit(CreatePasswordLoading());
    try{

      var body = {
        'email': event.email,
        'password': event.password,
        'confirm_password': event.confirmPassword,
      };
      final headers = {
        'Content-Type': 'application/json'
      };
      final response = await Api.postApi(ApiEndPoint.createPassword, body, headers, event.context);
      final result = CreatePasswordModel.fromJson(response);
      if (kDebugMode) {
        print('_changePassword:::$result');
      }
      if(result.statusCode == 200){
        emit(CreatePasswordSuccess(result));
      }else{
        emit(CreatePasswordError(result.message.toString()));
      }
    }on SocketException{
      emit(CreatePasswordError('Please check your internet connection'));
    }catch(e, stacktrace){
      if (kDebugMode) {
        print(stacktrace);
      }
      emit(CreatePasswordError(e.toString()));
    }
  }
}
