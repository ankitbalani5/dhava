import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coherent_endurance/constant/constant.dart';
// import '../Google_Analytics/Analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'api.dart';


class SocialAuth{
  var fcmToken;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance/*GoogleSignIn()*/;

  // Future<void> googleLogin(BuildContext context) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   fcmToken = pref.getString('fcmToken');
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //     await googleSignIn.signIn();
  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  //       final AuthCredential authCredential = GoogleAuthProvider.credential(
  //           idToken: googleSignInAuthentication.idToken,
  //           accessToken: googleSignInAuthentication.accessToken);
  //
  //       UserCredential result = await auth.signInWithCredential(authCredential);
  //       User? user = result.user;
  //
  //       if (user != null) {
  //         String Mobilenumber = "";
  //         String countryCode = "";
  //
  //         print("Login done");
  //         print("Email: ${result.user!.email}");
  //         print("Name: ${result.user!.displayName}");
  //         print("UID: ${result.user!.uid}");
  //         print("Phone Number: ${result.user!.phoneNumber}");
  //
  //         print("Login done");
  //
  //         print("Email: ${user.email}");
  //         print("Name: ${user.displayName}");
  //         print("UID: ${user.uid}");
  //         print("Phone Number: ${user.phoneNumber}");
  //         print("Photo: ${user.photoURL}");
  //         String? phoneNumber = user.phoneNumber;
  //
  //         var namePart = user.displayName?.split(' ');
  //         var firstName = namePart?[0].toString();
  //         var lastName = namePart?.sublist(1).join(" ");
  //         SharedPreferences pref = await SharedPreferences.getInstance();
  //         pref.setString('first_name', firstName.toString());
  //         pref.setString('last_name', lastName.toString());
  //         pref.setString('email', user.email.toString());
  //         pref.setString('image', user.photoURL.toString());
  //         pref.setBool('login', true);
  //
  //         Constant.token = pref.getString('token').toString();
  //         Constant.firstName = pref.getString('first_name').toString();
  //         Constant.lastName = pref.getString('last_name').toString();
  //         Constant.email = pref.getString('email').toString();
  //         // Constant.country = pref.getString('country');
  //         // Constant.countryCode = pref.getString('country_code');
  //         Constant.image = pref.getString('image');
  //
  //         if (phoneNumber != null) {
  //           String countryCode =
  //           phoneNumber.substring(0, phoneNumber.indexOf(' ') + 1).trim();
  //           String phoneNumberWithoutCountryCode =
  //           phoneNumber.substring(phoneNumber.indexOf(' ') + 1).trim();
  //           print("Phone Number: $phoneNumberWithoutCountryCode");
  //           print("Country Code: $countryCode");
  //           Mobilenumber = phoneNumberWithoutCountryCode;
  //           countryCode = countryCode;
  //
  //
  //         } else {
  //           print("Phone Number: Not available");
  //         }
  //         // SocialLoginApi(result.user!.email.toString(), "google",
  //         //     result.user!.uid.toString(),);
  //
  //
  //         Api.socialLoginApi(
  //           socailite_type: "google",
  //           email: result.user!.email.toString(),
  //           socailite_id: result.user!.uid.toString(),
  //           first_name: user.displayName.toString(),
  //           fcm_token: fcmToken,
  //
  //           // email: result.user!.email.toString(),
  //           // id: result.user!.uid.toString(),
  //           // type: "google",
  //           // name: user.displayName.toString(),
  //           // mobile: Mobilenumber,
  //           // countryCode: countryCode,
  //         ).then((e) async {
  //           if(e['status'] == 'success'){
  //             Navigator.pop(context);
  //             SharedPreferences pref = await SharedPreferences.getInstance();
  //             pref.setString('token', e['token'].toString());
  //             pref.setString('current_steps', e['userdata']['current_steps'].toString());
  //             Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
  //           }
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     // Get.back();
  //     Navigator.pop(context);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred: ${e.toString()}')),
  //     );
  //     print('google == ${e.toString()}');
  //     if (e is PlatformException) {
  //       print('Error code: ${e.code}');
  //       print('Error message: ${e.message}');
  //       print('Error details: ${e.details}');
  //     }
  //   }
  // }
  Future<void> googleLogin(BuildContext context) async {
      try {
        // Authenticate the user
        final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
        if (googleUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Google sign-in cancelled")),
          );
          return;
        }

        // Fetch authentication details
        final headers =
        await googleUser.authorizationClient.authorizationHeaders([
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ]);

        if (headers == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to fetch authorization headers")),
          );
          return;
        }

