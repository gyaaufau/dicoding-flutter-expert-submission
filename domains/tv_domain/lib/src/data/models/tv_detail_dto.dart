import 'package:tv_domain/src/data/models/genre_model.dart';
import 'package:tv_domain/src/domain/entities/tv_detail.dart';
import 'package:dependencies/dependencies.dart' show Equatable;

class TvDetailDto extends Equatable {
  TvDetailDto({
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

  factory TvDetailDto.fromJson(Map<String, dynamic> json) => TvDetailDto(
    adult: json['adult'],
    backdropPath: json['backdrop_path'],
    createdBy: List<TvCreatedByDto>.from(
      json['created_by'].map((x) => TvCreatedByDto.fromJson(x)),
    ),
    episodeRunTime: List<int>.from(json['episode_run_time'].map((x) => x)),
    firstAirDate: json['first_air_date'],
    genres: List<GenreModel>.from(
      json['genres'].map((x) => GenreModel.fromJson(x)),
    ),
    homepage: json['homepage'],
    id: json['id'],
    inProduction: json['in_production'],
    languages: List<String>.from(json['languages'].map((x) => x)),
    lastAirDate: json['last_air_date'],
    lastEpisodeToAir: json['last_episode_to_air'] == null
        ? null
        : TvEpisodeToAirDto.fromJson(json['last_episode_to_air']),
    name: json['name'],
    nextEpisodeToAir: json['next_episode_to_air'] == null
        ? null
        : TvEpisodeToAirDto.fromJson(json['next_episode_to_air']),
    networks: List<TvNetworkDto>.from(
      json['networks'].map((x) => TvNetworkDto.fromJson(x)),
    ),
    numberOfEpisodes: json['number_of_episodes'],
    numberOfSeasons: json['number_of_seasons'],
    originCountry: List<String>.from(json['origin_country'].map((x) => x)),
    originalLanguage: json['original_language'],
    originalName: json['original_name'],
    overview: json['overview'],
    popularity: json['popularity'].toDouble(),
    posterPath: json['poster_path'],
    productionCompanies: List<TvProductionCompanyDto>.from(
      json['production_companies'].map(
        (x) => TvProductionCompanyDto.fromJson(x),
      ),
    ),
    productionCountries: List<TvProductionCountryDto>.from(
      json['production_countries'].map(
        (x) => TvProductionCountryDto.fromJson(x),
      ),
    ),
    seasons: List<TvSeasonDto>.from(
      json['seasons'].map((x) => TvSeasonDto.fromJson(x)),
    ),
    softcore: json['softcore'],
    spokenLanguages: List<TvSpokenLanguageDto>.from(
      json['spoken_languages'].map((x) => TvSpokenLanguageDto.fromJson(x)),
    ),
    status: json['status'],
    tagline: json['tagline'],
    type: json['type'],
    voteAverage: json['vote_average'].toDouble(),
    voteCount: json['vote_count'],
  );

  factory TvDetailDto.fromEntity(TvDetail entity) => TvDetailDto(
    adult: entity.adult,
    backdropPath: entity.backdropPath,
    createdBy: entity.createdBy
        .map((e) => TvCreatedByDto.fromEntity(e))
        .toList(),
    episodeRunTime: entity.episodeRunTime,
    firstAirDate: entity.firstAirDate,
    genres: entity.genres
        .map((e) => GenreModel(id: e.id, name: e.name))
        .toList(),
    homepage: entity.homepage,
    id: entity.id,
    inProduction: entity.inProduction,
    languages: entity.languages,
    lastAirDate: entity.lastAirDate,
    lastEpisodeToAir: entity.lastEpisodeToAir == null
        ? null
        : TvEpisodeToAirDto.fromEntity(entity.lastEpisodeToAir!),
    name: entity.name,
    nextEpisodeToAir: entity.nextEpisodeToAir == null
        ? null
        : TvEpisodeToAirDto.fromEntity(entity.nextEpisodeToAir!),
    networks: entity.networks.map((e) => TvNetworkDto.fromEntity(e)).toList(),
    numberOfEpisodes: entity.numberOfEpisodes,
    numberOfSeasons: entity.numberOfSeasons,
    originCountry: entity.originCountry,
    originalLanguage: entity.originalLanguage,
    originalName: entity.originalName,
    overview: entity.overview,
    popularity: entity.popularity,
    posterPath: entity.posterPath,
    productionCompanies: entity.productionCompanies
        .map((e) => TvProductionCompanyDto.fromEntity(e))
        .toList(),
    productionCountries: entity.productionCountries
        .map((e) => TvProductionCountryDto.fromEntity(e))
        .toList(),
    seasons: entity.seasons.map((e) => TvSeasonDto.fromEntity(e)).toList(),
    softcore: entity.softcore,
    spokenLanguages: entity.spokenLanguages
        .map((e) => TvSpokenLanguageDto.fromEntity(e))
        .toList(),
    status: entity.status,
    tagline: entity.tagline,
    type: entity.type,
    voteAverage: entity.voteAverage,
    voteCount: entity.voteCount,
  );

  final bool adult;
  final String? backdropPath;
  final List<TvCreatedByDto> createdBy;
  final List<int> episodeRunTime;
  final String firstAirDate;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final String lastAirDate;
  final TvEpisodeToAirDto? lastEpisodeToAir;
  final String name;
  final TvEpisodeToAirDto? nextEpisodeToAir;
  final List<TvNetworkDto> networks;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final List<TvProductionCompanyDto> productionCompanies;
  final List<TvProductionCountryDto> productionCountries;
  final List<TvSeasonDto> seasons;
  final bool softcore;
  final List<TvSpokenLanguageDto> spokenLanguages;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'created_by': List<dynamic>.from(createdBy.map((x) => x.toJson())),
    'episode_run_time': List<dynamic>.from(episodeRunTime.map((x) => x)),
    'first_air_date': firstAirDate,
    'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
    'homepage': homepage,
    'id': id,
    'in_production': inProduction,
    'languages': List<dynamic>.from(languages.map((x) => x)),
    'last_air_date': lastAirDate,
    'last_episode_to_air': lastEpisodeToAir?.toJson(),
    'name': name,
    'next_episode_to_air': nextEpisodeToAir?.toJson(),
    'networks': List<dynamic>.from(networks.map((x) => x.toJson())),
    'number_of_episodes': numberOfEpisodes,
    'number_of_seasons': numberOfSeasons,
    'origin_country': List<dynamic>.from(originCountry.map((x) => x)),
    'original_language': originalLanguage,
    'original_name': originalName,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'production_companies': List<dynamic>.from(
      productionCompanies.map((x) => x.toJson()),
    ),
    'production_countries': List<dynamic>.from(
      productionCountries.map((x) => x.toJson()),
    ),
    'seasons': List<dynamic>.from(seasons.map((x) => x.toJson())),
    'softcore': softcore,
    'spoken_languages': List<dynamic>.from(
      spokenLanguages.map((x) => x.toJson()),
    ),
    'status': status,
    'tagline': tagline,
    'type': type,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };

  TvDetail toEntity() {
    return TvDetail(
      adult: adult,
      backdropPath: backdropPath,
      createdBy: createdBy.map((e) => e.toEntity()).toList(),
      episodeRunTime: episodeRunTime,
      firstAirDate: firstAirDate,
      genres: genres.map((e) => e.toEntity()).toList(),
      homepage: homepage,
      id: id,
      inProduction: inProduction,
      languages: languages,
      lastAirDate: lastAirDate,
      lastEpisodeToAir: lastEpisodeToAir?.toEntity(),
      name: name,
      nextEpisodeToAir: nextEpisodeToAir?.toEntity(),
      networks: networks.map((e) => e.toEntity()).toList(),
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      originCountry: originCountry,
      originalLanguage: originalLanguage,
      originalName: originalName,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      productionCompanies: productionCompanies
          .map((e) => e.toEntity())
          .toList(),
      productionCountries: productionCountries
          .map((e) => e.toEntity())
          .toList(),
      seasons: seasons.map((e) => e.toEntity()).toList(),
      softcore: softcore,
      spokenLanguages: spokenLanguages.map((e) => e.toEntity()).toList(),
      status: status,
      tagline: tagline,
      type: type,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

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

class TvCreatedByDto extends Equatable {
  TvCreatedByDto({
    required this.id,
    required this.creditId,
    required this.name,
    required this.originalName,
    required this.gender,
    required this.profilePath,
  });

  factory TvCreatedByDto.fromJson(Map<String, dynamic> json) => TvCreatedByDto(
    id: json['id'],
    creditId: json['credit_id'],
    name: json['name'],
    originalName: json['original_name'],
    gender: json['gender'],
    profilePath: json['profile_path'],
  );

  factory TvCreatedByDto.fromEntity(TvCreatedBy entity) => TvCreatedByDto(
    id: entity.id,
    creditId: entity.creditId,
    name: entity.name,
    originalName: entity.originalName,
    gender: entity.gender,
    profilePath: entity.profilePath,
  );

  final int id;
  final String creditId;
  final String name;
  final String originalName;
  final int gender;
  final String? profilePath;

  Map<String, dynamic> toJson() => {
    'id': id,
    'credit_id': creditId,
    'name': name,
    'original_name': originalName,
    'gender': gender,
    'profile_path': profilePath,
  };

  TvCreatedBy toEntity() => TvCreatedBy(
    id: id,
    creditId: creditId,
    name: name,
    originalName: originalName,
    gender: gender,
    profilePath: profilePath,
  );

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

class TvEpisodeToAirDto extends Equatable {
  TvEpisodeToAirDto({
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

  factory TvEpisodeToAirDto.fromJson(Map<String, dynamic> json) =>
      TvEpisodeToAirDto(
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        voteAverage: json['vote_average'].toDouble(),
        voteCount: json['vote_count'],
        airDate: json['air_date'],
        episodeNumber: json['episode_number'],
        episodeType: json['episode_type'],
        productionCode: json['production_code'],
        runtime: json['runtime'],
        seasonNumber: json['season_number'],
        showId: json['show_id'],
        stillPath: json['still_path'],
      );

  factory TvEpisodeToAirDto.fromEntity(TvEpisodeToAir entity) =>
      TvEpisodeToAirDto(
        id: entity.id,
        name: entity.name,
        overview: entity.overview,
        voteAverage: entity.voteAverage,
        voteCount: entity.voteCount,
        airDate: entity.airDate,
        episodeNumber: entity.episodeNumber,
        episodeType: entity.episodeType,
        productionCode: entity.productionCode,
        runtime: entity.runtime,
        seasonNumber: entity.seasonNumber,
        showId: entity.showId,
        stillPath: entity.stillPath,
      );

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'overview': overview,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'air_date': airDate,
    'episode_number': episodeNumber,
    'episode_type': episodeType,
    'production_code': productionCode,
    'runtime': runtime,
    'season_number': seasonNumber,
    'show_id': showId,
    'still_path': stillPath,
  };

  TvEpisodeToAir toEntity() => TvEpisodeToAir(
    id: id,
    name: name,
    overview: overview,
    voteAverage: voteAverage,
    voteCount: voteCount,
    airDate: airDate,
    episodeNumber: episodeNumber,
    episodeType: episodeType,
    productionCode: productionCode,
    runtime: runtime,
    seasonNumber: seasonNumber,
    showId: showId,
    stillPath: stillPath,
  );

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

class TvNetworkDto extends Equatable {
  TvNetworkDto({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory TvNetworkDto.fromJson(Map<String, dynamic> json) => TvNetworkDto(
    id: json['id'],
    logoPath: json['logo_path'],
    name: json['name'],
    originCountry: json['origin_country'],
  );

  factory TvNetworkDto.fromEntity(TvNetwork entity) => TvNetworkDto(
    id: entity.id,
    logoPath: entity.logoPath,
    name: entity.name,
    originCountry: entity.originCountry,
  );

  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  Map<String, dynamic> toJson() => {
    'id': id,
    'logo_path': logoPath,
    'name': name,
    'origin_country': originCountry,
  };

  TvNetwork toEntity() => TvNetwork(
    id: id,
    logoPath: logoPath,
    name: name,
    originCountry: originCountry,
  );

  @override
  List<Object?> get props => [id, logoPath, name, originCountry];
}

class TvProductionCompanyDto extends Equatable {
  TvProductionCompanyDto({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory TvProductionCompanyDto.fromJson(Map<String, dynamic> json) =>
      TvProductionCompanyDto(
        id: json['id'],
        logoPath: json['logo_path'],
        name: json['name'],
        originCountry: json['origin_country'],
      );

  factory TvProductionCompanyDto.fromEntity(TvProductionCompany entity) =>
      TvProductionCompanyDto(
        id: entity.id,
        logoPath: entity.logoPath,
        name: entity.name,
        originCountry: entity.originCountry,
      );

  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  Map<String, dynamic> toJson() => {
    'id': id,
    'logo_path': logoPath,
    'name': name,
    'origin_country': originCountry,
  };

  TvProductionCompany toEntity() => TvProductionCompany(
    id: id,
    logoPath: logoPath,
    name: name,
    originCountry: originCountry,
  );

  @override
  List<Object?> get props => [id, logoPath, name, originCountry];
}

class TvProductionCountryDto extends Equatable {
  TvProductionCountryDto({required this.iso31661, required this.name});

  factory TvProductionCountryDto.fromJson(Map<String, dynamic> json) =>
      TvProductionCountryDto(iso31661: json['iso_3166_1'], name: json['name']);

  factory TvProductionCountryDto.fromEntity(TvProductionCountry entity) =>
      TvProductionCountryDto(iso31661: entity.iso31661, name: entity.name);

  final String iso31661;
  final String name;

  Map<String, dynamic> toJson() => {'iso_3166_1': iso31661, 'name': name};

  TvProductionCountry toEntity() =>
      TvProductionCountry(iso31661: iso31661, name: name);

  @override
  List<Object> get props => [iso31661, name];
}

class TvSeasonDto extends Equatable {
  TvSeasonDto({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  factory TvSeasonDto.fromJson(Map<String, dynamic> json) => TvSeasonDto(
    airDate: json['air_date'],
    episodeCount: json['episode_count'],
    id: json['id'],
    name: json['name'],
    overview: json['overview'],
    posterPath: json['poster_path'],
    seasonNumber: json['season_number'],
    voteAverage: json['vote_average'].toDouble(),
  );

  factory TvSeasonDto.fromEntity(TvSeason entity) => TvSeasonDto(
    airDate: entity.airDate,
    episodeCount: entity.episodeCount,
    id: entity.id,
    name: entity.name,
    overview: entity.overview,
    posterPath: entity.posterPath,
    seasonNumber: entity.seasonNumber,
    voteAverage: entity.voteAverage,
  );

  final String? airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  Map<String, dynamic> toJson() => {
    'air_date': airDate,
    'episode_count': episodeCount,
    'id': id,
    'name': name,
    'overview': overview,
    'poster_path': posterPath,
    'season_number': seasonNumber,
    'vote_average': voteAverage,
  };

  TvSeason toEntity() => TvSeason(
    airDate: airDate,
    episodeCount: episodeCount,
    id: id,
    name: name,
    overview: overview,
    posterPath: posterPath,
    seasonNumber: seasonNumber,
    voteAverage: voteAverage,
  );

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

class TvSpokenLanguageDto extends Equatable {
  TvSpokenLanguageDto({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory TvSpokenLanguageDto.fromJson(Map<String, dynamic> json) =>
      TvSpokenLanguageDto(
        englishName: json['english_name'],
        iso6391: json['iso_639_1'],
        name: json['name'],
      );

  factory TvSpokenLanguageDto.fromEntity(TvSpokenLanguage entity) =>
      TvSpokenLanguageDto(
        englishName: entity.englishName,
        iso6391: entity.iso6391,
        name: entity.name,
      );

  final String englishName;
  final String iso6391;
  final String name;

  Map<String, dynamic> toJson() => {
    'english_name': englishName,
    'iso_639_1': iso6391,
    'name': name,
  };

  TvSpokenLanguage toEntity() =>
      TvSpokenLanguage(englishName: englishName, iso6391: iso6391, name: name);

  @override
  List<Object> get props => [englishName, iso6391, name];
}
