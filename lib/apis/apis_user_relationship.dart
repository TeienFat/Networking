import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class APIsUsRe {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static Future<void> createNewUsRe(String meId, String myReId) async {
    final SharedPreferences _prefs = await prefs;
    final newUsRe = UserRelationship(
        usReId: uuid.v4(),
        meId: meId,
        myRelationShipId: myReId,
        special: false,
        relationships: [],
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

  static Future<List<Users>> getAllMyRelationship() async {
    final SharedPreferences _prefs = await prefs;
    final myId = await APIsAuth.getCurrentUserId();
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    var listMyRelationship = listUsReRead
        .where((element) =>
            UserRelationship.fromMap(jsonDecode(element)).meId == myId)
        .toList() // lọc ra những relationship của mình
        .map((e) => UserRelationship.fromMap(jsonDecode(e)).myRelationShipId!)
        .toList() // lấy relationshipId
        .map((e) async => await APIsUser.getUserFromId(e))
        .toList(); // từ id đó get user
    List<Users> listUser = []; // chuyển từ List<Future<Users?>> => List<Users>
    for (var relationship in listMyRelationship) {
      Users? users = await relationship;
      if (users != null) {
        listUser.add(users);
      }
    }
    return listUser;
  }
}
