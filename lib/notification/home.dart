import 'dart:async';
import 'package:flutter/material.dart';
import 'package:networking/notification/local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    DateTime yourTime = DateTime(2024, 04, 30, 22, 20);
    VoidCallback yourAction = () {
      print("AAAAA");
    };
    Timer(yourTime.difference(DateTime.now()), yourAction);
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Local Notifications")),
      body: Container(
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {
                  LocalNotifications.showSimpleNotification(
                      title: "Chăm sóc nào!",
                      body: "Đi ăn sinh nhật",
                      iconPath:
                          '/data/user/0/com.example.networking/app_flutter/fdf97256-5041-49a1-99cc-a2df90f9b933-T1714484522014836.jpg',
                      contentBody: ["Trần Ngọc Tiến"],
                      payload: "This is simple data");
                },
                label: Text("Simple Notification"),
              ),
              // ElevatedButton.icon(
              //   icon: Icon(Icons.timer_outlined),
              //   onPressed: () {
              //     LocalNotifications.showPeriodicNotifications(
              //         title: "Periodic Notification",
              //         body: "This is a Periodic Notification",
              //         payload: "This is periodic data");
              //   },
              //   label: Text("Periodic Notifications"),
              // ),
              // ElevatedButton.icon(
              //   icon: Icon(Icons.timer_outlined),
              //   onPressed: () {
              //     LocalNotifications.showScheduleNotification(
              //         title: "Schedule Notification",
              //         body:
              //             "This is a Schedule Notification aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
              //         payload: "This is schedule data");
              //   },
              //   label: Text("Schedule Notifications"),
              // ),
              // to close periodic notifications
              ElevatedButton.icon(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    LocalNotifications.cancel(2);
                  },
                  label: Text("Close Periodic Notifcations")),
              ElevatedButton.icon(
                  icon: Icon(Icons.delete_forever_outlined),
                  onPressed: () {
                    LocalNotifications.cancelAll();
                  },
                  label: Text("Cancel All Notifcations"))
            ],
          ),
        ),
      ),
    );
  }
}
