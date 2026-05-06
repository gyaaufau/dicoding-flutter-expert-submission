import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/movie_search_cubit.dart';
import '../widgets/movie_card_list.dart';

class SearchMoviePage extends StatelessWidget {
  const SearchMoviePage({super.key});

  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Movie')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<MovieSearchCubit>().fetchMovieSearch(query);
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<MovieSearchCubit, MovieSearchState>(
              builder: (context, data) {
                if (data.state == RequestState.Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (data.state == RequestState.Loaded) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: data.searchResult.length,
                      itemBuilder: (context, index) =>
                          MovieCard(data.searchResult[index]),
                    ),
                  );
                } else {
                  return const Expanded(child: SizedBox.shrink());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
