import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/models/relationship_model.dart';
import 'package:networking/models/user_model.dart';

import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/notification/local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class APIsUsRe {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static Future<void> createNewUsRe(UserRelationship newUsRe) async {
    final SharedPreferences _prefs = await prefs;

    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    listUsReRead.add(jsonEncode(newUsRe.toMap()));
    await _prefs.setStringList('usRes', listUsReRead);
    // List<String> listUser = await _prefs.getStringList('usRes') ?? [];
    // print(listUser.length);
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

    // print(listMyRelationship.first.usReId);
    return listMyRelationship;
  }

  static Future<UserRelationship?> getUserRelationshipFromId(
      String usReId) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    for (var usRe in listUsReRead) {
      UserRelationship u = UserRelationship.fromMap(jsonDecode(usRe));
      if ((u.usReId!.length == usReId.length) && (u.usReId == usReId)) return u;
    }

    // print(listMyRelationship.first.usReId);
    return null;
  }

  static Future<void> removeUsRe(String usReId, DateTime? deleteAt) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    List<UserRelationship> listUsRe = listUsReRead
        .map((e) => UserRelationship.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listUsRe.length; i++) {
      if (listUsRe[i].usReId!.length == usReId.length &&
          listUsRe[i].usReId! == usReId) {
        listUsRe[i].deleteAt = deleteAt;
        listUsRe[i].updateAt = DateTime.now();
      }
    }
    listUsReRead = listUsRe.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('usRes', listUsReRead);
  }

  static Future<void> updateTimeOfCareUsRe(
      String usReId, int timeOfCare) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    List<UserRelationship> listUsRe = listUsReRead
        .map((e) => UserRelationship.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listUsRe.length; i++) {
      if (listUsRe[i].usReId!.length == usReId.length &&
          listUsRe[i].usReId! == usReId) {
        listUsRe[i].time_of_care = timeOfCare;
        listUsRe[i].updateAt = DateTime.now();
      }
    }
    listUsReRead = listUsRe.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('usRes', listUsReRead);
  }

  static Future<void> updateRemidNotification(String usReId, bool value) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    List<UserRelationship> listUsRe = listUsReRead
        .map((e) => UserRelationship.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listUsRe.length; i++) {
      if (listUsRe[i].usReId!.length == usReId.length &&
          listUsRe[i].usReId! == usReId) {
        listUsRe[i].notification!['remid'] = value;
        listUsRe[i].updateAt = DateTime.now();
      }
    }
    listUsReRead = listUsRe.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('usRes', listUsReRead);
  }

  static Future<void> updateHowLongRemid(String usReId, int long) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    List<UserRelationship> listUsRe = listUsReRead
        .map((e) => UserRelationship.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listUsRe.length; i++) {
      if (listUsRe[i].usReId!.length == usReId.length &&
          listUsRe[i].usReId! == usReId) {
        listUsRe[i].notification!['howLong'] = long;
        listUsRe[i].updateAt = DateTime.now();
      }
    }
    listUsReRead = listUsRe.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('usRes', listUsReRead);
  }

  static Future<void> updateScheduleNotification(
      String usReId, bool value) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    List<UserRelationship> listUsRe = listUsReRead
        .map((e) => UserRelationship.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listUsRe.length; i++) {
      if (listUsRe[i].usReId!.length == usReId.length &&
          listUsRe[i].usReId! == usReId) {
        listUsRe[i].notification!['schedule'] = value;
        listUsRe[i].updateAt = DateTime.now();
      }
    }
    listUsReRead = listUsRe.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('usRes', listUsReRead);
  }

  static Future<void> updateBirthdayNotification(
      String usReId, bool value) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    List<UserRelationship> listUsRe = listUsReRead
        .map((e) => UserRelationship.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listUsRe.length; i++) {
      if (listUsRe[i].usReId!.length == usReId.length &&
          listUsRe[i].usReId! == usReId) {
        listUsRe[i].notification!['birthday'] = value;
        listUsRe[i].updateAt = DateTime.now();
      }
    }
    listUsReRead = listUsRe.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('usRes', listUsReRead);
  }

  static Future<void> updateUsRe(
    String usReId,
    bool special,
    List<Relationship> relationships,
  ) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    List<UserRelationship> listUsRe = listUsReRead
        .map((e) => UserRelationship.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listUsRe.length; i++) {
      if (listUsRe[i].usReId!.length == usReId.length &&
          listUsRe[i].usReId! == usReId) {
        listUsRe[i].special = special;
        listUsRe[i].relationships = relationships;
        listUsRe[i].updateAt = DateTime.now();
      }
    }
    listUsReRead = listUsRe.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('usRes', listUsReRead);
  }

  static Future<void> setNotificationForAllUsRe(
    bool type,
  ) async {
    final SharedPreferences _prefs = await prefs;
    final myId = await APIsAuth.getCurrentUserId();
    List<String> listUsReRead = await _prefs.getStringList('usRes') ?? [];
    var listMyRelationship = listUsReRead
        .where((element) =>
            UserRelationship.fromMap(jsonDecode(element)).meId == myId)
        .toList() // lọc ra những relationship của mình
        .map((e) => UserRelationship.fromMap(jsonDecode(e)))
        .toList();
    for (var usRe in listMyRelationship) {
      APIsReCare.setNotificationSchedule(usRe, type);
      if (type) {
        APIsReCare.setNotificationRemind(
            null, null, usRe.usReId!, null, null, null);
        setNotificationBirthday(usRe, null, null, null);
        LocalNotifications.showDailyNotifications(
            title: "Chăm sóc hôm nay!",
            body: "\u{1F4C6} Chăm sóc các mục chăm sóc hôm nay nào!",
            contentBody: [],
            payload: "Today");
      } else {
        LocalNotifications.cancel(usRe.notification!['id']);
        LocalNotifications.cancel(usRe.notification!['id'] + 1);
        LocalNotifications.cancel(123456);
      }
    }
  }

  static Future<void> setNotificationBirthday(
    UserRelationship usRe,
    String? userName,
    String? imageUrl,
    DateTime? birthday,
  ) async {
    final myId = await APIsAuth.getCurrentUserId();
    Users? isMe = await APIsUser.getUserFromId(myId!);
    if (userName == null && imageUrl == null && birthday == null) {
      Users? users = await APIsUser.getUserFromId(usRe.myRelationShipId!);
      userName = users!.userName;
      imageUrl = users.imageUrl;
      birthday = users.birthday;
    }

    List<String> payload = [
      "Birthday",
      jsonEncode(usRe.toMap()),
      usRe.myRelationShipId!,
    ];
    final now = DateTime.now();
    DateTime dayNotification;
    if (isMe!.notification!) {
      if (usRe.notification!['birthday']) {
        if (birthday!.month > now.month ||
            birthday.month == now.month && birthday.day >= now.day) {
          dayNotification =
              DateTime(now.year, birthday.month, birthday.day, 7, 00);
          LocalNotifications.showScheduleNotification(
              // dateTime: DateTime(
              //     now.year, event.birthday!.month, event.birthday!.day, 7, 00),
              dateTime: DateTime.now().add(Duration(seconds: 15)),
              id: usRe.notification!['id'] + 1,
              title: "Sinh nhật!",
              body: "\u{1F382} Hôm nay là sinh nhật của $userName",
              iconPath: imageUrl!,
              contentBody: [
                "Thiết lập chăm sóc ngay nào",
                dayNotification.toString()
              ],
              payload: jsonEncode(payload));
        } else {
          dayNotification =
              DateTime(now.year + 1, birthday.month, birthday.day, 7, 00);
          LocalNotifications.showScheduleNotification(
              // dateTime: DateTime(
              //     now.year + 1, event.birthday!.month, event.birthday!.day, 7, 00),
              dateTime: DateTime.now().add(Duration(seconds: 15)),
              id: usRe.notification!['id'] + 1,
              title: "Sinh nhật!",
              body: "\u{1F382} Hôm nay là sinh nhật của $userName",
              iconPath: imageUrl!,
              contentBody: [
                "Thiết lập chăm sóc ngay nào",
                dayNotification.toString()
              ],
              payload: jsonEncode(payload));
        }
      }
    }
  }

  static Future<void> deleteUsRe(String usReId) async {
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
