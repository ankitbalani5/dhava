// part of 'search_cubit.dart';
//
// @immutable
// sealed class SearchState {}
//
// final class SearchInitial extends SearchState {}

import 'package:coherent_endurance/models/findUserModel.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {} // Default Friends/Clubs UI

class SearchActive extends SearchState {} // Show Search Result UI

class SearchLoading extends SearchState {} // API call in progress

class SearchLoaded extends SearchState {
  final List<InnerData> users; // ✅ अब सही type
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