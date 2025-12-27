class CreatedBy {
  final int id;
  final String creditId;
  final String name;
  final String originalName;
  final int gender;
  final String? profilePath;

  CreatedBy({
    required this.id,
    required this.creditId,
    required this.name,
    required this.originalName,
    required this.gender,
    required this.profilePath,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: (json['id'] ?? 0) as int,
    creditId: (json['credit_id'] ?? '') as String,
    name: (json['name'] ?? '') as String,
    originalName: (json['original_name'] ?? '') as String,
    gender: (json['gender'] ?? 0) as int,
    profilePath: json['profile_path'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'credit_id': creditId,
    'name': name,
    'original_name': originalName,
    'gender': gender,
    'profile_path': profilePath,
  };

  String? profileUrl({String size = 'w185'}) {
    if (profilePath == null || profilePath!.isEmpty) return null;
    return 'https://image.tmdb.org/t/p/$size$profilePath';
  }
}