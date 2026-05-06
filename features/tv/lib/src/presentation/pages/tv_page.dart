import 'package:common/common.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_domain/tv_domain.dart';

import '../cubit/tv_list_cubit.dart';
import '../widgets/carousell_banner_widget.dart';
import 'popular_tv_page.dart';
import 'search_tv_page.dart';
import 'top_rated_tv_page.dart';

class TvPage extends StatefulWidget {
  const TvPage({super.key});

  static const ROUTE_NAME = '/tv';

  @override
  State<TvPage> createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TvListCubit>()
        ..fetchOnTheAirTvShows()
        ..fetchPopularTvShows()
        ..fetchTopRatedTvShows(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV'),
        actions: [
          IconButton(
            onPressed: () {
              context.push(SearchTvPage.ROUTE_NAME);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildOnTheAirSection(context: context),
              _buildPopularSection(context: context),
              _buildTopRatedSection(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnTheAirSection({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'On The Air',
              style: kHeading6.copyWith(color: kMikadoYellow),
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<TvListCubit, TvListState>(
            builder: (context, data) {
              final state = data.onTheAirTvShowsState;
              if (state == RequestState.Loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state == RequestState.Loaded) {
                return OnTheAirTvShowsList(data.onTheAirTvShows);
              } else {
                return Text('Failed');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection({required BuildContext context}) {
    return Column(
      children: [
        _buildSubHeading(
          title: 'Popular',
          onTap: () => context.push(PopularTvPage.ROUTE_NAME),
        ),
        BlocBuilder<TvListCubit, TvListState>(
          builder: (context, data) {
            final state = data.popularTvShowsState;
            if (state == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state == RequestState.Loaded) {
              return PopularTvShowsList(data.popularTvShows);
            } else {
              return const Text('Failed');
            }
          },
        ),
      ],
    );
  }

  Widget _buildTopRatedSection({required BuildContext context}) {
    return Column(
      children: [
        _buildSubHeading(
          title: 'Top Rated',
          onTap: () => context.push(TopRatedTvPage.ROUTE_NAME),
        ),
        BlocBuilder<TvListCubit, TvListState>(
          builder: (context, data) {
            final state = data.topRatedTvShowsState;
            if (state == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state == RequestState.Loaded) {
              return TopRatedTvShowsList(data.topRatedTvShows);
            } else {
              return const Text('Failed');
            }
          },
        ),
      ],
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class OnTheAirTvShowsList extends StatelessWidget {
  final List<Tv> tv;

  const OnTheAirTvShowsList(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    return CarousellBannerWidget(
      height: 220.h,
      items: tv.map((tv) {
        final imagePath = (tv.backdropPath?.isNotEmpty ?? false)
            ? tv.backdropPath!
            : (tv.posterPath ?? '');

        return CarousellBannerItem(
          title: tv.name,
          imagePath: imagePath,
          overview: tv.overview,
          rating: tv.voteAverage,
          genreLabels: tv.genreIds
              .map((id) => kTvGenres[id])
              .whereType<String>()
              .toList(),
          isTvShows: true,
          onTap: () {
            context.pushNamed('tv-detail', extra: tv.id);
          },
          onWatchNow: () {
            context.pushNamed('tv-detail', extra: tv.id);
          },
        );
      }).toList(),
    );
  }
}

class PopularTvShowsList extends StatelessWidget {
  final List<Tv> tv;

  const PopularTvShowsList(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tv.length,
        itemBuilder: (context, index) {
          final tvShow = tv[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                context.pushNamed('tv-detail', extra: tvShow.id);
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
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

class TopRatedTvShowsList extends StatelessWidget {
  final List<Tv> tv;

  const TopRatedTvShowsList(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tv.length,
        itemBuilder: (context, index) {
          final tvShow = tv[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                context.pushNamed('tv-detail', extra: tvShow.id);
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvShow.posterPath}',
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
