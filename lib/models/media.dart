import 'dart:convert';

TmdbDiscoverResponse tmdbDiscoverResponseFromJson(String str) =>
    TmdbDiscoverResponse.fromJson(json.decode(str));

class TmdbDiscoverResponse {
  final int page;
  final List<TmdbMediaItem> results;
  final int totalPages;
  final int totalResults;

  TmdbDiscoverResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TmdbDiscoverResponse.fromJson(Map<String, dynamic> json) {
    return TmdbDiscoverResponse(
      page: (json['page'] ?? 1) as int,
      results: (json['results'] as List? ?? [])
          .map((e) => TmdbMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] ?? 1) as int,
      totalResults: (json['total_results'] ?? 0) as int,
    );
  }
}

class TmdbMediaItem {
  final int id;

  /// Movie: title | TV: name
  final String title;

  /// Movie: original_title | TV: original_name
  final String originalTitle;

  final String overview;
  final String posterPath;
  final String backdropPath;

  /// Movie: release_date | TV: first_air_date
  final String releaseDate;

  final double voteAverage;
  final int voteCount;

  /// Movie/TV: genre_ids
  final List<int> genreIds;

  /// TV only (optional)
  final List<String> originCountry;

  TmdbMediaItem({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.originCountry,
  });

  factory TmdbMediaItem.fromJson(Map<String, dynamic> json) {
    // movie fields
    final movieTitle = (json['title'] ?? '') as String;
    final movieOriginal = (json['original_title'] ?? '') as String;
    final movieDate = (json['release_date'] ?? '') as String;

    // tv fields
    final tvTitle = (json['name'] ?? '') as String;
    final tvOriginal = (json['original_name'] ?? '') as String;
    final tvDate = (json['first_air_date'] ?? '') as String;

    final title = movieTitle.isNotEmpty ? movieTitle : tvTitle;
    final originalTitle = movieOriginal.isNotEmpty ? movieOriginal : tvOriginal;
    final releaseDate = movieDate.isNotEmpty ? movieDate : tvDate;

    final genreRaw = json['genre_ids'];
    final genreIds = (genreRaw is List)
        ? genreRaw.whereType<num>().map((e) => e.toInt()).toList()
        : <int>[];

    final originRaw = json['origin_country'];
    final originCountry = (originRaw is List)
        ? originRaw.whereType<String>().toList()
        : <String>[];

    return TmdbMediaItem(
      id: (json['id'] ?? 0) as int,
      title: title,
      originalTitle: originalTitle,
      overview: (json['overview'] ?? '') as String,
      posterPath: (json['poster_path'] ?? '') as String,
      backdropPath: (json['backdrop_path'] ?? '') as String,
      releaseDate: releaseDate,
      voteAverage: (json['vote_average'] ?? 0.0) is int
          ? ((json['vote_average'] ?? 0) as int).toDouble()
          : ((json['vote_average'] ?? 0.0) as num).toDouble(),
      voteCount: (json['vote_count'] ?? 0) as int,
      genreIds: genreIds,
      originCountry: originCountry,
    );
  }

  String get year {
    if (releaseDate.isEmpty) return '-';
    return releaseDate.length >= 4 ? releaseDate.substring(0, 4) : releaseDate;
  }

  String? posterUrl({String size = 'w500'}) {
    if (posterPath.isEmpty) return null;
    return 'https://image.tmdb.org/t/p/$size$posterPath';
  }

  String? backdropUrl({String size = 'w780'}) {
    if (backdropPath.isEmpty) return null;
    return 'https://image.tmdb.org/t/p/$size$backdropPath';
  }
}