        // Create Firebase credentials using ID token
        final googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          // accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase
        UserCredential userCredential =
        await auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Save user info locally
          final SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString('first_name', user.displayName ?? '');
          pref.setString('email', user.email ?? '');
          pref.setString('image', user.photoURL ?? '');
          pref.setBool('login', true);

          // Call your API
          await Api.socialLoginApi(
            socailite_type: "google",
            email: user.email.toString(),
            socailite_id: user.uid.toString(),
            first_name: user.displayName ?? "",
            fcm_token: '',
          ).then((response) async {
            if (response['status'] == 'success') {
              pref.setString('token', response['token'].toString());
              pref.setString(
                  'current_steps', response['userdata']['current_steps'].toString());

              Navigator.pushReplacementNamed(context, '/home');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response['message'] ?? 'Login failed')),
              );
            }
          });
        }
      } catch (e) {
        print("Google Login Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google sign-in failed: $e")),
        );
      }
    }


  Future<void> facebookLogin(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    fcmToken = pref.getString('fcmToken');
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        // permissions: ['email'],
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final userData = await FacebookAuth.i.getUserData(
          fields: "name,email",
        );
        final name = userData["name"];
        final email = userData["email"];
        final phone = userData["phone"] ?? "";
        final id = userData["id"];

        String countryCode = "";
        String phoneNumber = phone;

        if (phone == null) {
          final parts = phone.split(' ');
          if (parts.length > 1) {
            countryCode = parts[0];
            phoneNumber = parts[1];
          }
        }

        print("User Name: $name");
        print("User Email: $email");
        print("User Phone: $phone");
        print("Country Code: $countryCode");
        print("Phone Number: $phoneNumber");

        var namePart = name.split(' ');
        var firstName = namePart?[0].toString();
        var lastName = namePart?.sublist(1).join(" ");
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('first_name', firstName.toString());
        pref.setString('last_name', lastName.toString());
        pref.setString('email', email.toString());
        // pref.setString('image', user.photoURL.toString());
        pref.setBool('login', true);

        Constant.token = pref.getString('token').toString();
        Constant.firstName = pref.getString('first_name').toString();
        Constant.lastName = pref.getString('last_name').toString();
        Constant.email = pref.getString('email').toString();
        // Constant.country = pref.getString('country');
        // Constant.countryCode = pref.getString('country_code');
        // Constant.image = pref.getString('image');

        await Api.socialLoginApi(
          socailite_type: "facebook",
          email: email,
          socailite_id: id,
          first_name: name,
          fcm_token: fcmToken,
          // mobile: phoneNumber,
          // countryCode: countryCode,
        ).then((e) async {
          if(e['status'] == 'success'){
            Navigator.pop(context);
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString('token', e['token'].toString());
            pref.setString('current_steps', e['userdata']['current_steps'].toString());
            Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar(key: bottomNavKey)));
          }
        });
      } else {
        Navigator.pop(context);
        print(result.message);
        Fluttertoast.showToast(msg: '${result.message}');
        // Utils.toastMessage("${result.message}");
        // Get.back();
      }
    } catch (e) {
      Navigator.pop(context);
      // Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
      print("An error occurred during Facebook login: $e");
      Fluttertoast.showToast(msg: "An error occurred during Facebook login: $e");
      // Get.back();
    }
  }

  Future<void> signout() async {
    await auth.signOut();
    await googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    print("User signed out");
  }

  // Future<void> appleLogin(BuildContext context) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   fcmToken = pref.getString('fcmToken');
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );
  //     print("start");
  //     print(credential);
  //     print("email: ${credential.email}");
  //     print("name: ${credential.givenName}");
  //     print("name: ${credential.givenName}");
  //     print("suarname: ${credential.familyName}");
  //     print("identityToken: ${credential.identityToken}");
  //     print("authorizationCode: ${credential.authorizationCode}");
  //     print("userIdentifier:${credential.userIdentifier}");
  //     print("userIdentifier:${credential.email}");
  //
  //     await Api.socialLoginApi(
  //       socailite_type: "apple",
  //       email: credential.email.toString(),
  //       socailite_id: credential.userIdentifier.toString(),
  //       first_name: "${credential.givenName ?? ''} ${credential.familyName ?? ''}",
  //       fcm_token: fcmToken,
  //       // mobile: "",
  //       // countryCode: "",
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred: ${e.toString()}')),
  //     );
  //   }
  // }
}