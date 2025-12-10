import 'package:coherent_endurance/ui/bottomNavBar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api.dart';


class SocialAuth{
  var fcmToken;
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn.instance/*GoogleSignIn()*/;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Future<User?> signInWithGoogle(BuildContext context) async {
  //   try {
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
  //           if (user != null) {
  //             // Save user info locally
  //             final SharedPreferences pref = await SharedPreferences.getInstance();
  //             pref.setString('first_name', user.displayName ?? '');
  //             pref.setString('email', user.email ?? '');
  //             pref.setString('image', user.photoURL ?? '');
  //             pref.setBool('login', true);
  //
  //             // Call your API
  //             await Api.socialLoginApi(
  //               socailite_type: "google",
  //               email: user.email.toString(),
  //               socailite_id: user.uid.toString(),
  //               first_name: user.displayName ?? "",
  //               fcm_token: '',
  //               context: context
  //             ).then((response) async {
  //               if (response['status'] == 'success') {
  //                 pref.setString('token', response['token'].toString());
  //                 pref.setString(
  //                     'current_steps', response['userdata']['current_steps'].toString());
  //
  //                 Navigator.pushReplacementNamed(context, '/home');
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: Text(response['message'] ?? 'Login failed')),
  //                 );
  //               }
  //             });
  //           }
  //     return userCredential.user;
  //   } catch (e) {
  //
  //     print("Sign-in error: $e");
  //     return null;
  //   }
  // }

  /// Signs out the user from both Google and Firebase.
  Future<void> signOut() async {

    await _googleSignIn.signOut();
    await _auth.signOut();
  }


  // Future<void> googleLogin(BuildContext context) async {
  //     try {
  //       // Authenticate the user
  //       final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
  //       if (googleUser == null) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Google sign-in cancelled")),
  //         );
  //         return;
  //       }
  //
  //       // Fetch authentication details
  //       final headers =
  //       await googleUser.authorizationClient.authorizationHeaders([
  //         'email',
  //         'https://www.googleapis.com/auth/userinfo.profile',
  //       ]);
  //
  //       if (headers == null) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Failed to fetch authorization headers")),
  //         );
  //         return;
  //       }
  //
  //       // Create Firebase credentials using ID token
  //       final googleAuth = await googleUser.authentication;
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         // accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //
  //       // Sign in to Firebase
  //       UserCredential userCredential =
  //       await auth.signInWithCredential(credential);
  //       final User? user = userCredential.user;
  //
  //       if (user != null) {
  //         // Save user info locally
  //         final SharedPreferences pref = await SharedPreferences.getInstance();
  //         pref.setString('first_name', user.displayName ?? '');
  //         pref.setString('email', user.email ?? '');
  //         pref.setString('image', user.photoURL ?? '');
  //         pref.setBool('login', true);
  //
  //         // Call your API
  //         await Api.socialLoginApi(
  //           socailite_type: "google",
  //           email: user.email.toString(),
  //           socailite_id: user.uid.toString(),
  //           first_name: user.displayName ?? "",
  //           fcm_token: '',
  //         ).then((response) async {
  //           if (response['status'] == 'success') {
  //             pref.setString('token', response['token'].toString());
  //             pref.setString(
  //                 'current_steps', response['userdata']['current_steps'].toString());
  //
  //             Navigator.pushReplacementNamed(context, '/home');
  //           } else {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(content: Text(response['message'] ?? 'Login failed')),
  //             );
  //           }
  //         });
  //       }
  //     } catch (e) {
  //       print("Google Login Error: $e");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Google sign-in failed: $e")),
  //       );
  //     }
  //   }


  // Future<void> facebookLogin(BuildContext context) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   fcmToken = pref.getString('fcmToken');
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login(
  //       // permissions: ['email'],
  //       permissions: ['email', 'public_profile'],
  //     );
  //
  //     if (result.status == LoginStatus.success) {
  //       final AccessToken accessToken = result.accessToken!;
  //       final userData = await FacebookAuth.i.getUserData(
  //         fields: "name,email",
  //       );
  //       final name = userData["name"];
  //       final email = userData["email"];
  //       final phone = userData["phone"] ?? "";
  //       final id = userData["id"];
  //
  //       String countryCode = "";
  //       String phoneNumber = phone;
  //
  //       if (phone == null) {
  //         final parts = phone.split(' ');
  //         if (parts.length > 1) {
  //           countryCode = parts[0];
  //           phoneNumber = parts[1];
  //         }
  //       }
  //
  //       print("User Name: $name");
  //       print("User Email: $email");
  //       print("User Phone: $phone");
  //       print("Country Code: $countryCode");
  //       print("Phone Number: $phoneNumber");
  //
  //       var namePart = name.split(' ');
  //       var firstName = namePart?[0].toString();
  //       var lastName = namePart?.sublist(1).join(" ");
  //       SharedPreferences pref = await SharedPreferences.getInstance();
  //       pref.setString('first_name', firstName.toString());
  //       pref.setString('last_name', lastName.toString());
  //       pref.setString('email', email.toString());
  //       // pref.setString('image', user.photoURL.toString());
  //       pref.setBool('login', true);
  //
  //       Constant.token = pref.getString('token').toString();
  //       Constant.firstName = pref.getString('first_name').toString();
  //       Constant.lastName = pref.getString('last_name').toString();
  //       Constant.email = pref.getString('email').toString();
  //       // Constant.country = pref.getString('country');
  //       // Constant.countryCode = pref.getString('country_code');
  //       // Constant.image = pref.getString('image');
  //
  //       // await Api.socialLoginApi(
  //       //   socailite_type: "facebook",
  //       //   email: email,
  //       //   socailite_id: id,
  //       //   first_name: name,
  //       //   fcm_token: fcmToken,
  //       //   context: context
  //       //   // mobile: phoneNumber,
  //       //   // countryCode: countryCode,
  //       // ).then((e) async {
  //       //   if(e['status'] == 'success'){
  //       //     Navigator.pop(context);
  //       //     SharedPreferences pref = await SharedPreferences.getInstance();
  //       //     pref.setString('token', e['token'].toString());
  //       //     pref.setString('current_steps', e['userdata']['current_steps'].toString());
  //       //     Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar(key: bottomNavKey)));
  //       //   }
  //       // });
  //     } else {
  //       Navigator.pop(context);
  //       print(result.message);
  //       Fluttertoast.showToast(msg: '${result.message}');
  //       // Utils.toastMessage("${result.message}");
  //       // Get.back();
  //     }
  //   } catch (e) {
  //     Navigator.pop(context);
  //     // Get.back();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred: ${e.toString()}')),
  //     );
  //     print("An error occurred during Facebook login: $e");
  //     Fluttertoast.showToast(msg: "An error occurred during Facebook login: $e");
  //     // Get.back();
  //   }
  // }

  // Future<void> signout() async {
  //   await auth.signOut();
  //   await googleSignIn.signOut();
  //   await FacebookAuth.instance.logOut();
  //   print("User signed out");
  // }

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