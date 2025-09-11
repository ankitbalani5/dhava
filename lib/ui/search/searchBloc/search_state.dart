// part of 'search_cubit.dart';
//
// @immutable
// sealed class SearchState {}
//
// final class SearchInitial extends SearchState {}

import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {} // Default Friends/Clubs UI

class SearchActive extends SearchState {} // Show Search Result UI
