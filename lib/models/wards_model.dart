class Wards {
  String? id;
  String? name;
  String? level;

  Wards({
    required this.id,
    required this.name,
    required this.level,
  });
  factory Wards.fromJson(Map<String, dynamic> parsedJson) {
    return Wards(
        id: parsedJson['Id'],
        name: parsedJson['Name'],
        level: parsedJson['Level']);
  }
}
