import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/take_care/detail/detail_relationship_care.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  static void onNotificationTap(
      NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload!;
    List<String> datas = List<String>.from(jsonDecode(payload));
    RelationshipCare reCare = RelationshipCare.fromMap(jsonDecode(datas[0]));
    UserRelationship userRelationship =
        UserRelationship.fromMap(jsonDecode(datas[1]));
    Get.to(
      () => DetailRelationshipCare.fromNotification(
          reCare: reCare, userRelationship: userRelationship),
    );
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

  static Future showPeriodicNotifications({
    required String title,
    required String body,
    required String iconPath,
    required List<String> contentBody,
    required String payload,
  }) async {
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        1,
        title,
        body,
        RepeatInterval.everyMinute,
        await _notificationDetails(iconPath, body, contentBody),
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
