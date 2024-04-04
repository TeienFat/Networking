import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:networking/models/address_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class APIsUser {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static Future<String> saveUserImage(File fileImage, String fileName) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File convertedImg = File(fileImage.path);
    String imageUrl = '$path/$fileName';
    final File localImage = await convertedImg.copy(imageUrl);
    print(localImage);
    print("Saved image under: $path/$fileName");
    return imageUrl;
  }

  static Future<void> createNewUser(
    String userId,
    String userName,
    String email,
    String imageUrl,
    bool gender,
    DateTime? birthday,
    String hobby,
    String phone,
    Map<String, String> facebook,
    Map<String, String> zalo,
    Map<String, String> skype,
    List<Address> address,
    Map<String, dynamic> otherInfo,
  ) async {
    final SharedPreferences _prefs = await prefs;
    final newUser = Users(
        userId: userId,
        userName: userName,
        email: email,
        imageUrl: imageUrl,
        gender: gender,
        birthday: birthday,
        hobby: hobby,
        phone: phone,
        facebook: facebook,
        zalo: zalo,
        skype: skype,
        address: address,
        otherInfo: otherInfo,
        createdAt: DateTime.now(),
        updateAt: null,
        deleteAt: null,
        isOnline: true,
        blockUsers: [],
        token: '');
    List<String> listUserRead = await _prefs.getStringList('users') ?? [];
    listUserRead.add(jsonEncode(newUser.toMap()));
    await _prefs.setStringList('users', listUserRead);
    List<String> listUser = await _prefs.getStringList('users') ?? [];
    print(listUser);
  }

  static Future<void> getAllUser() async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUser = await _prefs.getStringList('users') ?? [];
    for (var element in listUser) {
      Users u = Users.fromMap(jsonDecode(element));
      print(u.userName);
    }
    print(listUser.length);
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

  static Future<void> updateUser(
    String userId,
    String userName,
    String email,
    String imageUrl,
    bool gender,
    DateTime? birthday,
    String hobby,
    String phone,
    Map<String, String> facebook,
    Map<String, String> zalo,
    Map<String, String> skype,
    List<Address> address,
    Map<String, dynamic> otherInfo,
  ) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUserRead = await _prefs.getStringList('users') ?? [];
    for (var user in listUserRead) {
      Users u = Users.fromMap(jsonDecode(user));
      if ((u.userId!.length == userId.length) && (u.userId == userId)) {
        u.userName = userName;
        u.email = email;
        u.imageUrl = imageUrl;
        u.gender = gender;
        u.birthday = birthday;
        u.hobby = hobby;
        u.phone = phone;
        u.facebook = facebook;
        u.zalo = zalo;
        u.skype = skype;
        u.address = address;
        u.otherInfo = otherInfo;
        u.updateAt = DateTime.now();
        listUserRead.remove(user);
        listUserRead.add(jsonEncode(u.toMap()));
        await _prefs.setStringList('users', listUserRead);
        return;
      }
    }
  }

  static Future<void> removeUser(String userId) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUserRead = await _prefs.getStringList('users') ?? [];
    print(listUserRead);
    for (var user in listUserRead) {
      Users u = Users.fromMap(jsonDecode(user));
      if ((u.userId!.length == userId.length) && (u.userId == userId)) {
        listUserRead.remove(user);
        await _prefs.setStringList('users', listUserRead);

        return;
      }
    }
  }
}
