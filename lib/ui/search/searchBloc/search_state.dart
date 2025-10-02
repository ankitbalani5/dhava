
import 'package:coherent_endurance/models/findUserModel.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}
class SearchActive extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<InnerData> users;
  final int page;
  final bool hasMore;

  SearchLoaded({
    required this.users,
    required this.page,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [users, page, hasMore];
}



class SearchError extends SearchState {
  final String message;
  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}