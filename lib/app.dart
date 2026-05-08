import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:ditonton/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => locator<MovieListCubit>()),
            BlocProvider(create: (_) => locator<MovieDetailCubit>()),
            BlocProvider(create: (_) => locator<MovieSearchCubit>()),
            BlocProvider(create: (_) => locator<TopRatedMoviesCubit>()),
            BlocProvider(create: (_) => locator<PopularMoviesCubit>()),
            BlocProvider(create: (_) => locator<WatchlistMovieCubit>()),
            BlocProvider(create: (_) => locator<TvDetailCubit>()),
            BlocProvider(create: (_) => locator<TvListCubit>()),
            BlocProvider(create: (_) => locator<TvSearchCubit>()),
            BlocProvider(create: (_) => locator<WatchlistTvCubit>()),
          ],
          child: MaterialApp.router(
            title: 'Flutter Demo',
            theme: ThemeData.dark().copyWith(
              colorScheme: kColorScheme,
              primaryColor: kRichBlack,
              scaffoldBackgroundColor: kRichBlack,
              textTheme: kTextTheme,
              drawerTheme: kDrawerTheme,
            ),
            routerConfig: appRouter,
          ),
        );
      },
    );
  }
}
