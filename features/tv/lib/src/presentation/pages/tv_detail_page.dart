import 'package:common/common.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_domain/tv_domain.dart';

import '../routes/tv_routes.dart';
import '../cubit/tv_detail_cubit.dart';
import '../cubit/watchlist_tv_cubit.dart';
import '../widgets/genre_chip.dart';
import '../widgets/rating_chip.dart';
import '../widgets/season_button_pill.dart';

class TvDetailPage extends StatefulWidget {
  static const routeName = AppRoutePaths.tvDetailPattern;

  final int id;

  const TvDetailPage({super.key, required this.id});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    final detailNotifier = context.read<TvDetailCubit>();
    final watchlistNotifier = context.read<WatchlistTvCubit>();
    Future.microtask(() async {
      await detailNotifier.fetchTvDetail(widget.id);
      await watchlistNotifier.loadWatchlistStatus(widget.id);
      final selectedSeason = detailNotifier.state.selectedSeason;

      if (selectedSeason != null) {
        await detailNotifier.fetchTvSeasonDetail(
          widget.id,
          selectedSeason.seasonNumber,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<WatchlistTvCubit, WatchlistTvState>(
        builder: (context, watchlistProvider) {
          final detailProvider = context.watch<TvDetailCubit>().state;
          if (detailProvider.tvState != RequestState.Loaded ||
              detailProvider.tv == null) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () =>
                      _handleWatchlistAction(detailProvider, watchlistProvider),
                  style: FilledButton.styleFrom(
                    backgroundColor: kMikadoYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: Icon(
                    watchlistProvider.isAddedToWatchlist
                        ? Icons.check
                        : Icons.add,
                  ),
                  label: Text(
                    watchlistProvider.isAddedToWatchlist
                        ? 'Added to Watchlist'
                        : 'Add to Watchlist',
                  ),
                ),
              ),
            ),
          );
        },
      ),
      body: BlocBuilder<TvDetailCubit, TvDetailState>(
        builder: (context, provider) {
          final isLoaded =
              provider.tvState == RequestState.Loaded && provider.tv != null;
          final isInitial = provider.tvState == RequestState.Empty;
          final data = provider.tv;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 360.h,
                backgroundColor: Colors.black,
                flexibleSpace: _TvPosterFlexibleSpace(
                  state: provider.tvState,
                  tv: data,
                ),
              ),
              if (provider.tvState == RequestState.Loading || isInitial)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.tvState == RequestState.Error)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _TvDetailPlaceholder(
                    title: 'TV detail error',
                    message: provider.message,
                  ),
                )
              else if (isLoaded)
                SliverToBoxAdapter(
                  child: _TvDetailContent(
                    provider: provider,
                    onRecommendationTap: (id) {
                      context.pushNamed(
                        TvRouteNames.detail,
                        pathParameters: {AppRouteParams.id: '$id'},
                      );
                    },
                  ),
                )
              else
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: SizedBox.shrink(),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleWatchlistAction(
    TvDetailState detailProvider,
    WatchlistTvState watchlistState,
  ) async {
    final watchlistNotifier = context.read<WatchlistTvCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final tv = detailProvider.tv!;
    if (watchlistState.isAddedToWatchlist) {
      await watchlistNotifier.removeFromWatchlist(tv);
    } else {
      await watchlistNotifier.addWatchlist(tv);
    }

    if (!mounted) return;

    final message = watchlistNotifier.state.watchlistMessage;
    if (message == WatchlistTvCubit.watchlistAddSuccessMessage ||
        message == WatchlistTvCubit.watchlistRemoveSuccessMessage) {
      await watchlistNotifier.fetchWatchlistTv();
      messenger.showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    showDialog<void>(
      context: navigator.context,
      builder: (context) => AlertDialog(content: Text(message)),
    );
  }
}

class _TvPosterFlexibleSpace extends StatelessWidget {
  final RequestState state;
  final TvDetail? tv;

  const _TvPosterFlexibleSpace({required this.state, required this.tv});

