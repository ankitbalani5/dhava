
import 'package:coherent_endurance/bloc/activityBloc/activity_bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/joinChallenges_Bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/suggested_Bloc.dart';
import 'package:coherent_endurance/bloc/feedDetailsBloc/feed_detail_bloc.dart';
import 'package:coherent_endurance/bloc/notificationBloc/notification_bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/followRequest_bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/otherProfile_bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
import 'package:coherent_endurance/bloc/saveActivityBloc/save_activity_bloc.dart';
import 'package:coherent_endurance/ui/introScreens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/MyFeedBloc/my_feed_bloc.dart';
import 'bloc/activityBloc/challenges_bloc.dart';
import 'bloc/loginBloc/login_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

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
    super.initState();
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
