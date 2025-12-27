class ProductionCountry {
  final String iso31661;
  final String name;

  ProductionCountry({
    required this.iso31661,
    required this.name,
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      ProductionCountry(
        iso31661: (json['iso_3166_1'] ?? '') as String,
        name: (json['name'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
    'iso_3166_1': iso31661,
    'name': name,
  };
}