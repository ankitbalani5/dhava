
import 'package:coherent_endurance/models/getAllChallengesResponse.dart';

abstract class GetAllChallengesState {
  const GetAllChallengesState();
}

class GetAllChallengesInitial extends GetAllChallengesState {
  GetAllChallengesInitial() : super();
}

class GetAllChallengesLoading extends GetAllChallengesState {
  GetAllChallengesLoading() : super();
}

class GetAllChallengesLoaded extends GetAllChallengesState {
  final GetAllChallengesResponse responseData;
  GetAllChallengesLoaded(this.responseData) : super();
}

class GetAllChallengesError extends GetAllChallengesState {
  final String error;

  GetAllChallengesError(this.error) : super();
}