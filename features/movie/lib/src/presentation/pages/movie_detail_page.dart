import 'package:common/common.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_domain/movie_domain.dart';

import '../cubit/movie_detail_cubit.dart';
import '../cubit/watchlist_movie_cubit.dart';
import '../routes/movie_routes.dart';
import '../widgets/genre_chip.dart';
import '../widgets/rating_chip.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.id});

  static const ROUTE_NAME = AppRoutePaths.moviesDetailPattern;

  final int id;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    final notifier = context.read<MovieDetailCubit>();
    Future.microtask(() {
      notifier.fetchMovieDetail(widget.id);
      notifier.loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, provider) {
          if (provider.movieState != RequestState.Loaded ||
              provider.movie == null) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _handleWatchlistAction(provider),
                  style: FilledButton.styleFrom(
                    backgroundColor: kMikadoYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: Icon(
                    provider.isAddedToWatchlist ? Icons.check : Icons.add,
                  ),
                  label: Text(
                    provider.isAddedToWatchlist
                        ? 'Added to Watchlist'
                        : 'Add to Watchlist',
                  ),
                ),
              ),
            ),
          );
        },
      ),
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, provider) {
          final data = provider.movie;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 360.h,
                backgroundColor: Colors.black,
                flexibleSpace: _MoviePosterFlexibleSpace(
                  state: provider.movieState,
                  movie: data,
                ),
              ),
              if (provider.movieState == RequestState.Loading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.movieState == RequestState.Error)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _MovieDetailPlaceholder(
                    title: 'Movie detail error',
                    message: provider.message,
                  ),
                )
              else if (provider.movieState == RequestState.Loaded)
                SliverToBoxAdapter(
                  child: _MovieDetailContent(
                    provider: provider,
                    onRecommendationTap: (id) {
                      context.pushNamed(
                        MovieRouteNames.detail,
                        pathParameters: {AppRouteParams.id: '$id'},
                      );
                    },
                  ),
                )
              else
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleWatchlistAction(MovieDetailState provider) async {
    final detailCubit = context.read<MovieDetailCubit>();
    final watchlistNotifier = context.read<WatchlistMovieCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final movie = provider.movie!;

    if (provider.isAddedToWatchlist) {
      await detailCubit.removeFromWatchlist(movie);
    } else {
      await detailCubit.addWatchlist(movie);
    }

    if (!mounted) return;

    final message = detailCubit.state.watchlistMessage;
    if (message == MovieDetailCubit.watchlistAddSuccessMessage ||
        message == MovieDetailCubit.watchlistRemoveSuccessMessage) {
      await watchlistNotifier.fetchWatchlistMovies();
      messenger.showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    showDialog<void>(
      context: navigator.context,
      builder: (context) => AlertDialog(content: Text(message)),
    );
  }
}

class _MoviePosterFlexibleSpace extends StatelessWidget {
  const _MoviePosterFlexibleSpace({required this.state, required this.movie});

  final RequestState state;
  final MovieDetail? movie;

  @override
  Widget build(BuildContext context) {
    final title = movie?.title ?? 'Movie Detail';
    final imageUrl = movie?.posterPath == null
        ? null
        : '$BASE_IMAGE_URL${movie!.posterPath}';

    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Stack(
        fit: StackFit.expand,
        children: [
          if (state == RequestState.Loading)
            const ColoredBox(
              color: Colors.black,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (imageUrl != null)
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => _PosterFallback(title: title),
              errorWidget: (context, url, error) =>
                  _PosterFallback(title: title),
            )
          else
            _PosterFallback(title: title),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x22000000), Color(0xCC000000)],
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (movie != null) ...[
                  RatingChip(rating: movie!.voteAverage),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: movie!.genres
                        .map((g) => GenreChip(label: g.name, compact: true))
                        .toList(),
                  ),
                  SizedBox(height: 8.h),
                ],
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (movie != null) ...[
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: [
                      _InfoBadge(
                        icon: Icons.schedule_outlined,
                        label: '${movie!.runtime} min',
                      ),
                      _InfoBadge(
                        icon: Icons.calendar_month_outlined,
                        label: movie!.releaseDate.toIndonesianDate(),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B1B1B),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.movie_outlined, color: Colors.white70, size: 56),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieDetailContent extends StatelessWidget {
  const _MovieDetailContent({
    required this.provider,
    required this.onRecommendationTap,
  });

  final MovieDetailState provider;
  final ValueChanged<int> onRecommendationTap;

  @override
  Widget build(BuildContext context) {
    final movie = provider.movie!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          _OverviewSection(overview: movie.overview),
          SizedBox(height: 20.h),
          _RecommendationSection(
            state: provider.recommendationState,
            movies: provider.movieRecommendations,
            message: provider.message,
            onTap: onRecommendationTap,
          ),
        ],
      ),
    );
  }
}

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({required this.overview});

  final String overview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12.h),
        Text(
          overview,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.5,
            color: Colors.white.withValues(alpha: 0.92),
          ),
        ),
      ],
    );
  }
}

class _RecommendationSection extends StatelessWidget {
  const _RecommendationSection({
    required this.state,
    required this.movies,
    required this.message,
    required this.onTap,
  });

  final RequestState state;
  final List<Movie> movies;
  final String message;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (state == RequestState.Loading) {
      child = const Center(child: CircularProgressIndicator());
    } else if (state == RequestState.Error) {
      child = Text(message);
    } else if (movies.isEmpty) {
      child = Text(
        'Belum ada rekomendasi.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
      );
    } else {
      child = SizedBox(
        height: 180.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          separatorBuilder: (_, index) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _RecommendationCard(
              movie: movie,
              onTap: () => onTap(movie.id),
            );
          },
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12.h),
        child,
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        width: 120.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              movie.title ?? '-',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: kMikadoYellow),
          SizedBox(width: 8.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 180.w),
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class _MovieDetailPlaceholder extends StatelessWidget {
  const _MovieDetailPlaceholder({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.movie_creation_outlined, size: 56),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
