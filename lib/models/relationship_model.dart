import 'dart:convert';

class Relationship {
  String? relationshipId;
  String? name;
  int? type;

  Relationship(
      {required this.relationshipId, required this.name, required this.type});

  Relationship.fromMap(Map<String, dynamic> map) {
    relationshipId = map['relationshipId'];
    name = map['name'];
    type = map['type'];
  }
  Map<String, dynamic> toMap() {
    return ({
      "relationshipId": relationshipId,
      "name": name,
      "type": type,
    });
  }

  static String encode(List<Relationship> accounts) => json.encode(
        accounts
            .map<Map<String, dynamic>>((account) => account.toMap())
            .toList(),
      );

  static List<Relationship> decode(String accounts) =>
      (json.decode(accounts) as List<dynamic>)
          .map<Relationship>((item) => Relationship.fromMap(item))
          .toList();
}

// List<Relationship> relationships = [
//   Relationship(relationshipId: 'RLS01', name: 'Cha', type: 0),
//   Relationship(relationshipId: 'RLS02', name: 'Mẹ', type: 0),
//   Relationship(relationshipId: 'RLS03', name: 'Anh', type: 0),
//   Relationship(relationshipId: 'RLS04', name: 'Chị', type: 0),
//   Relationship(relationshipId: 'RLS05', name: 'Em', type: 0),
//   Relationship(relationshipId: 'RLS06', name: 'Ông', type: 0),
//   Relationship(relationshipId: 'RLS07', name: 'Bà', type: 0),
//   Relationship(relationshipId: 'RLS08', name: 'Chú', type: 0),
//   Relationship(relationshipId: 'RLS09', name: 'Bác', type: 0),
//   Relationship(relationshipId: 'RLS10', name: 'Cậu', type: 0),
//   Relationship(relationshipId: 'RLS11', name: 'Cô', type: 0),
//   Relationship(relationshipId: 'RLS12', name: 'Dì', type: 0),
//   Relationship(relationshipId: 'RLS13', name: 'Con', type: 0),
//   Relationship(relationshipId: 'RLS14', name: 'Cháu', type: 0),
//   Relationship(relationshipId: 'RLS15', name: 'Mợ', type: 0),
//   Relationship(relationshipId: 'RLS16', name: 'Người yêu', type: 1),
//   Relationship(relationshipId: 'RLS17', name: 'Vợ', type: 1),
//   Relationship(relationshipId: 'RLS18', name: 'Chồng', type: 1),
//   Relationship(relationshipId: 'RLS19', name: 'Đối tác', type: 2),
//   Relationship(relationshipId: 'RLS20', name: 'Bạn thân', type: 3),
//   Relationship(relationshipId: 'RLS21', name: 'Đồng nghiệp', type: 2),
//   Relationship(relationshipId: 'RLS22', name: 'Cấp trên', type: 2),
//   Relationship(relationshipId: 'RLS23', name: 'Trưởng phòng', type: 2),
//   Relationship(relationshipId: 'RLS24', name: 'Quản lý', type: 2),
//   Relationship(relationshipId: 'RLS25', name: 'Hàng xóm', type: 3),
//   Relationship(relationshipId: 'RLS26', name: 'Thầy', type: 4),
//   Relationship(relationshipId: 'RLS27', name: 'Cô', type: 4),
// ];

// Relationship? getRelationshipFromId(String id) {
//   for (var relationship in relationships) {
//     if (relationship.relationshipId!.length == id.length &&
//         relationship.relationshipId! == id) return relationship;
//   }
//   return null;
// }

// void addNewRelationship(String name, int type) {
//   int num = relationships.length + 1;
//   String id = "RLS" + num.toString();
//   print(id);
//   Relationship newRe = Relationship(relationshipId: id, name: name, type: type);
//   relationships.add(newRe);
// }
