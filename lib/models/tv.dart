import 'dart:convert';

import 'package:horate/models/videos.dart';
import 'package:horate/models/genre.dart';
import 'package:horate/models/tv/created_by.dart';
import 'package:horate/models/tv/tv_episode.dart';
import 'package:horate/models/tv/production_company.dart';
import 'package:horate/models/tv/production_country.dart';
import 'package:horate/models/tv/network.dart';
import 'package:horate/models/tv/season.dart';
import 'package:horate/models/tv/spoken_language.dart';

TmdbTvDetail tmdbTvDetailFromJson(String str) =>
    TmdbTvDetail.fromJson(json.decode(str) as Map<String, dynamic>);

String tmdbTvDetailToJson(TmdbTvDetail data) => json.encode(data.toJson());

class TmdbTvDetail {
  final bool adult;
  final String? backdropPath;

  final List<CreatedBy> createdBy;
  final List<int> episodeRunTime;

  final String firstAirDate;
  final List<Genre> genres;

  final String? homepage;

  final int id;

  final bool inProduction;
  final List<String> languages;

  final String lastAirDate;

  final TvEpisode? lastEpisodeToAir;
  final String name;
  final TvEpisode? nextEpisodeToAir;

  final List<Network> networks;

  final int numberOfEpisodes;
  final int numberOfSeasons;

  final List<String> originCountry;

  final String originalLanguage;
  final String originalName;

  final String overview;
  final double popularity;

  final String? posterPath;

  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;

  final List<Season> seasons;

  final List<SpokenLanguage> spokenLanguages;

  final String status;
  final String tagline;
  final String type;

  final double voteAverage;
  final int voteCount;

  final Videos? videos;

  TmdbTvDetail({
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
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
    required this.videos,
  });

  factory TmdbTvDetail.fromJson(Map<String, dynamic> json) {
    final homepageRaw = json['homepage'];

    return TmdbTvDetail(
      adult: (json['adult'] ?? false) as bool,
      backdropPath: json['backdrop_path'] as String?,

      createdBy: (json['created_by'] as List? ?? [])
          .map((e) => CreatedBy.fromJson(e as Map<String, dynamic>))
          .toList(),

      episodeRunTime: (json['episode_run_time'] as List? ?? [])
          .whereType<num>()
          .map((e) => e.toInt())
          .toList(),

      firstAirDate: (json['first_air_date'] ?? '') as String,

      genres: (json['genres'] as List? ?? [])
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),

      homepage: (homepageRaw is String && homepageRaw.trim().isNotEmpty)
          ? homepageRaw.trim()
          : null,

      id: (json['id'] ?? 0) as int,

      inProduction: (json['in_production'] ?? false) as bool,

      languages: (json['languages'] as List? ?? [])
          .whereType<String>()
          .toList(),

      lastAirDate: (json['last_air_date'] ?? '') as String,

      lastEpisodeToAir: json['last_episode_to_air'] == null
          ? null
          : TvEpisode.fromJson(
        json['last_episode_to_air'] as Map<String, dynamic>,
      ),

      name: (json['name'] ?? '') as String,

      nextEpisodeToAir: json['next_episode_to_air'] == null
          ? null
          : TvEpisode.fromJson(
        json['next_episode_to_air'] as Map<String, dynamic>,
      ),

      networks: (json['networks'] as List? ?? [])
          .map((e) => Network.fromJson(e as Map<String, dynamic>))
          .toList(),

      numberOfEpisodes: (json['number_of_episodes'] ?? 0) as int,
      numberOfSeasons: (json['number_of_seasons'] ?? 0) as int,

      originCountry: (json['origin_country'] as List? ?? [])
          .whereType<String>()
          .toList(),

      originalLanguage: (json['original_language'] ?? '') as String,
      originalName: (json['original_name'] ?? '') as String,

      overview: (json['overview'] ?? '') as String,

      popularity: (json['popularity'] as num? ?? 0).toDouble(),

      posterPath: json['poster_path'] as String?,

      productionCompanies: (json['production_companies'] as List? ?? [])
          .map((e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
          .toList(),

      productionCountries: (json['production_countries'] as List? ?? [])
          .map((e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
          .toList(),

      seasons: (json['seasons'] as List? ?? [])
          .map((e) => Season.fromJson(e as Map<String, dynamic>))
          .toList(),

      spokenLanguages: (json['spoken_languages'] as List? ?? [])
          .map((e) => SpokenLanguage.fromJson(e as Map<String, dynamic>))
          .toList(),

      status: (json['status'] ?? '') as String,
      tagline: (json['tagline'] ?? '') as String,
      type: (json['type'] ?? '') as String,

      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      voteCount: (json['vote_count'] ?? 0) as int,

      videos: json['videos'] == null
          ? null
          : Videos.fromJson(json['videos'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'created_by': createdBy.map((e) => e.toJson()).toList(),
    'episode_run_time': episodeRunTime,
    'first_air_date': firstAirDate,
    'genres': genres.map((e) => e.toJson()).toList(),
    'homepage': homepage,
    'id': id,
    'in_production': inProduction,
    'languages': languages,
    'last_air_date': lastAirDate,
    'last_episode_to_air': lastEpisodeToAir?.toJson(),
    'name': name,
    'next_episode_to_air': nextEpisodeToAir?.toJson(),
    'networks': networks.map((e) => e.toJson()).toList(),
    'number_of_episodes': numberOfEpisodes,
    'number_of_seasons': numberOfSeasons,
    'origin_country': originCountry,
    'original_language': originalLanguage,
    'original_name': originalName,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'production_companies': productionCompanies.map((e) => e.toJson()).toList(),
    'production_countries': productionCountries.map((e) => e.toJson()).toList(),
    'seasons': seasons.map((e) => e.toJson()).toList(),
    'spoken_languages': spokenLanguages.map((e) => e.toJson()).toList(),
    'status': status,
    'tagline': tagline,
    'type': type,
    'vote_average': voteAverage,
    'vote_count': voteCount,

    // minimal videos serialize (optional)
    'videos': videos == null
        ? null
        : {
      'results': videos!.results
          .map((v) => {
        'name': v.name,
        'key': v.key,
        'site': v.site,
        'type': v.type,
      })
          .toList(),
    },
  };

  // ===== Helpers untuk UI =====
  String get year => firstAirDate.isNotEmpty && firstAirDate.length >= 4
      ? firstAirDate.substring(0, 4)
      : '-';

  String get runtimeText {
    if (episodeRunTime.isEmpty) return '-';
    return '${episodeRunTime.first}m/ep';
  }

  String? posterUrl({String size = 'w500'}) {
    if (posterPath == null || posterPath!.isEmpty) return null;
    return 'https://image.tmdb.org/t/p/$size$posterPath';
  }

  String? backdropUrl({String size = 'w780'}) {
    if (backdropPath == null || backdropPath!.isEmpty) return null;
    return 'https://image.tmdb.org/t/p/$size$backdropPath';
  }

  // helper homepage biar gampang
  bool get hasHomepage {
    final u = homepage;
    if (u == null) return false;
    final uri = Uri.tryParse(u);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }
}