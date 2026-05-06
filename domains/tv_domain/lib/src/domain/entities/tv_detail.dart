import 'package:tv_domain/src/domain/entities/genre.dart';
import 'package:dependencies/dependencies.dart' show Equatable;

class TvDetail extends Equatable {
  TvDetail({
    required this.adult,
    required this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.name,
    required this.nextEpisodeToAir,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.seasons,
    required this.softcore,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String? backdropPath;
  final List<TvCreatedBy> createdBy;
  final List<int> episodeRunTime;
  final String firstAirDate;
  final List<Genre> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final String lastAirDate;
  final TvEpisodeToAir? lastEpisodeToAir;
  final String name;
  final TvEpisodeToAir? nextEpisodeToAir;
  final List<TvNetwork> networks;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final List<TvProductionCompany> productionCompanies;
  final List<TvProductionCountry> productionCountries;
  final List<TvSeason> seasons;
  final bool softcore;
  final List<TvSpokenLanguage> spokenLanguages;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    createdBy,
    episodeRunTime,
    firstAirDate,
    genres,
    homepage,
    id,
    inProduction,
    languages,
    lastAirDate,
    lastEpisodeToAir,
    name,
    nextEpisodeToAir,
    networks,
    numberOfEpisodes,
    numberOfSeasons,
    originCountry,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    productionCompanies,
    productionCountries,
    seasons,
    softcore,
    spokenLanguages,
    status,
    tagline,
    type,
    voteAverage,
    voteCount,
  ];
}

class TvCreatedBy extends Equatable {
  TvCreatedBy({
    required this.id,
    required this.creditId,
    required this.name,
    required this.originalName,
    required this.gender,
    required this.profilePath,
  });

  final int id;
  final String creditId;
  final String name;
  final String originalName;
  final int gender;
  final String? profilePath;

  @override
  List<Object?> get props => [
    id,
    creditId,
    name,
    originalName,
    gender,
    profilePath,
  ];
}

class TvEpisodeToAir extends Equatable {
  TvEpisodeToAir({
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.airDate,
    required this.episodeNumber,
    required this.episodeType,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
  });

  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String airDate;
  final int episodeNumber;
  final String episodeType;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;

  @override
  List<Object?> get props => [
    id,
    name,
    overview,
    voteAverage,
    voteCount,
    airDate,
    episodeNumber,
    episodeType,
    productionCode,
    runtime,
    seasonNumber,
    showId,
    stillPath,
  ];
}

class TvNetwork extends Equatable {
  TvNetwork({
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

class TvProductionCompany extends Equatable {
  TvProductionCompany({
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

class TvProductionCountry extends Equatable {
  TvProductionCountry({required this.iso31661, required this.name});

  final String iso31661;
  final String name;

  @override
  List<Object> get props => [iso31661, name];
}

class TvSeason extends Equatable {
  TvSeason({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  final String? airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  @override
  List<Object?> get props => [
    airDate,
    episodeCount,
    id,
    name,
    overview,
    posterPath,
    seasonNumber,
    voteAverage,
  ];
}

class TvSpokenLanguage extends Equatable {
  TvSpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  final String englishName;
  final String iso6391;
  final String name;

  @override
  List<Object> get props => [englishName, iso6391, name];
}
