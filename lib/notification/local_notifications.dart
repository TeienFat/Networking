import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/detail/detail_relationship.dart';
import 'package:networking/screens/take_care/detail/detail_relationship_care.dart';
import 'package:networking/screens/take_care/schedule/schedule.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void onNotificationTap(
      NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload!;
    if (payload != 'Today') {
      List<String> datas = List<String>.from(jsonDecode(payload));
      if (datas.length == 3) {
        UserRelationship userRelationship =
            UserRelationship.fromMap(jsonDecode(datas[1]));
        Users? users = await APIsUser.getUserFromId(datas[2]);
        Get.to(
          () => DetailRelationship(
            userRelationship: userRelationship,
            user: users!,
            page: false,
          ),
        );
      } else {
        RelationshipCare reCare =
            RelationshipCare.fromMap(jsonDecode(datas[0]));
        UserRelationship userRelationship =
            UserRelationship.fromMap(jsonDecode(datas[1]));
        Get.to(
          () => DetailRelationshipCare(
            reCare: reCare,
            userRelationship: userRelationship,
            route: true,
          ),
        );
      }
    } else {
      List<RelationshipCare> reCares =
          await APIsReCare.getAllMyRelationshipCare();
      List<RelationshipCare> eventsToday = reCares
          .where((element) => isSameDay(element.startTime!, DateTime.now()))
          .toList();
      Get.to(() => ScheduleScreen(listEventsToday: eventsToday));
    }
  }

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestExactAlarmsPermission();
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static Future _notificationDetails(
      String iconPath, String contentTitle, List<String> contentBody) async {
    final largeIconPath = File(iconPath).path;

    return NotificationDetails(
      android: AndroidNotificationDetails(
          'your channel id', 'Thông báo lịch chăm sóc',
          channelDescription: 'your channel description',
          icon: '@drawable/ic_handshake',
          color: Colors.orangeAccent,
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          styleInformation:
              InboxStyleInformation(contentBody, contentTitle: contentTitle),
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker'),
    );
  }

  static Future _notificationDetailsWithoutIconPath(
      String contentTitle, List<String> contentBody) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
          'your channel id', 'Thông báo lịch chăm sóc',
          channelDescription: 'your channel description',
          icon: '@drawable/ic_handshake',
          color: Colors.orangeAccent,
          // largeIcon: '@mipmap/ic_launcher',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          styleInformation:
              InboxStyleInformation(contentBody, contentTitle: contentTitle),
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker'),
    );
  }

  static Future showSimpleNotification({
    required String title,
    required String body,
    required String iconPath,
    required List<String> contentBody,
    required String payload,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
        0, title, body, await _notificationDetails(iconPath, body, contentBody),
        payload: payload);
  }

  static Future showDailyNotifications({
    required String title,
    required String body,
    required List<String> contentBody,
    required String payload,
  }) async {
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        123456,
        title,
        body,
        RepeatInterval.daily,
        await _notificationDetailsWithoutIconPath(body, contentBody),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload);
  }

  static Future showScheduleNotification({
    required DateTime dateTime,
    required int id,
    required String title,
    required String body,
    required String iconPath,
    required List<String> contentBody,
    required String payload,
  }) async {
    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(dateTime, tz.local),
        await _notificationDetails(iconPath, body, contentBody),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }

  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
