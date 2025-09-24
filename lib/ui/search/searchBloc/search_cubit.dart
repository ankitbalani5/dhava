// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
//
// part 'search_state.dart';
//
// class SearchCubit extends Cubit<SearchState> {
//   SearchCubit() : super(SearchInitial());
// }

import 'dart:async';
import 'dart:io';

import 'package:coherent_endurance/models/findUserModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/api.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Timer? _debounce;
  bool _isSearchActive = true; // ✅ flag

  void activateSearch() {
  _isSearchActive = true;
  emit(SearchActive());
  }

  void deactivateSearch() {
  _isSearchActive = false;
  emit(SearchInitial());
  }

  Future<void> searchUsers(String query, context, {int perPage = 10, int page = 1, bool isPagination = false,}) async {
    // if (query.isEmpty) {
    //   emit(SearchActive());
    //   return;
    // }

    if (!_isSearchActive) return; // ✅ अगर search बंद है तो ignore कर दो
    if (!isPagination) {
      emit(SearchLoading());
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (!_isSearchActive) return; // ✅ फिर से check करो
      try {
        final body = {
          "search_keyword": query,
          "per_page": perPage,
          "page": page,
        };

        final headers = {
          "Content-Type": "application/json",
        };

        final response =
        await Api.getApi('${ApiEndPoint.userFind}?per_page=${perPage}&page=${page}&search_keyword=${query}', headers, context);
        final result = FindUserModel.fromJson(response);

        if (!_isSearchActive) return; // ✅ अगर बीच में बंद कर दिया तो response ignore

        if (result.statusCode == 200) {
          // ✅ InnerData की List लो
          final newUsers = result.data?.data ?? <InnerData>[];

          if (isPagination && state is SearchLoaded) {
            final currentState = state as SearchLoaded;
            final updatedList = List<InnerData>.from(currentState.users)
              ..addAll(newUsers);

            emit(SearchLoaded(users: updatedList, page: page, hasMore: newUsers.isNotEmpty,));
          }
          else {
            emit(SearchLoaded(users: newUsers, page: page, hasMore: newUsers.isNotEmpty,
            ));
          }
        } else {
          emit(SearchError(result.message ?? "Something went wrong"));
        }
      } on SocketException {
        emit(SearchError("Please check your internet connection"));
      } catch (e, stacktrace) {
        if (!_isSearchActive) return; // ✅ error भी ignore करो
        if (kDebugMode) {
          print(stacktrace);
        }
        emit(SearchError(e.toString()));
      }
    });
  }


  // @override
  // Future<void> close() {
  //   _debounce?.cancel();
  //   return super.close();
  // }
}