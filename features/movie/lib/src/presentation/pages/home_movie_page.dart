import 'package:common/common.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_domain/movie_domain.dart';

import '../cubit/movie_list_cubit.dart';
import '../routes/movie_routes.dart';
import 'popular_movies_page.dart';
import 'search_movie_page.dart';
import 'top_rated_movies_page.dart';
import '../widgets/carousell_banner_widget.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  static const ROUTE_NAME = '/movies';

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MovieListCubit>()
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            onPressed: () => context.push(SearchMoviePage.ROUTE_NAME),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNowPlayingSection(context: context),
              _buildPopularSection(context: context),
              _buildTopRatedSection(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNowPlayingSection({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Now Playing',
              style: kHeading6.copyWith(color: kMikadoYellow),
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<MovieListCubit, MovieListState>(
            builder: (context, data) {
              final state = data.nowPlayingState;
              if (state == RequestState.Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state == RequestState.Loaded) {
                return NowPlayingMovieList(data.nowPlayingMovies);
              } else {
                return const Text('Failed');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          _buildSubHeading(
            title: 'Popular',
            onTap: () => context.push(PopularMoviesPage.ROUTE_NAME),
          ),
          BlocBuilder<MovieListCubit, MovieListState>(
            builder: (context, data) {
              final state = data.popularMoviesState;
              if (state == RequestState.Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state == RequestState.Loaded) {
                return MovieList(data.popularMovies);
              } else {
                return const Text('Failed');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopRatedSection({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () => context.push(TopRatedMoviesPage.ROUTE_NAME),
          ),
          BlocBuilder<MovieListCubit, MovieListState>(
            builder: (context, data) {
              final state = data.topRatedMoviesState;
              if (state == RequestState.Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state == RequestState.Loaded) {
                return MovieList(data.topRatedMovies);
              } else {
                return const Text('Failed');
              }
            },
          ),
        ],
      ),
    );
  }

  Row _buildSubHeading({required String title, required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(
                  'See More',
                  style: kSubtitle.copyWith(color: kMikadoYellow),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 16.w, color: kMikadoYellow),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NowPlayingMovieList extends StatelessWidget {
  const NowPlayingMovieList(this.movies, {super.key});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return CarousellBannerWidget(
      height: 220.h,
      items: movies.map((movie) {
        final imagePath = (movie.backdropPath?.isNotEmpty ?? false)
            ? movie.backdropPath!
            : (movie.posterPath ?? '');

        return CarousellBannerItem(
          title: movie.title ?? '-',
          imagePath: imagePath,
          overview: movie.overview,
          rating: movie.voteAverage,
          genreLabels: (movie.genreIds ?? const [])
              .map((id) => kMovieGenres[id])
              .whereType<String>()
              .toList(),
          isTvShows: false,
          onTap: () {
            context.pushNamed(MovieRouteNames.detail, extra: movie.id);
          },
          onWatchNow: () {
            context.pushNamed(MovieRouteNames.detail, extra: movie.id);
          },
        );
      }).toList(),
    );
  }
}

class MovieList extends StatelessWidget {
  const MovieList(this.movies, {super.key});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                context.pushNamed(MovieRouteNames.detail, extra: movie.id);
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
