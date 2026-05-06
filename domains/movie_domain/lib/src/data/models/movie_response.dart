import 'package:core/core.dart';

import 'movie_model.dart';

class MovieResponse extends PagedResponseDto<MovieModel> {
  const MovieResponse({
    required List<MovieModel> movieList,
    int page = 1,
    int totalPages = 1,
    int? totalResults,
  }) : super(
         page: page,
         results: movieList,
         totalPages: totalPages,
         totalResults: totalResults ?? movieList.length,
       );

  List<MovieModel> get movieList => results;

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    final response = PagedResponseDto<MovieModel>.fromJson(
      json,
      MovieModel.fromJson,
      where: (item) => item.posterPath != null,
    );

    return MovieResponse(
      movieList: response.results,
      page: response.page,
      totalPages: response.totalPages,
      totalResults: response.totalResults,
    );
  }

  Map<String, dynamic> toJson() => {
    'results': List<dynamic>.from(movieList.map((item) => item.toJson())),
  };

  @override
  List<Object> get props => [movieList];
}
