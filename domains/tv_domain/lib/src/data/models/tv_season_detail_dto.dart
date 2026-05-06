import 'package:tv_domain/src/domain/entities/tv_season_detail.dart';
import 'package:dependencies/dependencies.dart' show Equatable;

class TvSeasonDetailDto extends Equatable {
  TvSeasonDetailDto({
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

  factory TvSeasonDetailDto.fromJson(Map<String, dynamic> json) =>
      TvSeasonDetailDto(
        id: json['_id'],
        airDate: json['air_date'],
        episodes: List<TvSeasonEpisodeDto>.from(
          json['episodes'].map((x) => TvSeasonEpisodeDto.fromJson(x)),
        ),
        name: json['name'],
        networks: List<TvSeasonNetworkDto>.from(
          json['networks'].map((x) => TvSeasonNetworkDto.fromJson(x)),
        ),
        overview: json['overview'],
        posterPath: json['poster_path'],
        seasonNumber: json['season_number'],
        voteAverage: json['vote_average'].toDouble(),
      );

  factory TvSeasonDetailDto.fromEntity(TvSeasonDetail entity) =>
      TvSeasonDetailDto(
        id: entity.id,
        airDate: entity.airDate,
        episodes: entity.episodes
            .map((e) => TvSeasonEpisodeDto.fromEntity(e))
            .toList(),
        name: entity.name,
        networks: entity.networks
            .map((e) => TvSeasonNetworkDto.fromEntity(e))
            .toList(),
        overview: entity.overview,
        posterPath: entity.posterPath,
        seasonNumber: entity.seasonNumber,
        voteAverage: entity.voteAverage,
      );

  final String id;
  final String? airDate;
  final List<TvSeasonEpisodeDto> episodes;
  final String name;
  final List<TvSeasonNetworkDto> networks;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  Map<String, dynamic> toJson() => {
    '_id': id,
    'air_date': airDate,
    'episodes': List<dynamic>.from(episodes.map((x) => x.toJson())),
    'name': name,
    'networks': List<dynamic>.from(networks.map((x) => x.toJson())),
    'overview': overview,
    'poster_path': posterPath,
    'season_number': seasonNumber,
    'vote_average': voteAverage,
  };

  TvSeasonDetail toEntity() {
    return TvSeasonDetail(
      id: id,
      airDate: airDate,
      episodes: episodes.map((e) => e.toEntity()).toList(),
      name: name,
      networks: networks.map((e) => e.toEntity()).toList(),
      overview: overview,
      posterPath: posterPath,
      seasonNumber: seasonNumber,
      voteAverage: voteAverage,
    );
  }

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

class TvSeasonEpisodeDto extends Equatable {
  TvSeasonEpisodeDto({
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

  factory TvSeasonEpisodeDto.fromJson(Map<String, dynamic> json) =>
      TvSeasonEpisodeDto(
        airDate: json['air_date'],
        episodeNumber: json['episode_number'],
        episodeType: json['episode_type'],
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        productionCode: json['production_code'],
        runtime: json['runtime'],
        seasonNumber: json['season_number'],
        showId: json['show_id'],
        stillPath: json['still_path'],
        voteAverage: json['vote_average'].toDouble(),
        voteCount: json['vote_count'],
        crew: List<TvSeasonCrewDto>.from(
          json['crew'].map((x) => TvSeasonCrewDto.fromJson(x)),
        ),
        guestStars: List<TvSeasonGuestStarDto>.from(
          json['guest_stars'].map((x) => TvSeasonGuestStarDto.fromJson(x)),
        ),
      );

  factory TvSeasonEpisodeDto.fromEntity(TvSeasonEpisode entity) =>
      TvSeasonEpisodeDto(
        airDate: entity.airDate,
        episodeNumber: entity.episodeNumber,
        episodeType: entity.episodeType,
        id: entity.id,
        name: entity.name,
        overview: entity.overview,
        productionCode: entity.productionCode,
        runtime: entity.runtime,
        seasonNumber: entity.seasonNumber,
        showId: entity.showId,
        stillPath: entity.stillPath,
        voteAverage: entity.voteAverage,
        voteCount: entity.voteCount,
        crew: entity.crew.map((e) => TvSeasonCrewDto.fromEntity(e)).toList(),
        guestStars: entity.guestStars
            .map((e) => TvSeasonGuestStarDto.fromEntity(e))
            .toList(),
      );

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
  final List<TvSeasonCrewDto> crew;
  final List<TvSeasonGuestStarDto> guestStars;

  Map<String, dynamic> toJson() => {
    'air_date': airDate,
    'episode_number': episodeNumber,
    'episode_type': episodeType,
    'id': id,
    'name': name,
    'overview': overview,
    'production_code': productionCode,
    'runtime': runtime,
    'season_number': seasonNumber,
    'show_id': showId,
    'still_path': stillPath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'crew': List<dynamic>.from(crew.map((x) => x.toJson())),
    'guest_stars': List<dynamic>.from(guestStars.map((x) => x.toJson())),
  };

  TvSeasonEpisode toEntity() => TvSeasonEpisode(
    airDate: airDate,
    episodeNumber: episodeNumber,
    episodeType: episodeType,
    id: id,
    name: name,
    overview: overview,
    productionCode: productionCode,
    runtime: runtime,
    seasonNumber: seasonNumber,
    showId: showId,
    stillPath: stillPath,
    voteAverage: voteAverage,
    voteCount: voteCount,
    crew: crew.map((e) => e.toEntity()).toList(),
    guestStars: guestStars.map((e) => e.toEntity()).toList(),
  );

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

class TvSeasonCrewDto extends Equatable {
  TvSeasonCrewDto({
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

  factory TvSeasonCrewDto.fromJson(Map<String, dynamic> json) =>
      TvSeasonCrewDto(
        job: json['job'],
        department: json['department'],
        creditId: json['credit_id'],
        adult: json['adult'],
        gender: json['gender'],
        id: json['id'],
        knownForDepartment: json['known_for_department'],
        name: json['name'],
        originalName: json['original_name'],
        popularity: json['popularity'].toDouble(),
        profilePath: json['profile_path'],
      );

  factory TvSeasonCrewDto.fromEntity(TvSeasonCrew entity) => TvSeasonCrewDto(
    job: entity.job,
    department: entity.department,
    creditId: entity.creditId,
    adult: entity.adult,
    gender: entity.gender,
    id: entity.id,
    knownForDepartment: entity.knownForDepartment,
    name: entity.name,
    originalName: entity.originalName,
    popularity: entity.popularity,
    profilePath: entity.profilePath,
  );

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

  Map<String, dynamic> toJson() => {
    'job': job,
    'department': department,
    'credit_id': creditId,
    'adult': adult,
    'gender': gender,
    'id': id,
    'known_for_department': knownForDepartment,
    'name': name,
    'original_name': originalName,
    'popularity': popularity,
    'profile_path': profilePath,
  };

  TvSeasonCrew toEntity() => TvSeasonCrew(
    job: job,
    department: department,
    creditId: creditId,
    adult: adult,
    gender: gender,
    id: id,
    knownForDepartment: knownForDepartment,
    name: name,
    originalName: originalName,
    popularity: popularity,
    profilePath: profilePath,
  );

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

class TvSeasonGuestStarDto extends Equatable {
  TvSeasonGuestStarDto({
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

  factory TvSeasonGuestStarDto.fromJson(Map<String, dynamic> json) =>
      TvSeasonGuestStarDto(
        character: json['character'],
        creditId: json['credit_id'],
        order: json['order'],
        adult: json['adult'],
        gender: json['gender'],
        id: json['id'],
        knownForDepartment: json['known_for_department'],
        name: json['name'],
        originalName: json['original_name'],
        popularity: json['popularity'].toDouble(),
        profilePath: json['profile_path'],
      );

  factory TvSeasonGuestStarDto.fromEntity(TvSeasonGuestStar entity) =>
      TvSeasonGuestStarDto(
        character: entity.character,
        creditId: entity.creditId,
        order: entity.order,
        adult: entity.adult,
        gender: entity.gender,
        id: entity.id,
        knownForDepartment: entity.knownForDepartment,
        name: entity.name,
        originalName: entity.originalName,
        popularity: entity.popularity,
        profilePath: entity.profilePath,
      );

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

  Map<String, dynamic> toJson() => {
    'character': character,
    'credit_id': creditId,
    'order': order,
    'adult': adult,
    'gender': gender,
    'id': id,
    'known_for_department': knownForDepartment,
    'name': name,
    'original_name': originalName,
    'popularity': popularity,
    'profile_path': profilePath,
  };

  TvSeasonGuestStar toEntity() => TvSeasonGuestStar(
    character: character,
    creditId: creditId,
    order: order,
    adult: adult,
    gender: gender,
    id: id,
    knownForDepartment: knownForDepartment,
    name: name,
    originalName: originalName,
    popularity: popularity,
    profilePath: profilePath,
  );

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

class TvSeasonNetworkDto extends Equatable {
  TvSeasonNetworkDto({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory TvSeasonNetworkDto.fromJson(Map<String, dynamic> json) =>
      TvSeasonNetworkDto(
        id: json['id'],
        logoPath: json['logo_path'],
        name: json['name'],
        originCountry: json['origin_country'],
      );

  factory TvSeasonNetworkDto.fromEntity(TvSeasonNetwork entity) =>
      TvSeasonNetworkDto(
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

  TvSeasonNetwork toEntity() => TvSeasonNetwork(
    id: id,
    logoPath: logoPath,
    name: name,
    originCountry: originCountry,
  );

  @override
  List<Object?> get props => [id, logoPath, name, originCountry];
}
