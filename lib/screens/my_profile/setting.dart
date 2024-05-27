import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/screens/my_profile/change_password.dart';
import 'package:networking/screens/my_profile/change_secu_question.dart';

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

  void _changeUserNotification(bool value) {
    setState(() {
      _notificationEnabled = value;
      context.read<UserListBloc>().add(
          UpdateUserNotification(userId: widget.myId, notification: value));
    });
  }

  void _changePassword() async {
    final loginName = await APIsAuth.getLoginName();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangePassword(loginName: loginName!),
      ),
    );
  }

  void _changeSeQuestion() async {
    final account = await APIsAuth.getAccountFromUserId();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeSeQuestion(account: account!),
      ),
    );
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
              top: 10.sp, bottom: 10.sp, left: 10.sp, right: 20.sp),
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
              TextButton(
                style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                onPressed: _changePassword,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Đổi mật khẩu",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Icon(FontAwesomeIcons.userLock),
                  ],
                ),
              ),
              SizedBox(height: 10.sp),
              TextButton(
                style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                onPressed: _changeSeQuestion,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Đổi câu hỏi bảo mật",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Icon(FontAwesomeIcons.solidCircleQuestion),
                  ],
                ),
              ),
              SizedBox(height: 10.sp),
              TextButton(
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.all(0),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sao lưu dữ liệu",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Icon(FontAwesomeIcons.cloud),
                  ],
                ),
              ),
              SizedBox(height: 10.sp),
            ],
          ),
        ),
      ),
    );
  }
}
