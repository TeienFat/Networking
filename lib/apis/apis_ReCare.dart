import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/main.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/notification/local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
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

  static Future<int> getNumSuccess(
    String usReId,
  ) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    List<RelationshipCare> listReCare = listReCareRead
        .map((e) => RelationshipCare.fromMap(jsonDecode(e)))
        .toList();
    int success = 0;
    for (int i = 0; i < listReCare.length; i++) {
      if (listReCare[i].usReId!.length == usReId.length &&
          listReCare[i].usReId! == usReId &&
          listReCare[i].isFinish == 1) {
        success += 1;
      }
    }
    return success;
  }

  static Future<List<RelationshipCare>> getReCareToday() async {
    final SharedPreferences _prefs = await prefs;
    final myId = await APIsAuth.getCurrentUserId();
    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    var listReCareToday = listReCareRead
        .where((element) =>
            isSameDay(RelationshipCare.fromMap(jsonDecode(element)).startTime,
                DateTime.now()) &&
            RelationshipCare.fromMap(jsonDecode(element)).meId == myId)
        .toList() // lọc ra những relationship care của mình
        .map((e) => RelationshipCare.fromMap(jsonDecode(e)))
        .toList();
    return listReCareToday;
  }

  static Future<void> setNotificationSchedule(
      UserRelationship usRe, bool type) async {
    final SharedPreferences _prefs = await prefs;
    final myId = await APIsAuth.getCurrentUserId();
    Users? isMe = await APIsUser.getUserFromId(myId!);
    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    List<RelationshipCare> reCares = listReCareRead
        .where((element) =>
            RelationshipCare.fromMap(jsonDecode(element)).meId == myId &&
            RelationshipCare.fromMap(jsonDecode(element)).usReId == usRe.usReId)
        .toList() // lọc ra những relationship care của mình
        .map((e) => RelationshipCare.fromMap(jsonDecode(e)))
        .toList();
    Users? users = await APIsUser.getUserFromId(usRe.myRelationShipId!);
    for (var reCare in reCares) {
      if (reCare.isFinish == 2) {
        int id = double.parse(reCare.reCareId!).round();
        List<String> payload = [
          jsonEncode(reCare.toMap()),
          jsonEncode(usRe.toMap())
        ];
        // final newNoti = Notifications(
        //     notiId: id.toString(),
        //     userId: currentUserId,
        //     title: "Chăm sóc nào!",
        //     body: "\u{1F389}\u{1F37B} " + reCare.title!,
        //     contentBody:
        //         users!.userName! + ' - ' + usRe.relationships![0].name!,
        //     usReImage: users.imageUrl!,
        //     payload: jsonEncode(payload),
        //     status: false,
        //     period: reCare.startTime!);
        // APIsNotification.createNewNotification(newNoti);
        if (isMe!.notification!) {
          if (type) {
            LocalNotifications.showScheduleNotification(
              dateTime: reCare.startTime!,
              id: id,
              title: "Chăm sóc nào!",
              body: "\u{1F389}\u{1F37B} " + reCare.title!,
              iconPath: users!.imageUrl!,
              contentBody: [
                users.userName! + ' - ' + usRe.relationships![0].name!
              ],
              payload: jsonEncode(payload),
            );
          } else {
            LocalNotifications.cancel(id);
          }
        } else {
          LocalNotifications.cancel(id);
        }
      }
    }
  }

  static Future<void> setNotificationRemind(
    List<RelationshipCare>? reCares,
    UserRelationship? usRe,
    String usReId,
    String? userId,
    String? userName,
    String? imageUrl,
  ) async {
    final SharedPreferences _prefs = await prefs;
    final myId = await APIsAuth.getCurrentUserId();
    Users? isMe = await APIsUser.getUserFromId(myId!);

    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];

    if (reCares == null) {
      reCares = listReCareRead
          .where((element) =>
              RelationshipCare.fromMap(jsonDecode(element)).meId == myId &&
              RelationshipCare.fromMap(jsonDecode(element)).usReId == usReId)
          .toList() // lọc ra những relationship care của mình
          .map((e) => RelationshipCare.fromMap(jsonDecode(e)))
          .toList();
    }
    reCares.sort(
      (a, b) {
        if (a.endTime!.isBefore(b.endTime!)) {
          return 1;
        }

        if (a.endTime!.isAfter(b.endTime!)) {
          return -1;
        }

        if (isSameDay(a.endTime!, b.endTime!)) {
          if (a.startTime!.hour > b.startTime!.hour) {
            return 1;
          }
          if (a.startTime!.hour == b.startTime!.hour) {
            if (a.startTime!.minute >= b.startTime!.minute) return 1;
          }
          return -1;
        }
        return 0;
      },
    );
    if (usRe == null) {
      usRe = await APIsUsRe.getUserRelationshipFromId(usReId);
    }
    Users? users;
    if (userName == null && imageUrl == null && userId == null) {
      users = await APIsUser.getUserFromId(usRe!.myRelationShipId!);
      userId = users!.userId;
      userName = users.userName;
      imageUrl = users.imageUrl;
    }

    LocalNotifications.cancel(usRe!.notification!['id']);
    DateTime? long = usRe.createdAt!;
    if (usRe.notification!['remid']) {
      if (reCares.isNotEmpty) {
        long = reCares.first.endTime;
      }

      var longLable;
      switch (usRe.notification!['howLong']) {
        case 1:
          long = long!.add(Duration(days: 1));
          longLable = '1 ngày';
          break;
        case 2:
          long = long!.add(Duration(days: 7));
          longLable = '1 tuần';
          break;
        case 3:
          if (long!.month == 12) {
            long = DateTime(long.year + 1, 1, long.day);
          }
          long = DateTime(long.year, long.month + 1, long.day);
          longLable = '1 tháng';
          break;
        default:
          long = DateTime(long!.year + 1, long.month, long.day);
          longLable = '1 năm';
      }
      List<String> payload = [
        "Remind",
        jsonEncode(usRe.toMap()),
        userId!,
      ];
      if (isMe!.notification!) {
        LocalNotifications.showScheduleNotification(
            dateTime: currentUserId != '44f5bf86-81c1-4cc5-970d-dc4b83c872d9'
                ? long
                : DateTime.now().add(Duration(seconds: 10)),
            id: usRe.notification!['id'],
            title: "Đã lâu rồi!",
            body: "\u{1F557} Đã $longLable bạn chưa chăm sóc cho ${userName} ",
            iconPath: imageUrl!,
            contentBody: [
              "Thiết lập chăm sóc ngay nào",
              currentUserId == '44f5bf86-81c1-4cc5-970d-dc4b83c872d9'
                  ? long.toString()
                  : ''
            ],
            payload: jsonEncode(payload));
      }
    }
  }

  static Future<void> updateIsFinish(
    String reCareId,
    int isFinish,
  ) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    List<RelationshipCare> listReCare = listReCareRead
        .map((e) => RelationshipCare.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listReCare.length; i++) {
      if (listReCare[i].reCareId!.length == reCareId.length &&
          listReCare[i].reCareId! == reCareId) {
        listReCare[i].isFinish = isFinish;
        listReCare[i].updateAt = DateTime.now();
      }
    }

    listReCareRead = listReCare.map((e) => jsonEncode(e.toMap())).toList();
    await _prefs.setStringList('reCares', listReCareRead);
  }

  static Future<void> updateReCare(
    String reCareId,
    String title,
    String usReId,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    List<RelationshipCare> listReCare = listReCareRead
        .map((e) => RelationshipCare.fromMap(jsonDecode(e)))
        .toList();

    for (int i = 0; i < listReCare.length; i++) {
      if (listReCare[i].reCareId!.length == reCareId.length &&
          listReCare[i].reCareId! == reCareId) {
        listReCare[i].title = title;
        listReCare[i].usReId = usReId;
        listReCare[i].startTime = startTime;
        listReCare[i].endTime = endTime;
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

  static Future<RelationshipCare?> getReCare(String reCareId) async {
    final SharedPreferences _prefs = await prefs;
    List<String> listReCareRead = await _prefs.getStringList('reCares') ?? [];
    for (var reCare in listReCareRead) {
      RelationshipCare rc = RelationshipCare.fromMap(jsonDecode(reCare));
      if ((rc.reCareId!.length == reCareId.length) &&
          (rc.reCareId == reCareId)) {
        return rc;
      }
    }
    return null;
  }
}
