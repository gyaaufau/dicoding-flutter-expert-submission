import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_domain/tv_domain.dart';

class TvListState extends Equatable {
  const TvListState({
    this.onTheAirTvShows = const [],
    this.onTheAirTvShowsState = RequestState.Empty,
    this.popularTvShows = const [],
    this.popularTvShowsState = RequestState.Empty,
    this.topRatedTvShows = const [],
    this.topRatedTvShowsState = RequestState.Empty,
    this.message = '',
  });

  final List<Tv> onTheAirTvShows;
  final RequestState onTheAirTvShowsState;
  final List<Tv> popularTvShows;
  final RequestState popularTvShowsState;
  final List<Tv> topRatedTvShows;
  final RequestState topRatedTvShowsState;
  final String message;

  TvListState copyWith({
    List<Tv>? onTheAirTvShows,
    RequestState? onTheAirTvShowsState,
    List<Tv>? popularTvShows,
    RequestState? popularTvShowsState,
    List<Tv>? topRatedTvShows,
    RequestState? topRatedTvShowsState,
    String? message,
  }) {
    return TvListState(
      onTheAirTvShows: onTheAirTvShows ?? this.onTheAirTvShows,
      onTheAirTvShowsState: onTheAirTvShowsState ?? this.onTheAirTvShowsState,
      popularTvShows: popularTvShows ?? this.popularTvShows,
      popularTvShowsState: popularTvShowsState ?? this.popularTvShowsState,
      topRatedTvShows: topRatedTvShows ?? this.topRatedTvShows,
      topRatedTvShowsState: topRatedTvShowsState ?? this.topRatedTvShowsState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
    onTheAirTvShows,
    onTheAirTvShowsState,
    popularTvShows,
    popularTvShowsState,
    topRatedTvShows,
    topRatedTvShowsState,
    message,
  ];
}

class TvListCubit extends Cubit<TvListState> {
  TvListCubit({
    required this.getOnTheAirTvUseCase,
    required this.getPopularTvUseCase,
    required this.getTopRatedTvUseCase,
  }) : super(const TvListState());

  final GetOnTheAirTv getOnTheAirTvUseCase;
  final GetPopularTv getPopularTvUseCase;
  final GetTopRatedTv getTopRatedTvUseCase;

  Future<void> fetchOnTheAirTvShows() async {
    emit(state.copyWith(onTheAirTvShowsState: RequestState.Loading));

    final result = await getOnTheAirTvUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          onTheAirTvShowsState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          onTheAirTvShowsState: RequestState.Loaded,
          onTheAirTvShows: data,
        ),
      ),
    );
  }

  Future<void> fetchPopularTvShows() async {
    emit(state.copyWith(popularTvShowsState: RequestState.Loading));

    final result = await getPopularTvUseCase.call(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          popularTvShowsState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          popularTvShowsState: RequestState.Loaded,
          popularTvShows: data,
        ),
      ),
    );
  }

  Future<void> fetchTopRatedTvShows() async {
    emit(state.copyWith(topRatedTvShowsState: RequestState.Loading));

    final result = await getTopRatedTvUseCase.call(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          topRatedTvShowsState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          topRatedTvShowsState: RequestState.Loaded,
          topRatedTvShows: data,
        ),
      ),
    );
  }
}
