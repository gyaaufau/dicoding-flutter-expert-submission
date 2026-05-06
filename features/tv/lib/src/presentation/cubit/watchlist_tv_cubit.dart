import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_domain/tv_domain.dart';

class WatchlistTvState extends Equatable {
  const WatchlistTvState({
    this.watchlistTv = const [],
    this.watchlistState = RequestState.Empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  final List<Tv> watchlistTv;
  final RequestState watchlistState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  WatchlistTvState copyWith({
    List<Tv>? watchlistTv,
    RequestState? watchlistState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return WatchlistTvState(
      watchlistTv: watchlistTv ?? this.watchlistTv,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object> get props => [
    watchlistTv,
    watchlistState,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}

class WatchlistTvCubit extends Cubit<WatchlistTvState> {
  WatchlistTvCubit({
    required this.getWatchlistTv,
    required this.getWatchlistTvStatus,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(const WatchlistTvState());

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchlistTv getWatchlistTv;
  final GetWatchlistTvStatus getWatchlistTvStatus;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  Future<void> fetchWatchlistTv() async {
    emit(state.copyWith(watchlistState: RequestState.Loading));

    final result = await getWatchlistTv.call(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          watchlistState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tvData) => emit(
        state.copyWith(
          watchlistState: RequestState.Loaded,
          watchlistTv: tvData,
        ),
      ),
    );
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchlistTvStatus.call(id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlistTv.call(tv);
    final message = _foldWatchlistMessage(result);
    emit(state.copyWith(watchlistMessage: message));
    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlistTv.call(tv);
    final message = _foldWatchlistMessage(result);
    emit(state.copyWith(watchlistMessage: message));
    await loadWatchlistStatus(tv.id);
  }

  String _foldWatchlistMessage(dynamic result) {
    return result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );
  }
}
