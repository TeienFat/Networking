import 'dart:convert';

class Address {
  Map<String, dynamic>? province;
  Map<String, dynamic>? district;
  Map<String, dynamic>? wards;
  String? street;
  String? name;
  int? type;

  Address({
    required this.province,
    required this.district,
    required this.wards,
    required this.street,
    required this.name,
    required this.type,
  });
  Address.fromMap(Map<String, dynamic> map) {
    province = map['province'];
    district = map['district'];
    wards = map['wards'];
    street = map['street'];
    name = map['name'];
    type = map['type'];
  }
  Map<String, dynamic> toMap() {
    return ({
      "province": province,
      "district": district,
      "wards": wards,
      "street": street,
      "name": name,
      "type": type,
    });
  }

  static String encode(List<Address> accounts) => json.encode(
        accounts
            .map<Map<String, dynamic>>((account) => account.toMap())
            .toList(),
      );

  static List<Address> decode(String accounts) =>
      (json.decode(accounts) as List<dynamic>)
          .map<Address>((item) => Address.fromMap(item))
          .toList();
}
