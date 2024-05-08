import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen(
      {super.key, required this.myId, required this.notificationEnabled});
  final String myId;
  final bool notificationEnabled;
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var _notificationEnabled;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationEnabled = widget.notificationEnabled;
  }

  // void _toggleNotification(bool value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('notification', value);
  //   setState(() {
  //     _notificationEnabled = value;
  //   });
  // }
  void _changeUserNotification(bool value) {
    setState(() {
      _notificationEnabled = value;
      context.read<UserListBloc>().add(
          UpdateUserNotification(userId: widget.myId, notification: value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cài đặt"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              top: 10.sp, bottom: 10.sp, left: 10.sp, right: 10.sp),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cho phép thông báo",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Switch(
                    value: _notificationEnabled,
                    onChanged: _changeUserNotification,
                  )
                ],
              ),
              SizedBox(height: 10.sp),
            ],
          ),
        ),
      ),
    );
  }
}
