part of 'trophy_bloc.dart';

@immutable
sealed class TrophyState {}

final class TrophyInitial extends TrophyState {}
final class MyTrophyLoading extends TrophyState {}
final class MyTrophySuccess extends TrophyState {
  final TrophyModel trophyModel;
  MyTrophySuccess(this.trophyModel);
}
final class MyTrophyError extends TrophyState {
  final String error;
  MyTrophyError(this.error);
}
