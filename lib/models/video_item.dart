class VideoItem {
  final String name;
  final String key; // YouTube key
  final String site;
  final String type;

  VideoItem({
    required this.name,
    required this.key,
    required this.site,
    required this.type,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      name: json['name'] ?? '',
      key: json['key'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
    );
  }

  String? get youtubeUrl =>
      site.toLowerCase() == 'youtube' && key.isNotEmpty
          ? 'https://www.youtube.com/watch?v=$key'
          : null;
}