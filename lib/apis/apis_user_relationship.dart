import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/models/relationship_model.dart';

import 'package:networking/models/user_relationship_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class APIsUsRe {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static Future<void> createNewUsRe(
    String meId,
    String myReId,
    List<Relationship> relationships,
  ) async {
    final SharedPreferences _prefs = await prefs;
    final newUsRe = UserRelationship(
        usReId: uuid.v4(),
        meId: meId,
        myRelationShipId: myReId,
        special: false,
        relationships: relationships,
        notification: [],
        time_of_care: 0,
        createdAt: DateTime.now(),
        updateAt: null,
        deleteAt: null);
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    listUsReRead.add(jsonEncode(newUsRe.toMap()));
    await _prefs.setStringList('usRes', listUsReRead);
    List<String> listUser = await _prefs.getStringList('usRes') ?? [];
    print(listUser);
  }

  static Future<void> removeTable(String tableName) async {
    final SharedPreferences _prefs = await prefs;
    _prefs.remove(tableName);
  }

  static Future<List<UserRelationship>> getAllMyRelationship() async {
    final SharedPreferences _prefs = await prefs;
    final myId = await APIsAuth.getCurrentUserId();
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    var listMyRelationship = listUsReRead
        .where((element) =>
            UserRelationship.fromMap(jsonDecode(element)).meId == myId)
        .toList() // lọc ra những relationship của mình
        .map((e) => UserRelationship.fromMap(jsonDecode(e)))
        .toList();

    print(listMyRelationship.length);
    return listMyRelationship;
  }

  static Future<void> updateUsRe(
    String usReId,
    bool special,
    List<Relationship> relationships,
  ) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    for (var usRe in listUsReRead) {
      UserRelationship uR = UserRelationship.fromMap(jsonDecode(usRe));
      if ((uR.usReId!.length == usReId.length) && (uR.usReId == usReId)) {
        uR.special = special;
        uR.relationships = relationships;
        uR.updateAt = DateTime.now();
        listUsReRead.remove(usRe);
        listUsReRead.add(jsonEncode(uR.toMap()));
        await _prefs.setStringList('usRes', listUsReRead);
        return;
      }
    }
  }

  static Future<void> removeUsRe(String usReId) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    for (var usRe in listUsReRead) {
      UserRelationship uR = UserRelationship.fromMap(jsonDecode(usRe));
      if ((uR.usReId!.length == usReId.length) && (uR.usReId == usReId)) {
        listUsReRead.remove(usRe);
        await _prefs.setStringList('usRes', listUsReRead);
        return;
      }
    }
  }
}
