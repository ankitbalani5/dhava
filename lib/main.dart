
import 'package:coherent_endurance/bloc/activeChallengeBloc/active_challenge_bloc.dart';
import 'package:coherent_endurance/bloc/activityBloc/activity_bloc.dart';
import 'package:coherent_endurance/bloc/challengeDetailBloc/challenge_detail_bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/challengesDetails_Bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/joinChallenges_Bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/suggested_Bloc.dart';
import 'package:coherent_endurance/bloc/deleteAccountBloc/deleteAccount_bloc.dart';
import 'package:coherent_endurance/bloc/feedDetailsBloc/feed_detail_bloc.dart';
import 'package:coherent_endurance/bloc/myJoinedChallengesBloc/myJoinedChallenges_Bloc.dart';
import 'package:coherent_endurance/bloc/myAllChallengeBloc/my_all_challenge_bloc.dart';
import 'package:coherent_endurance/bloc/newsBloc/news_bloc.dart';
import 'package:coherent_endurance/bloc/notificationBloc/notification_bloc.dart';
import 'package:coherent_endurance/bloc/followRequestBloc/followRequest_bloc.dart';
import 'package:coherent_endurance/bloc/otherProfileBloc/otherProfile_bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
import 'package:coherent_endurance/bloc/saveActivityBloc/save_activity_bloc.dart';
import 'package:coherent_endurance/bloc/trophyBloc/trophy_bloc.dart';
import 'package:coherent_endurance/bloc/updateEmailBloc/update_email_bloc.dart';
import 'package:coherent_endurance/constant/constant.dart';
import 'package:coherent_endurance/bloc/suggestionBloc/suggestion_bloc.dart';
import 'package:coherent_endurance/bloc/updateProfileBloc/update_profile_bloc.dart';
import 'package:coherent_endurance/bloc/userJoinedChallengesBloc/userJoinedChallenges_Bloc.dart';
import 'package:coherent_endurance/ui/introScreens/splashScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/MyFeedBloc/my_feed_bloc.dart';
import 'bloc/activityBloc/challenges_bloc.dart';
import 'bloc/loginBloc/login_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/newsDetailBloc/news_detail_bloc.dart';
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
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        BlocProvider<ActivityBloc>(create: (context) => ActivityBloc()),
        BlocProvider<SaveActivityBloc>(create: (context) => SaveActivityBloc()),
        BlocProvider<GetAllChallengesBloc>(create: (context) => GetAllChallengesBloc()),
        BlocProvider<SuggestedBloc>(create: (context) => SuggestedBloc()),
        BlocProvider<MyFeedBloc>(create: (context) => MyFeedBloc()),
        BlocProvider<JoinChalllengesBloc>(create: (context) => JoinChalllengesBloc()),
        BlocProvider<OtherProfileBloc>(create: (context) => OtherProfileBloc()),
        BlocProvider<NotificationBloc>(create: (context) => NotificationBloc()),
        BlocProvider<FollowRequestBloc>(create: (context) => FollowRequestBloc()),
        BlocProvider<FeedDetailBloc>(create: (context) => FeedDetailBloc()),
        BlocProvider<SuggestionBloc>(create: (context) => SuggestionBloc()),
        BlocProvider<ChallengesDetailsBloc>(create: (context) => ChallengesDetailsBloc()),
        BlocProvider<MyjoinedChallengesBloc>(create: (context) => MyjoinedChallengesBloc()),
        BlocProvider<UserjoinedChallengesBloc>(create: (context) => UserjoinedChallengesBloc()),
        BlocProvider<UpdateProfileBloc>(create: (context) => UpdateProfileBloc()),
        BlocProvider<ActiveChallengeBloc>(create: (context) => ActiveChallengeBloc()),
        BlocProvider<NewsBloc>(create: (context) => NewsBloc()),
        BlocProvider<NewsDetailBloc>(create: (context) => NewsDetailBloc()),
        BlocProvider<UpdateEmailBloc>(create: (context) => UpdateEmailBloc()),

          BlocProvider<TrophyBloc>(create: (_) => TrophyBloc()),
          BlocProvider<MyAllChallengeBloc>(create: (_) => MyAllChallengeBloc()),
          BlocProvider<ChallengeDetailBloc>(create: (_) => ChallengeDetailBloc()),
          BlocProvider<SuggestionBloc>(create: (context) => SuggestionBloc()),
          BlocProvider<ChallengesDetailsBloc>(create: (context) => ChallengesDetailsBloc()),
          BlocProvider<MyjoinedChallengesBloc>(create: (context) => MyjoinedChallengesBloc()),
          BlocProvider<UserjoinedChallengesBloc>(create: (context) => UserjoinedChallengesBloc()),
          BlocProvider<DeleteAccountBloc>(create: (context) => DeleteAccountBloc()),
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
