import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  const WatchlistMoviesPage({super.key});

  @override
  State<WatchlistMoviesPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware, SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(_refreshWatchlists);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _refreshWatchlists();
  }

  void _refreshWatchlists() {
    context.read<WatchlistMovieCubit>().fetchWatchlistMovies();
    context.read<WatchlistTvCubit>().fetchWatchlistTv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Movies'),
            Tab(text: 'TV'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: TabBarView(
          controller: _tabController,
          children: const [_MovieWatchlistTab(), _TvWatchlistTab()],
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tabController.dispose();
    super.dispose();
  }
}

class _MovieWatchlistTab extends StatelessWidget {
  const _MovieWatchlistTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistMovieCubit, WatchlistMovieState>(
      builder: (context, data) {
        if (data.watchlistState == RequestState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (data.watchlistState == RequestState.Loaded) {
          if (data.watchlistMovies.isEmpty) {
            return const Center(child: Text('Watchlist movie masih kosong'));
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = data.watchlistMovies[index];
              return MovieCard(movie);
            },
            itemCount: data.watchlistMovies.length,
          );
        } else {
          return Center(
            key: const Key('error_message_movie'),
            child: Text(data.message),
          );
        }
      },
    );
  }
}

class _TvWatchlistTab extends StatelessWidget {
  const _TvWatchlistTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistTvCubit, WatchlistTvState>(
      builder: (context, data) {
        if (data.watchlistState == RequestState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (data.watchlistState == RequestState.Loaded) {
          if (data.watchlistTv.isEmpty) {
            return const Center(child: Text('Watchlist TV masih kosong'));
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              final tv = data.watchlistTv[index];
              return TvCard(tv);
            },
            itemCount: data.watchlistTv.length,
          );
        } else {
          return Center(
            key: const Key('error_message_tv'),
            child: Text(data.message),
          );
        }
      },
    );
  }
}
