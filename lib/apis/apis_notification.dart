import 'dart:convert';

import 'package:networking/main.dart';

import 'package:networking/models/notification_model.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class APIsNotification {
  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static Future<void> createNewNotification(Notifications newNoti) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listNotiRead =
        await _prefs.getStringList('notifications') ?? [];
    listNotiRead.add(jsonEncode(newNoti.toMap()));
    await _prefs.setStringList('notifications', listNotiRead);
    List<String> listUser = await _prefs.getStringList('notifications') ?? [];
    print(listUser);
  }

  static Future<List<Notifications>> getAllMyNotification() async {
    final SharedPreferences _prefs = await prefs;
    List<String> listNotiRead =
        await _prefs.getStringList('notifications') ?? [];
    var listMyNoti = listNotiRead
        .where((element) =>
            Notifications.fromMap(jsonDecode(element)).userId == currentUserId)
        .toList() // lọc ra những notification của mình
        .map((e) => Notifications.fromMap(jsonDecode(e)))
        .toList();
    return listMyNoti;
  }

  static Future<void> updateStatus(
    String notiId,
    int status,
  ) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listNotiRead =
        await _prefs.getStringList('notifications') ?? [];
    List<Notifications> listNoti =
        listNotiRead.map((e) => Notifications.fromMap(jsonDecode(e))).toList();

    for (int i = 0; i < listNoti.length; i++) {
      if (listNoti[i].notiId!.length == notiId.length &&
          listNoti[i].notiId! == notiId) {
        listNoti[i].status = status;
      }
    }
    listNotiRead = listNoti.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('notifications', listNotiRead);
  }

  static Future<void> removeNotification(String notiId) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listNotiRead =
        await _prefs.getStringList('notifications') ?? [];
    for (var noti in listNotiRead) {
      Notifications notifications = Notifications.fromMap(jsonDecode(noti));
      if ((notifications.notiId!.length == notiId.length) &&
          (notifications.notiId! == notiId)) {
        listNotiRead.remove(noti);
        await _prefs.setStringList('notifications', listNotiRead);
        return;
      }
    }
  }
}
