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
    Map<String, dynamic> facebook,
    Map<String, dynamic> zalo,
    Map<String, dynamic> skype,
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
    // List<String> listUser = await _prefs.getStringList('users') ?? [];
    // print(listUser);
  }

  static Future<List<Users>> getAllUser() async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUserRead = await _prefs.getStringList('users') ?? [];
    // for (var element in listUserRead) {
    //   Users u = Users.fromMap(jsonDecode(element));
    //   print(u.userId);
    // }
    var listUser =
        listUserRead.map((e) => Users.fromMap(jsonDecode(e))).toList();
    return listUser;
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
    Map<String, dynamic> facebook,
    Map<String, dynamic> zalo,
    Map<String, dynamic> skype,
    List<Address> address,
    Map<String, dynamic> otherInfo,
  ) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUserRead = await _prefs.getStringList('users') ?? [];
    List<Users> listUser =
        listUserRead.map((e) => Users.fromMap(jsonDecode(e))).toList();
    for (int i = 0; i < listUser.length; i++) {
      if ((listUser[i].userId!.length == userId.length) &&
          (listUser[i].userId == userId)) {
        listUser[i].userName = userName;
        listUser[i].email = email;
        listUser[i].imageUrl = imageUrl;
        listUser[i].gender = gender;
        listUser[i].birthday = birthday;
        listUser[i].hobby = hobby;
        listUser[i].phone = phone;
        listUser[i].facebook = facebook;
        listUser[i].zalo = zalo;
        listUser[i].skype = skype;
        listUser[i].address = address;
        listUser[i].otherInfo = otherInfo;
        listUser[i].updateAt = DateTime.now();
      }
    }
    listUserRead = listUser.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('users', listUserRead);
  }

  static Future<void> removeUser(String userId) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUserRead = await _prefs.getStringList('users') ?? [];
    // print(listUserRead);
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
