import 'dart:async';

import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_domain/tv_domain.dart';

class TvSearchState extends Equatable {
  const TvSearchState({
    this.state = RequestState.Empty,
    this.searchResult = const [],
    this.message = '',
  });

  final RequestState state;
  final List<Tv> searchResult;
  final String message;

  TvSearchState copyWith({
    RequestState? state,
    List<Tv>? searchResult,
    String? message,
  }) {
    return TvSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, searchResult, message];
}

class TvSearchCubit extends Cubit<TvSearchState> {
  TvSearchCubit({required this.searchTv}) : super(const TvSearchState());

  final SearchTv searchTv;

  Future<void> fetchTvSearch(String query) async {
    _logTvAnalyticsEvent(
      'search_submitted',
      params: {
        'feature': 'tv',
        'content_type': 'tv',
        'query_length': query.length,
      },
    );
    emit(state.copyWith(state: RequestState.Loading));

    final result = await searchTv.call(query);
    result.fold(
      (failure) => emit(
        state.copyWith(state: RequestState.Error, message: failure.message),
      ),
      (data) =>
          emit(state.copyWith(state: RequestState.Loaded, searchResult: data)),
    );
  }
}

void _logTvAnalyticsEvent(
  String name, {
  Map<String, Object?> params = const {},
}) {
  if (!locator.isRegistered<AnalyticsTracker>()) {
    return;
  }
  unawaited(locator<AnalyticsTracker>().logEvent(name, params: params));
}
