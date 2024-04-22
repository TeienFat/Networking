import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class APIsReCare {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static Future<void> createNewReCare(RelationshipCare newReCare) async {
    final SharedPreferences _prefs = await prefs;

    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    listReCareRead.add(jsonEncode(newReCare.toMap()));
    await _prefs.setStringList('reCares', listReCareRead);
    List<String> listUser = await _prefs.getStringList('reCares') ?? [];
    print(listUser);
    print(listUser.length);
  }

  static Future<List<RelationshipCare>> getAllMyRelationshipCare() async {
    final SharedPreferences _prefs = await prefs;
    final myId = await APIsAuth.getCurrentUserId();
    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    var listMyRelationshipCare = listReCareRead
        .where((element) =>
            RelationshipCare.fromMap(jsonDecode(element)).meId == myId)
        .toList() // lọc ra những relationship care của mình
        .map((e) => RelationshipCare.fromMap(jsonDecode(e)))
        .toList();
    // for (var element in listMyRelationshipCare) {
    //   print(element.usReId);
    // }
    // print(listMyRelationshipCare.length);
    return listMyRelationshipCare;
  }

  static Future<void> addContentText(
    String reCareId,
    String contentText,
  ) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    List<RelationshipCare> listReCare = listReCareRead
        .map((e) => RelationshipCare.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listReCare.length; i++) {
      if (listReCare[i].reCareId!.length == reCareId.length &&
          listReCare[i].reCareId! == reCareId) {
        listReCare[i].contentText = contentText;
        listReCare[i].updateAt = DateTime.now();
      }
    }
    listReCareRead = listReCare.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('reCares', listReCareRead);
  }

  static Future<void> addContentImage(
    String reCareId,
    String imageUrl,
  ) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    List<RelationshipCare> listReCare = listReCareRead
        .map((e) => RelationshipCare.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listReCare.length; i++) {
      if (listReCare[i].reCareId!.length == reCareId.length &&
          listReCare[i].reCareId! == reCareId) {
        listReCare[i].contentImage!.add(imageUrl);
        listReCare[i].updateAt = DateTime.now();
      }
    }
    listReCareRead = listReCare.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('reCares', listReCareRead);
  }

  static Future<void> removeContentImage(
    String reCareId,
    String imageUrl,
  ) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    List<RelationshipCare> listReCare = listReCareRead
        .map((e) => RelationshipCare.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listReCare.length; i++) {
      if (listReCare[i].reCareId!.length == reCareId.length &&
          listReCare[i].reCareId! == reCareId) {
        listReCare[i].contentImage!.remove(imageUrl);
        listReCare[i].updateAt = DateTime.now();
      }
    }
    listReCareRead = listReCare.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('reCares', listReCareRead);
  }

  static Future<void> removeReCare(String reCareId) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    for (var reCare in listReCareRead) {
      RelationshipCare rc = RelationshipCare.fromMap(jsonDecode(reCare));
      if ((rc.reCareId!.length == reCareId.length) &&
          (rc.reCareId == reCareId)) {
        listReCareRead.remove(reCare);
        await _prefs.setStringList('reCares', listReCareRead);
        return;
      }
    }
  }
}
