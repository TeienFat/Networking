class Province {
  String? id;
  String? name;
  List<dynamic>? districts;

  Province({
    required this.id,
    required this.name,
    required this.districts,
  });
  factory Province.fromJson(Map<String, dynamic> parsedJson) {
    return Province(
        id: parsedJson['Id'],
        name: parsedJson['Name'],
        districts: parsedJson['Districts']);
  }
}
