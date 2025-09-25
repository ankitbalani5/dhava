
import 'package:coherent_endurance/bloc/activityBloc/activity_bloc.dart';
import 'package:coherent_endurance/bloc/challengesBloc/suggested_Bloc.dart';
import 'package:coherent_endurance/bloc/profileBloc/profile_bloc.dart';
import 'package:coherent_endurance/bloc/saveActivityBloc/save_activity_bloc.dart';
import 'package:coherent_endurance/ui/introScreens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/MyFeedBloc/my_feed_bloc.dart';
import 'bloc/activityBloc/challenges_bloc.dart';
import 'bloc/loginBloc/login_bloc.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
        // BlocProvider<CommonResponseBloc>(create: (context) => CommonResponseBloc(),),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        BlocProvider<ActivityBloc>(create: (context) => ActivityBloc()),
        BlocProvider<SaveActivityBloc>(create: (context) => SaveActivityBloc()),
        BlocProvider<GetAllChallengesBloc>(create: (context) => GetAllChallengesBloc()),
        BlocProvider<SuggestedBloc>(create: (context) => SuggestedBloc()),
        BlocProvider<MyFeedBloc>(create: (context) => MyFeedBloc()),
    ],
      child:
      MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Coherent Endurance',
      theme: ThemeData(
        fontFamily: 'InterRegular',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
      ),
      home: SplashScreen(),
    ));
  }
}
