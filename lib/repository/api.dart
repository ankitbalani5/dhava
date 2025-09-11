import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coherent_endurance/constant/constant.dart';

import '../models/refreshTokenModel.dart';
import '../ui/authScreens/loginScreen.dart';


class Api {
  static const String BaseUrl = "https://tigers11.in";
  //static const String BaseUrl = "https://great11.com";

  static Future getApi(String endPoint, var header, BuildContext context) async {
    final response = await http.get(Uri.parse(BaseUrl + endPoint), headers: header);

    try {
      if (response.statusCode == 200) {
        final jsonString = jsonDecode(response.body);
        print('${endPoint}::::$jsonString');
        return jsonString;
      } else if (response.statusCode == 401) {
        // Token expired, try refreshing the token
        bool success = await _refreshToken(context);
        if (success) {
          header['authorization'] = 'Bearer ${Constant.access_token}';
          return getApi(endPoint, header, context); // Retry the request
        } else {
          return null;
        }
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        return null;
      }
    } catch (e, stacktrace) {
      print('$endPoint:::${stacktrace}');
      print('error api $endPoint $e');
    }
  }

  static Future getApiWithQuery(String endPoint, var queryParameters,
      var header, BuildContext context) async {
    final response = await http.get(
      Uri.parse(BaseUrl + endPoint).replace(queryParameters: queryParameters),
      headers: header,
    );

    try {
      if (response.statusCode == 200) {
        final jsonString = jsonDecode(response.body);
        print('${endPoint}::::$jsonString');
        return jsonString;
      } else if (response.statusCode == 401) {
        // Token expired, try refreshing the token
        bool success = await _refreshToken(context);
        if (success) {
          header['authorization'] = 'Bearer ${Constant.access_token}';
          return getApi(endPoint, header, context); // Retry the request
        } else {
          return null;
        }
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print('error api $endPoint $e');
    }
  }

  static Future postApi(String endPoint, var body, var header, BuildContext context) async {
    final response = await http.post(Uri.parse(BaseUrl + endPoint), headers: header, body: jsonEncode(body));

    try {
      if (response.statusCode == 200) {
        final jsonString = jsonDecode(response.body);
        print('${endPoint}::::$jsonString');
        return jsonString;
      } else if (response.statusCode == 401) {
        // Token expired, try refreshing the token
        bool success = await _refreshToken(context);
        if (success) {
          header['authorization'] = 'Bearer ${Constant.access_token}';
          return postApi(endPoint, body, header, context); // Retry the request
        } else {
          return null;
        }
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print('error api $endPoint $e');
    }
  }

  static Future postApiWithQuery(String endPoint, var queryParameters,
      var header, BuildContext context) async {
    final response = await http.post(
      Uri.parse(BaseUrl + endPoint).replace(queryParameters: queryParameters),
      headers: header,
    );

    try {
      if (response.statusCode == 200) {
        final jsonString = jsonDecode(response.body);
        print('${endPoint}::::$jsonString');
        return jsonString;
      } else if (response.statusCode == 401) {
        // Token expired, try refreshing the token
        bool success = await _refreshToken(context);
        if (success) {
          header['authorization'] = 'Bearer ${Constant.access_token}';
          return postApiWithQuery(
              endPoint, queryParameters, header, context); // Retry the request
        } else {
          return null;
        }
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print('error api $endPoint $e');
    }
  }

  static Future socialLoginApi({required String socailite_type, required String socailite_id, required String first_name, required String email, required String fcm_token}) async {
    var token = Constant.token;
    var fcmToken = Constant.fcmToken;
    final response = await http.post(Uri.parse('${BaseUrl}socailite-login'),
        headers: {
          'authorization': 'Bearer $token'
        },
        body: {
          'socailite_type': socailite_type,
          'socailite_id': socailite_id,
          'first_name': first_name,
          'email': email,
          'fcm_token': fcmToken,
        }
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return jsonString;
      } catch (e, stacktrace) {
        print('Error parsing JSON socialLoginApi: $e');
        print('Error stack: $stacktrace');
        throw HttpException('Failed to parse cart data.');
      }
    } else {
      print('Request failed with status socialLoginApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      // Throw an exception with a meaningful message
      throw HttpException(
          'Failed to load data');
    }

  }

  /// Refresh Token API Call
  static Future<bool> _refreshToken(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString(PrefKey.accessToken);
    String? refreshToken = pref.getString(PrefKey.refreshToken);

    if (refreshToken == null) {
      print("No refresh token available.");
      return false;
    }

    var body = {'access_token': accessToken, 'refresh_token': refreshToken};
    var header = {'Content-Type': 'application/json'};

    final response = await http.post(
      Uri.parse(BaseUrl + EndPoint.refreshToken),
      headers: header,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      final result = RefreshTokenModel.fromJson(jsonResponse);
      if (result.statusCode == 401) {
        pref.clear();
        Constant.access_token = '';
        Constant.refresh_token = '';
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );

        return false;
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
      }
      String newAccessToken = result.data!.accessToken.toString();
      String newRefreshToken = result.data!.refreshToken.toString();

      // Save new tokens
      await pref.setString(PrefKey.accessToken, newAccessToken);
      await pref.setString(PrefKey.refreshToken, newRefreshToken);

      // Update the access token in constant
      Constant.access_token = newAccessToken;
      Constant.refresh_token = newRefreshToken;
      print('accessToken::::${Constant.access_token}');
      print('refreshToken::::${Constant.refresh_token}');

      print("Token refreshed successfully.");
      return true;
    } else {
      print("Failed to refresh token.");
      return false;
    }
  }


  // static Future multiPartApi(
  //     File? image, String endPoint, BuildContext context) async {
  //   if (image == null || !(await image.exists())) {
  //     print("Image file is null or does not exist!");
  //     return null;
  //   }
  //
  //   final request =
  //       http.MultipartRequest('POST', Uri.parse(BaseUrl + endPoint));
  //   request.headers['authorization'] = 'Bearer ${Constant.access_token}';
  //
  //   // Convert to ByteStream
  //   var stream = http.ByteStream(image.openRead());
  //   var length = await image.length();
  //   print("Uploading file: ${image.path}, Size: $length bytes");
  //
  //   var multipartFile = http.MultipartFile(
  //     'profile_pic_file',
  //     stream,
  //     length,
  //     filename: image.path.split('/').last,
  //     contentType: MediaType('image', 'jpeg'),
  //   );
  //   request.files.add(multipartFile);
  //
  //   var response = await request.send();
  //
  //   print("Response Status: ${response.statusCode}");
  //   var responseBody = await response.stream.bytesToString();
  //   print("Response Body: $responseBody");
  //
  //   if (response.statusCode == 200) {
  //     try {
  //       final jsonString = jsonDecode(responseBody);
  //       return UpdateProfilePicModel.fromJson(jsonString);
  //     } catch (e) {
  //       print('Error parsing JSON: $e');
  //       return null;
  //     }
  //   } else if (response.statusCode == 401) {
  //     bool success = await _refreshToken(context);
  //     if (success) {
  //       return multiPartApi(image, endPoint, context);
  //     } else {
  //       print("Token refresh failed. Cannot retry.");
  //       return null;
  //     }
  //   } else {
  //     return null;
  //   }
  // }


}

class EndPoint {

  static const String refreshToken = '/api/v1/auth/referesh-token';
}
