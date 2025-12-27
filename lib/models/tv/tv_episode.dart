class TvEpisode {
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

  TvEpisode({
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

  factory TvEpisode.fromJson(Map<String, dynamic> json) => TvEpisode(
    id: (json['id'] ?? 0) as int,
    name: (json['name'] ?? '') as String,
    overview: (json['overview'] ?? '') as String,
    voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
    voteCount: (json['vote_count'] ?? 0) as int,
    airDate: (json['air_date'] ?? '') as String,
    episodeNumber: (json['episode_number'] ?? 0) as int,
    episodeType: (json['episode_type'] ?? '') as String,
    productionCode: (json['production_code'] ?? '') as String,
    runtime: (json['runtime'] as num?)?.toInt(),
    seasonNumber: (json['season_number'] ?? 0) as int,
    showId: (json['show_id'] ?? 0) as int,
    stillPath: json['still_path'] as String?,
  );

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

  String? stillUrl({String size = 'w500'}) {
    if (stillPath == null || stillPath!.isEmpty) return null;
    return 'https://image.tmdb.org/t/p/$size$stillPath';
  }
}