import 'dart:convert';

GenreResponse tmdbGenreResponseFromJson(String str) =>
    GenreResponse.fromJson(json.decode(str) as Map<String, dynamic>);

class GenreResponse {
  final List<Genre> genres;

  GenreResponse({required this.genres});

  factory GenreResponse.fromJson(Map<String, dynamic> json) {
    return GenreResponse(
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
