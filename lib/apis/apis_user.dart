import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:networking/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class APIsUser {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static Future<void> createNewUser(String userId, String userName) async {
    final SharedPreferences _prefs = await prefs;
    final newUser = Users(
        userId: userId,
        userName: userName,
        email: '',
        imageUrl: '',
        gender: true,
        birthday: null,
        phone: '',
        facebook: '',
        zalo: '',
        skype: '',
        otherInfo: {},
        createdAt: DateTime.now(),
        updateAt: null,
        deleteAt: null,
        isOnline: true,
        blockUsers: [],
        token: '');
    List<String> listUserRead = await _prefs.getStringList('users') ?? [];
    listUserRead.add(jsonEncode(newUser.toMap()));
    await _prefs.setStringList('users', listUserRead);
    // List<String> listUser = await _prefs.getStringList('users') ?? [];
    // print(listUser);
  }

  static Future<void> getAllUser() async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUser = await _prefs.getStringList('users') ?? [];
    print(listUser);
  }

  static Future<Users?> getUserFromId(String userId) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUserRead = await _prefs.getStringList('users') ?? [];
    for (var user in listUserRead) {
      Users u = Users.fromMap(jsonDecode(user));
      if ((u.userId!.length == userId.length) && (u.userId == userId)) return u;
    }
    return null;
  }
}
