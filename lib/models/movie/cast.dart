class Cast {
  final String name;
  final String character;

  Cast({required this.name, required this.character});

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'] ?? '',
      character: json['character'] ?? '',
    );
  }
}