import 'package:dependencies/dependencies.dart' show Equatable;

class TvSeasonDetail extends Equatable {
  TvSeasonDetail({
    required this.id,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.networks,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  final String id;
  final String? airDate;
  final List<TvSeasonEpisode> episodes;
  final String name;
  final List<TvSeasonNetwork> networks;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  @override
  List<Object?> get props => [
    id,
    airDate,
    episodes,
    name,
    networks,
    overview,
    posterPath,
    seasonNumber,
    voteAverage,
  ];
}

class TvSeasonEpisode extends Equatable {
  TvSeasonEpisode({
    required this.airDate,
    required this.episodeNumber,
    required this.episodeType,
    required this.id,
    required this.name,
    required this.overview,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
    required this.crew,
    required this.guestStars,
  });

  final String? airDate;
  final int episodeNumber;
  final String episodeType;
  final int id;
  final String name;
  final String overview;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;
  final List<TvSeasonCrew> crew;
  final List<TvSeasonGuestStar> guestStars;

  @override
  List<Object?> get props => [
    airDate,
    episodeNumber,
    episodeType,
    id,
    name,
    overview,
    productionCode,
    runtime,
    seasonNumber,
    showId,
    stillPath,
    voteAverage,
    voteCount,
    crew,
    guestStars,
  ];
}

class TvSeasonCrew extends Equatable {
  TvSeasonCrew({
    required this.job,
    required this.department,
    required this.creditId,
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
  });

  final String job;
  final String department;
  final String creditId;
  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;

  @override
  List<Object?> get props => [
    job,
    department,
    creditId,
    adult,
    gender,
    id,
    knownForDepartment,
    name,
    originalName,
    popularity,
    profilePath,
  ];
}

class TvSeasonGuestStar extends Equatable {
  TvSeasonGuestStar({
    required this.character,
    required this.creditId,
    required this.order,
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
  });

  final String character;
  final String creditId;
  final int order;
  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;

  @override
  List<Object?> get props => [
    character,
    creditId,
    order,
    adult,
    gender,
    id,
    knownForDepartment,
    name,
    originalName,
    popularity,
    profilePath,
  ];
}

class TvSeasonNetwork extends Equatable {
  TvSeasonNetwork({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  @override
  List<Object?> get props => [id, logoPath, name, originCountry];
}
