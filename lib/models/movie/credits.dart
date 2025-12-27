import 'package:horate/models/movie/cast.dart';
import 'package:horate/models/movie/crew.dart';

class Credits {
  final List<Cast> cast;
  final List<Crew> crew;

  Credits({required this.cast, required this.crew});

  factory Credits.fromJson(Map<String, dynamic> json) {
    return Credits(
      cast: (json['cast'] as List<dynamic>? ?? [])
          .map((e) => Cast.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: (json['crew'] as List<dynamic>? ?? [])
          .map((e) => Crew.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String get director {
    for (final c in crew) {
      if (c.job.toLowerCase() == 'director') return c.name;
    }
    return '-';
  }

  String get topCast {
    final names = cast.take(6).map((e) => e.name).toList();
    return names.isEmpty ? '-' : names.join(', ');
  }
}