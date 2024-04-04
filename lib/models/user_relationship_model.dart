import 'package:networking/models/relationship_model.dart';

class UserRelationship {
  String? usReId;
  String? meId;
  String? myRelationShipId;
  bool? special;
  List<Relationship>? relationships;
  List<dynamic>? notification;
  int? time_of_care;
  DateTime? createdAt;
  DateTime? updateAt;
  DateTime? deleteAt;

  UserRelationship({
    required this.usReId,
    required this.meId,
    required this.myRelationShipId,
    required this.special,
    required this.relationships,
    required this.notification,
    required this.time_of_care,
    required this.createdAt,
    required this.updateAt,
    required this.deleteAt,
  });

  UserRelationship.fromMap(Map<String, dynamic> map) {
    usReId = map['usReId'];
    meId = map['meId'];
    myRelationShipId = map['myRelationShipId'];
    special = map['special'];
    relationships = Relationship.decode(map['relationships']);
    notification = map['notification'];
    time_of_care = map['time_of_care'];
    createdAt = DateTime.parse(map['createdAt']);
    updateAt = map['updateAt'] != null ? DateTime.parse(map['updateAt']) : null;
    deleteAt = map['deleteAt'] != null ? DateTime.parse(map['deleteAt']) : null;
  }
  Map<String, dynamic> toMap() {
    return ({
      "usReId": usReId,
      "meId": meId,
      "myRelationShipId": myRelationShipId,
      "special": special,
      "relationships": Relationship.encode(relationships!),
      "notification": notification,
      "time_of_care": time_of_care,
      "createdAt": createdAt!.toIso8601String(),
      "updateAt": updateAt != null ? updateAt!.toIso8601String() : null,
      "deleteAt": deleteAt != null ? deleteAt!.toIso8601String() : null,
    });
  }
}
