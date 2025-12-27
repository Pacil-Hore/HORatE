class Videos {
  final List<TmdbVideoItem> results;

  Videos({required this.results});

  factory Videos.fromJson(Map<String, dynamic> json) {
    return Videos(
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => TmdbVideoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// ambil trailer YouTube pertama (Trailer -> Teaser -> first YouTube)
  TmdbVideoItem? get firstTrailer {
    // 1) Trailer YouTube
    for (final v in results) {
      if (v.siteLower == 'youtube' && v.typeLower == 'trailer' && v.key.isNotEmpty) {
        return v;
      }
    }

    // 2) Teaser YouTube
    for (final v in results) {
      if (v.siteLower == 'youtube' && v.typeLower == 'teaser' && v.key.isNotEmpty) {
        return v;
      }
    }

    // 3) video YouTube pertama
    for (final v in results) {
      if (v.siteLower == 'youtube' && v.key.isNotEmpty) return v;
    }

    return null;
  }
}

class TmdbVideoItem {
  final String name;
  final String key; // YouTube key
  final String site;
  final String type;

  TmdbVideoItem({
    required this.name,
    required this.key,
    required this.site,
    required this.type,
  });

  factory TmdbVideoItem.fromJson(Map<String, dynamic> json) {
    return TmdbVideoItem(
      name: (json['name'] ?? '') as String,
      key: (json['key'] ?? '') as String,
      site: (json['site'] ?? '') as String,
      type: (json['type'] ?? '') as String,
    );
  }

  String get siteLower => site.toLowerCase();
  String get typeLower => type.toLowerCase();

  String? get youtubeUrl =>
      siteLower == 'youtube' && key.isNotEmpty ? 'https://www.youtube.com/watch?v=$key' : null;
}