  @override
  Widget build(BuildContext context) {
    final title = tv?.name ?? 'TV Detail';
    final imageUrl = tv?.posterPath == null
        ? null
        : 'https://image.tmdb.org/t/p/w500${tv!.posterPath}';
    final season = tv?.numberOfSeasons;

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
                if (tv != null) ...[
                  RatingChip(rating: tv!.voteAverage),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: tv!.genres
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
                if (tv != null) ...[
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: [
                      _InfoBadge(
                        icon: Icons.movie,
                        label: season != null
                            ? '$season seasons'
                            : 'Unknown seasons',
                      ),
                      _InfoBadge(
                        icon: Icons.calendar_month_outlined,
                        label: tv!.firstAirDate.toIndonesianDate(),
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
  final String title;

  const _PosterFallback({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B1B1B),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.live_tv_rounded, color: Colors.white70, size: 56),
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

class _TvDetailContent extends StatelessWidget {
  const _TvDetailContent({
    required this.provider,
    required this.onRecommendationTap,
  });

  final TvDetailState provider;
  final ValueChanged<int> onRecommendationTap;

  @override
  Widget build(BuildContext context) {
    final tv = provider.tv!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SeasonSection(
            seasons: tv.seasons,
            selectedSeason: provider.selectedSeason,
            onSeasonTap: (season) {
              context.read<TvDetailCubit>().selectSeason(season);
              context.read<TvDetailCubit>().fetchTvSeasonDetail(
                tv.id,
                season.seasonNumber,
              );
            },
          ),
          _EpisodeSection(
            state: provider.tvSeasonState,
            episodes: provider.tvSeasonsDetails?.episodes ?? const [],
            message: provider.message,
            selectedSeason: provider.selectedSeason,
          ),
          SizedBox(height: 20.h),
          _OverviewSection(overview: tv.overview),
          SizedBox(height: 20.h),
          _RecommendationSection(
            state: provider.recommendationState,
            shows: provider.tvRecommendations,
            message: provider.message,
            onTap: onRecommendationTap,
          ),
        ],
      ),
    );
  }
}

class _SeasonSection extends StatelessWidget {
  final List<TvSeason> seasons;
  final TvSeason? selectedSeason;
  final ValueChanged<TvSeason> onSeasonTap;

  const _SeasonSection({
    required this.seasons,
    required this.selectedSeason,
    required this.onSeasonTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seasons',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12.h),
        if (seasons.isEmpty)
          Text(
            'Belum ada season.',
            style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: seasons
                  .map(
                    (season) => Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: SeasonButtonPill(
                        season: season,
                        isActive:
                            selectedSeason?.seasonNumber == season.seasonNumber,
                        onTap: onSeasonTap,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _EpisodeSection extends StatelessWidget {
  final RequestState state;
  final List<TvSeasonEpisode> episodes;
  final String message;
  final TvSeason? selectedSeason;

  const _EpisodeSection({
    required this.state,
    required this.episodes,
    required this.message,
    required this.selectedSeason,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedSeason == null || state == RequestState.Empty) {
      return const SizedBox.shrink();
    }

    if (state == RequestState.Loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state == RequestState.Error) {
      return Text(message);
    }

    if (episodes.isEmpty) {
      return const Text('Belum ada episode.');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: episodes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final episode = episodes[index];

        return FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: kPrussianBlue.withValues(alpha: 0.88),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text('${episode.episodeNumber}'),
        );
      },
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
    required this.shows,
    required this.message,
    required this.onTap,
  });

  final RequestState state;
  final List<Tv> shows;
  final String message;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (state == RequestState.Loading) {
      child = const Center(child: CircularProgressIndicator());
    } else if (state == RequestState.Error) {
      child = Text(message);
    } else if (shows.isEmpty) {
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
          itemCount: shows.length,
          separatorBuilder: (_, __) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            final tv = shows[index];
            return _RecommendationCard(tv: tv, onTap: () => onTap(tv.id));
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
  const _RecommendationCard({required this.tv, required this.onTap});

  final Tv tv;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.white.withValues(alpha: 0.05),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.white.withValues(alpha: 0.05),
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              tv.name,
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

class _TvDetailPlaceholder extends StatelessWidget {
  final String title;
  final String message;

  const _TvDetailPlaceholder({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.white70,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
