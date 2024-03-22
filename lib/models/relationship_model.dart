class Relationship {
  String? relationshipId;
  String? name;
  int? type;

  Relationship(
      {required this.relationshipId, required this.name, required this.type});
}

List<Relationship> relationships = [
  Relationship(relationshipId: 'RLS01', name: 'Bố', type: 0),
  Relationship(relationshipId: 'RLS02', name: 'Mẹ', type: 0),
  Relationship(relationshipId: 'RLS03', name: 'Anh', type: 0),
  Relationship(relationshipId: 'RLS04', name: 'Chị', type: 0),
  Relationship(relationshipId: 'RLS05', name: 'Người yêu', type: 1),
  Relationship(relationshipId: 'RLS06', name: 'Đối tác', type: 2),
  Relationship(relationshipId: 'RLS07', name: 'Bạn bè', type: 2),
  Relationship(relationshipId: 'RLS07', name: 'Đồng nghiệp', type: 2),
  Relationship(relationshipId: 'RLS08', name: 'Hàng xóm', type: 2),
  Relationship(relationshipId: 'RLS09', name: 'Ông', type: 0),
  Relationship(relationshipId: 'RLS10', name: 'Bà', type: 0),
];
