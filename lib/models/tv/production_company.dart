class ProductionCompany {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      ProductionCompany(
        id: (json['id'] ?? 0) as int,
        logoPath: json['logo_path'] as String?,
        name: (json['name'] ?? '') as String,
        originCountry: (json['origin_country'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'logo_path': logoPath,
    'name': name,
    'origin_country': originCountry,
  };

  String? logoUrl({String size = 'w185'}) {
    if (logoPath == null || logoPath!.isEmpty) return null;
    return 'https://image.tmdb.org/t/p/$size$logoPath';
  }
}