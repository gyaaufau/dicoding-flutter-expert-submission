import 'package:dependencies/dependencies.dart' show Equatable;

class Tv extends Equatable {
  const Tv({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.softcore,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  const Tv.watchlist({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  }) : adult = false,
       backdropPath = null,
       genreIds = const [],
       originCountry = const [],
       originalLanguage = '',
       originalName = '',
       popularity = 0,
       firstAirDate = null,
       softcore = false,
       voteAverage = 0,
       voteCount = 0;

  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? firstAirDate;
  final bool softcore;
  final String name;
  final double voteAverage;
  final int voteCount;

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    genreIds,
    id,
    originCountry,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    firstAirDate,
    softcore,
    name,
    voteAverage,
    voteCount,
  ];
}
