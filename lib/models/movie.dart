import 'dart:convert';
import 'package:horate/models/videos.dart';
import 'package:horate/models/genre.dart';
import 'package:horate/models/movie/credits.dart';

MovieDetail tmdbMovieDetailFromJson(String str) =>
    MovieDetail.fromJson(json.decode(str) as Map<String, dynamic>);

class MovieDetail {
  final int id;
  final String title;
  final String? backdropPath;
  final String? posterPath;
  final String overview;
  final String releaseDate;
  final int? runtime; // minutes
  final double voteAverage;
  final int voteCount;
  final String? homepage;

  final List<Genre> genres;

  // appended
  final Videos? videos;
  final Credits? credits;

  MovieDetail({
    required this.id,
    required this.title,
    required this.backdropPath,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.runtime,
    required this.voteAverage,
    required this.voteCount,
    required this.homepage,
    required this.genres,
    required this.videos,
    required this.credits,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    final homepageRaw = json['homepage'];

    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'],
      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,

      // parse homepage (kadang bisa "" / null)
      homepage: (homepageRaw is String && homepageRaw.trim().isNotEmpty)
          ? homepageRaw.trim()
          : null,

      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),

      videos: json['videos'] == null
          ? null
          : Videos.fromJson(json['videos'] as Map<String, dynamic>),

      credits: json['credits'] == null
          ? null
          : Credits.fromJson(json['credits'] as Map<String, dynamic>),
    );
  }

  String? posterUrl({String size = 'w500'}) =>
      posterPath == null ? null : 'https://image.tmdb.org/t/p/$size$posterPath';

  String? backdropUrl({String size = 'w780'}) =>
      backdropPath == null ? null : 'https://image.tmdb.org/t/p/$size$backdropPath';

  String get year =>
      releaseDate.isNotEmpty && releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '-';

  String get runtimeText => runtime == null ? '-' : '${runtime}m';

  // helper biar mudah dipakai di UI
  bool get hasHomepage {
    final u = homepage;
    if (u == null) return false;
    final uri = Uri.tryParse(u);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }
}