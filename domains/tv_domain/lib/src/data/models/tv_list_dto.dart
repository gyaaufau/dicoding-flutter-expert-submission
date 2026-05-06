import 'package:tv_domain/src/domain/entities/tv.dart';
import 'package:dependencies/dependencies.dart' show Equatable;

class TvListDto extends Equatable {
  TvListDto({
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

  factory TvListDto.fromJson(Map<String, dynamic> json) => TvListDto(
    adult: json['adult'],
    backdropPath: json['backdrop_path'],
    genreIds: List<int>.from(json['genre_ids'].map((x) => x)),
    id: json['id'],
    originCountry: List<String>.from(json['origin_country'].map((x) => x)),
    originalLanguage: json['original_language'],
    originalName: json['original_name'],
    overview: json['overview'],
    popularity: json['popularity'].toDouble(),
    posterPath: json['poster_path'],
    firstAirDate: json['first_air_date'],
    softcore: json['softcore'] ?? false,
    name: json['name'],
    voteAverage: json['vote_average'].toDouble(),
    voteCount: json['vote_count'],
  );

  factory TvListDto.fromEntity(Tv entity) => TvListDto(
    adult: entity.adult,
    backdropPath: entity.backdropPath,
    genreIds: entity.genreIds,
    id: entity.id,
    originCountry: entity.originCountry,
    originalLanguage: entity.originalLanguage,
    originalName: entity.originalName,
    overview: entity.overview,
    popularity: entity.popularity,
    posterPath: entity.posterPath,
    firstAirDate: entity.firstAirDate,
    softcore: entity.softcore,
    name: entity.name,
    voteAverage: entity.voteAverage,
    voteCount: entity.voteCount,
  );

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

  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'genre_ids': List<dynamic>.from(genreIds.map((x) => x)),
    'id': id,
    'origin_country': List<dynamic>.from(originCountry.map((x) => x)),
    'original_language': originalLanguage,
    'original_name': originalName,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'first_air_date': firstAirDate,
    'softcore': softcore,
    'name': name,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };

  Tv toEntity() {
    return Tv(
      adult: adult,
      backdropPath: backdropPath,
      genreIds: genreIds,
      id: id,
      originCountry: originCountry,
      originalLanguage: originalLanguage,
      originalName: originalName,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      firstAirDate: firstAirDate,
      softcore: softcore,
      name: name,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

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
