class District {
  String? id;
  String? name;
  List<dynamic>? wards;

  District({
    required this.id,
    required this.name,
    required this.wards,
  });
  factory District.fromJson(Map<String, dynamic> parsedJson) {
    return District(
        id: parsedJson['Id'],
        name: parsedJson['Name'],
        wards: parsedJson['Wards']);
  }
}
