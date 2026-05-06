import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/tv_list_cubit.dart';
import '../widgets/tv_card_list.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  const TopRatedTvPage({super.key});

  @override
  State<TopRatedTvPage> createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TvListCubit>().fetchTopRatedTvShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Shows')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvListCubit, TvListState>(
          builder: (context, data) {
            if (data.topRatedTvShowsState == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.topRatedTvShowsState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.topRatedTvShows[index];
                  return TvCard(tv);
                },
                itemCount: data.topRatedTvShows.length,
              );
            } else {
              return const Center(
                key: Key('error_message'),
                child: Text('Failed'),
              );
            }
          },
        ),
      ),
    );
  }
}
