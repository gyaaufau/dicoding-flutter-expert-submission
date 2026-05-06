import 'package:common/common.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv/tv.dart';
import 'package:tv/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeTvRepository extends Fake implements TvRepository {}

class TestTvListCubit extends TvListCubit {
  TestTvListCubit(TvListState initialState)
      : super(
          getOnTheAirTvUseCase: GetOnTheAirTv(FakeTvRepository()),
          getPopularTvUseCase: GetPopularTv(FakeTvRepository()),
          getTopRatedTvUseCase: GetTopRatedTv(FakeTvRepository()),
        ) {
    emit(initialState);
  }

  @override
  Future<void> fetchPopularTvShows() async {}
}

void main() {
  Widget makeWidget(TvListCubit cubit) {
    return BlocProvider<TvListCubit>.value(
      value: cubit,
      child: const MaterialApp(home: PopularTvPage()),
    );
  }

  testWidgets('muncul loading saat state loading', (tester) async {
    final cubit = TestTvListCubit(
      const TvListState(popularTvShowsState: RequestState.Loading),
    );

    await tester.pumpWidget(makeWidget(cubit));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('muncul list saat data ada', (tester) async {
    final cubit = TestTvListCubit(
      const TvListState(
        popularTvShowsState: RequestState.Loaded,
        popularTvShows: <Tv>[],
      ),
    );

    await tester.pumpWidget(makeWidget(cubit));

    expect(find.byType(ListView), findsOneWidget);
  });
}
