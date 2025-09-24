import 'dart:convert';
import 'dart:io';

import 'package:coherent_endurance/ui/authScreens/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'dart:typed_data';

import '../models/refreshTokenModel.dart';
import '../ui/authScreens/loginScreen.dart';


class Api {
  static const String BaseUrl = "https://tracking.coherentlab.com";
  //static const String BaseUrl = "https://great11.com";

  static getHeader() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Constant.access_token = pref.getString(PrefKey.accessToken);
    final headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer ${Constant.access_token}'
    };

    return headers;
  }

  static getAuthorisationHeader(){
    return 'Bearer ${Constant.access_token}';
  }

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

  // static Future saveActivityApi(Map<String, dynamic> body, BuildContext context,) async {
  //   try {
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(BaseUrl + '/api/v1/activity/save'), // तुम्हारा endpoint
  //     );
  //
  //     // headers
  //     request.headers['authorization'] = 'Bearer ${Constant.access_token}';
  //     request.headers['Content-Type'] = 'multipart/form-data';
  //
  //     // अगर mapImage है तो MultipartFile में add करो
  //     if (body['mapImage'] != null && body['mapImage'] is Uint8List) {
  //       request.files.add(await http.MultipartFile.fromBytes(
  //         'mapImage',
  //         body['mapImage'],
  //         filename: "tracking_map.png",
  //         contentType: MediaType('image', 'png'),
  //       ));
  //     }
  //
  //
  //     // if (body['mapImage'] != null && body['mapImage'] ) {
  //     //   request.files.add(http.MultipartFile.fromBytes(
  //     //     'mapImage',
  //     //     body['mapImage'],
  //     //     filename: "tracking_map.png",
  //     //     contentType: MediaType('image', 'png'),
  //     //   ));
  //     // }
  //
  //     // बाकी normal fields add करो
  //     body.forEach((key, value) {
  //       if (key != 'mapImage') {
  //         if (value is List || value is Map) {
  //           // JSON stringify for objects/arrays
  //           request.fields[key] = jsonEncode(value);
  //         } else {
  //           request.fields[key] = value.toString();
  //         }
  //       }
  //     });
  //
  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);
  //
  //     if (response.statusCode == 200) {
  //       final jsonString = jsonDecode(response.body);
  //       print('saveActivityApi::::$jsonString');
  //       return jsonString;
  //     } else if (response.statusCode == 401) {
  //       // Token expired, try refreshing
  //       bool success = await _refreshToken(context);
  //       if (success) {
  //         return saveActivityApi(body, context); // Retry
  //       } else {
  //         return null;
  //       }
  //     } else {
  //       print("Error saveActivityApi: ${response.statusCode}, Response: ${response.body}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error saveActivityApi: $e');
  //     return null;
  //   }
  // }
  static Future saveActivityApi(
      Map<String, dynamic> body, BuildContext context) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(BaseUrl + '/api/v1/activity/save'),
      );

      // headers
      request.headers['authorization'] = 'Bearer ${Constant.access_token}';
      // Content-Type automatically set by MultipartRequest

      // ✅ Handle mapImage / Base64 / Uint8List
      if (body['photo'] != null) {
        Uint8List imageBytes;

        if (body['photo'] is String) {
          // If it's Base64 string
          imageBytes = base64Decode(body['photo']);
        } else if (body['photo'] is Uint8List) {
          imageBytes = body['photo'];
        } else {
          imageBytes = Uint8List(0);
        }

        request.files.add(await http.MultipartFile.fromBytes(
          'photo', // API expects "photo"
          imageBytes,
          filename: "tracking_map.png",
          contentType: MediaType('image', 'png'),
        ));
      }

      // Add other fields
      body.forEach((key, value) {
        if (key != 'photo') {
          if (value is List || value is Map) {
            request.fields[key] = jsonEncode(value);
          } else {
            request.fields[key] = value.toString();
          }
        }
      });

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonString = jsonDecode(response.body);
        print('saveActivityApi::::$jsonString');
        return jsonString;
      } else if (response.statusCode == 401) {
        // Token expired, try refreshing
        bool success = await _refreshToken(context);
        if (success) {
          return saveActivityApi(body, context); // Retry
        } else {
          return null;
        }
      } else {
        print(
            "Error saveActivityApi: ${response.statusCode}, Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print('Error saveActivityApi: $e');
      return null;
    }
  }

  static Future updateProfileApi(String endPoint, Map<String, dynamic> body, Map<String, String> header, BuildContext context) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(BaseUrl + endPoint));

      // headers (authorization वगैरह)
      request.headers.addAll(header);

      // अगर profile_pic file है तो MultipartFile में add करो
      if (body['profile_pic'] != null && body['profile_pic'].toString().isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_pic',
          body['profile_pic'], // यहां file path pass करो
        ));
      }

      // बाकी normal fields add करना
      body.forEach((key, value) {
        if (key != 'profile_pic') {
          request.fields[key] = value?.toString() ?? '';
        }
      });

      // request भेजना
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonString = jsonDecode(response.body);
        print('${endPoint}::::$jsonString');
        return jsonString;
      } else if (response.statusCode == 401) {
        // Token expired, try refreshing the token
        bool success = await _refreshToken(context);
        if (success) {
          header['authorization'] = 'Bearer ${Constant.access_token}';
          return updateProfileApi(endPoint, body, header, context); // Retry request
        } else {
          return null;
        }
      } else {
        print("Error: ${response.statusCode}, Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print('error api $endPoint $e');
      return null;
    }
  }

  static Future postApiWithQuery(String endPoint, var queryParameters, var header, BuildContext context) async {
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
      Uri.parse(BaseUrl + ApiEndPoint.refreshToken), headers: header, body: jsonEncode(body),
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
          MaterialPageRoute(builder: (context) => RegisterScreen()),
          (route) => false,
        );

        return false;
      } else {
        print("Response: ${response.statusCode}, Response: ${response.body}");
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

class ApiEndPoint {

  static const String login = '/api/v1/auth/login';
  static const String refreshToken = '/api/v1/auth/referesh-token';
  static const String sendOtp = '/api/v1/auth/send-otp';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String createPassword = '/api/v1/auth/create-password';
  static const String getProfile = '/api/v1/get-profile';
  static const String getCategory = '/api/v1/category';
  static const String updateProfile = '/api/v1/update-profile';
  static const String getFeed = '/api/v1/activity/feed';
  static const String getMyFeed = '/api/v1/activity/my-feed';
  static const String activityLike = '/api/v1/activity/like';
  static const String userFind = '/api/v1/user/find';
  static const String postAllChallenges = '/api/v1/challenges/all';
  static const String getRecommendedChallenges = '/api/v1/challenges/recommended';

}
