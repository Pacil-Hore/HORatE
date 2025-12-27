class Season {
  final String airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  Season({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  factory Season.fromJson(Map<String, dynamic> json) => Season(
    airDate: (json['air_date'] ?? '') as String,
    episodeCount: (json['episode_count'] ?? 0) as int,
    id: (json['id'] ?? 0) as int,
    name: (json['name'] ?? '') as String,
    overview: (json['overview'] ?? '') as String,
    posterPath: json['poster_path'] as String?,
    seasonNumber: (json['season_number'] ?? 0) as int,
    voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
  );

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

  String? posterUrl({String size = 'w342'}) {
    if (posterPath == null || posterPath!.isEmpty) return null;
    return 'https://image.tmdb.org/t/p/$size$posterPath';
  }
}