
import 'package:coherent_endurance/bloc/activityBloc/activity_bloc.dart';
import 'package:coherent_endurance/bloc/challengeDetailBloc/challenge_detail_bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/joinChallenges_Bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/suggested_Bloc.dart';
import 'package:coherent_endurance/bloc/feedDetailsBloc/feed_detail_bloc.dart';
import 'package:coherent_endurance/bloc/myAllChallengeBloc/my_all_challenge_bloc.dart';
import 'package:coherent_endurance/bloc/notificationBloc/notification_bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/followRequest_bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/otherProfile_bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
import 'package:coherent_endurance/bloc/saveActivityBloc/save_activity_bloc.dart';
import 'package:coherent_endurance/bloc/trophyBloc/trophy_bloc.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/ui/introScreens/splashScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/MyFeedBloc/my_feed_bloc.dart';
import 'bloc/activityBloc/challenges_bloc.dart';
import 'bloc/loginBloc/login_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    _getFcmToken();
    super.initState();
  }

  Future<void> _getFcmToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await messaging.getToken();
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString(PrefKey.fcmToken, token.toString());
        print("✅ FCM Token: $token");

      } else {
        print("❌ Notification permission not granted");
      }
    } catch (e) {
      print("🔥 Error getting FCM token: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => LoginBloc()),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
        BlocProvider<ActivityBloc>(create: (_) => ActivityBloc()),
        BlocProvider<SaveActivityBloc>(create: (_) => SaveActivityBloc()),
        BlocProvider<GetAllChallengesBloc>(create: (_) => GetAllChallengesBloc()),
        BlocProvider<SuggestedBloc>(create: (_) => SuggestedBloc()),
        BlocProvider<MyFeedBloc>(create: (_) => MyFeedBloc()),
        BlocProvider<JoinChalllengesBloc>(create: (_) => JoinChalllengesBloc()),
        BlocProvider<OtherProfileBloc>(create: (_) => OtherProfileBloc()),
        BlocProvider<NotificationBloc>(create: (_) => NotificationBloc()),
        BlocProvider<FollowRequestBloc>(create: (_) => FollowRequestBloc()),
        BlocProvider<FeedDetailBloc>(create: (_) => FeedDetailBloc()),
        BlocProvider<TrophyBloc>(create: (_) => TrophyBloc()),
        BlocProvider<MyAllChallengeBloc>(create: (_) => MyAllChallengeBloc()),
        BlocProvider<ChallengeDetailBloc>(create: (_) => ChallengeDetailBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dhava',
        theme: ThemeData(fontFamily: 'InterRegular'),
        home: const SplashScreen(),
      ),
    );
  }
}
