import 'package:common/common.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_domain/tv_domain.dart';

class TvDetailState extends Equatable {
  const TvDetailState({
    this.tv,
    this.tvState = RequestState.Empty,
    this.tvRecommendations = const [],
    this.tvSeasonState = RequestState.Empty,
    this.tvSeasonsDetails,
    this.recommendationState = RequestState.Empty,
    this.selectedSeason,
    this.message = '',
  });

  final TvDetail? tv;
  final RequestState tvState;
  final List<Tv> tvRecommendations;
  final RequestState tvSeasonState;
  final TvSeasonDetail? tvSeasonsDetails;
  final RequestState recommendationState;
  final TvSeason? selectedSeason;
  final String message;

  TvDetailState copyWith({
    TvDetail? tv,
    bool clearTv = false,
    RequestState? tvState,
    List<Tv>? tvRecommendations,
    RequestState? tvSeasonState,
    TvSeasonDetail? tvSeasonsDetails,
    bool clearTvSeasonsDetails = false,
    RequestState? recommendationState,
    TvSeason? selectedSeason,
    bool clearSelectedSeason = false,
    String? message,
  }) {
    return TvDetailState(
      tv: clearTv ? null : (tv ?? this.tv),
      tvState: tvState ?? this.tvState,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      tvSeasonState: tvSeasonState ?? this.tvSeasonState,
      tvSeasonsDetails: clearTvSeasonsDetails
          ? null
          : (tvSeasonsDetails ?? this.tvSeasonsDetails),
      recommendationState: recommendationState ?? this.recommendationState,
      selectedSeason: clearSelectedSeason
          ? null
          : (selectedSeason ?? this.selectedSeason),
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    tv,
    tvState,
    tvRecommendations,
    tvSeasonState,
    tvSeasonsDetails,
    recommendationState,
    selectedSeason,
    message,
  ];
}

class TvDetailCubit extends Cubit<TvDetailState> {
  TvDetailCubit({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getTvSeasonDetail,
  }) : super(const TvDetailState());

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetTvSeasonDetail getTvSeasonDetail;

  Future<void> fetchTvDetail(int id) async {
    emit(state.copyWith(tvState: RequestState.Loading));

    final detailResult = await getTvDetail.call(id);
    final recommendationResult = await getTvRecommendations.call(id);

    detailResult.fold(
      (failure) => emit(
        state.copyWith(tvState: RequestState.Error, message: failure.message),
      ),
      (tv) {
        final selectedSeason = _getInitialSelectedSeason(tv);
        emit(
          state.copyWith(
            tv: tv,
            selectedSeason: selectedSeason,
            clearTvSeasonsDetails: true,
            tvSeasonState: RequestState.Empty,
            recommendationState: RequestState.Loading,
          ),
        );

        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              tvState: RequestState.Loaded,
              recommendationState: RequestState.Error,
              message: failure.message,
            ),
          ),
          (shows) => emit(
            state.copyWith(
              tvState: RequestState.Loaded,
              recommendationState: RequestState.Loaded,
              tvRecommendations: shows,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchTvSeasonDetail(int tvId, int seasonNumber) async {
    emit(state.copyWith(tvSeasonState: RequestState.Loading));

    final result = await getTvSeasonDetail.call(
      TvSeasonParams(seasonNumber: seasonNumber, seriesId: tvId),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          tvSeasonState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (episodes) => emit(
        state.copyWith(
          tvSeasonState: RequestState.Loaded,
          tvSeasonsDetails: episodes,
        ),
      ),
    );
  }

  void selectSeason(TvSeason season) {
    emit(state.copyWith(selectedSeason: season));
  }

  TvSeason? _getInitialSelectedSeason(TvDetail tv) {
    if (tv.seasons.isEmpty) {
      return null;
    }
    return tv.seasons.first;
  }
}
