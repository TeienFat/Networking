import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:networking/models/relationship_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class APIsRelationship {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static Future<void> addListDefaut() async {
    final SharedPreferences _prefs = await prefs;
    List<Relationship> relationships = [
      Relationship(relationshipId: 'RLS01', name: 'Cha', type: 0),
      Relationship(relationshipId: 'RLS02', name: 'Mẹ', type: 0),
      Relationship(relationshipId: 'RLS03', name: 'Anh', type: 0),
      Relationship(relationshipId: 'RLS04', name: 'Chị', type: 0),
      Relationship(relationshipId: 'RLS05', name: 'Em', type: 0),
      Relationship(relationshipId: 'RLS06', name: 'Ông', type: 0),
      Relationship(relationshipId: 'RLS07', name: 'Bà', type: 0),
      Relationship(relationshipId: 'RLS08', name: 'Chú', type: 0),
      Relationship(relationshipId: 'RLS09', name: 'Bác', type: 0),
      Relationship(relationshipId: 'RLS10', name: 'Cậu', type: 0),
      Relationship(relationshipId: 'RLS11', name: 'Cô', type: 0),
      Relationship(relationshipId: 'RLS12', name: 'Dì', type: 0),
      Relationship(relationshipId: 'RLS13', name: 'Con', type: 0),
      Relationship(relationshipId: 'RLS14', name: 'Cháu', type: 0),
      Relationship(relationshipId: 'RLS15', name: 'Mợ', type: 0),
      Relationship(relationshipId: 'RLS16', name: 'Người yêu', type: 1),
      Relationship(relationshipId: 'RLS17', name: 'Vợ', type: 1),
      Relationship(relationshipId: 'RLS18', name: 'Chồng', type: 1),
      Relationship(relationshipId: 'RLS19', name: 'Đối tác', type: 2),
      Relationship(relationshipId: 'RLS20', name: 'Bạn thân', type: 3),
      Relationship(relationshipId: 'RLS21', name: 'Đồng nghiệp', type: 2),
      Relationship(relationshipId: 'RLS22', name: 'Cấp trên', type: 2),
      Relationship(relationshipId: 'RLS23', name: 'Trưởng phòng', type: 2),
      Relationship(relationshipId: 'RLS24', name: 'Quản lý', type: 2),
      Relationship(relationshipId: 'RLS25', name: 'Hàng xóm', type: 3),
      Relationship(relationshipId: 'RLS26', name: 'Thầy', type: 4),
      Relationship(relationshipId: 'RLS27', name: 'Cô', type: 4),
    ];
    await _prefs.setStringList('relationships',
        relationships.map((e) => jsonEncode(e.toMap())).toList());
  }

  static Future<List<Relationship>> getAllRelationship() async {
    final SharedPreferences _prefs = await prefs;
    List<String> listReRead = await _prefs.getStringList('relationships') ?? [];
    var listRelationship =
        listReRead.map((e) => Relationship.fromMap(jsonDecode(e))).toList();
    return listRelationship;
  }

  static Future<Relationship?> getRelationshipFromId(String id) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listReRead = await _prefs.getStringList('relationships') ?? [];

    for (var relationship in listReRead) {
      Relationship re = Relationship.fromMap(jsonDecode(relationship));
      if (re.relationshipId!.length == id.length && re.relationshipId! == id)
        return re;
    }
    return null;
  }

  static Future<Relationship> createNewRelationship(
      String name, int type) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listReRead = await _prefs.getStringList('relationships') ?? [];

    int num = listReRead.length + 1;
    String id = "RLS" + num.toString();
    Relationship newRe =
        Relationship(relationshipId: id, name: name, type: type);
    listReRead.add(jsonEncode(newRe.toMap()));
    await _prefs.setStringList('relationships', listReRead);
    return newRe;
  }
}
