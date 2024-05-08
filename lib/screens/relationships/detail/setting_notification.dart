import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/widgets/muti_toggle_button.dart';

class SettingNotification extends StatefulWidget {
  const SettingNotification({super.key, required this.userRelationship});
  final UserRelationship userRelationship;

  @override
  State<SettingNotification> createState() => _SettingNotificationState();
}

class _SettingNotificationState extends State<SettingNotification> {
  var _remidNotification;
  var _howLongRemid;
  var _scheduleNotification;
  var _birthdayNotification;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _remidNotification = widget.userRelationship.notification!['remid'];
    _howLongRemid = widget.userRelationship.notification!['howLong'];
    _scheduleNotification = widget.userRelationship.notification!['schedule'];
    _birthdayNotification = widget.userRelationship.notification!['birthday'];
  }

  void _changeRemidNotification(bool value) {
    setState(() {
      _remidNotification = value;
      context.read<UsReListBloc>().add(UpdateRemidNotification(
          usReId: widget.userRelationship.usReId!, value: value));
    });
  }

  void _changeHowLongRemid(int long) {
    context.read<UsReListBloc>().add(UpdateHowLongRemid(
        usReId: widget.userRelationship.usReId!, long: long));
  }

  void _changeScheduleNotification(bool value) {
    setState(() {
      _scheduleNotification = value;
      context.read<UsReListBloc>().add(UpdateScheduleNotification(
          usRe: widget.userRelationship, value: value));
    });
  }

  void _changeBirthdayNotification(bool value) {
    setState(() {
      _birthdayNotification = value;
      context.read<UsReListBloc>().add(UpdateBirthdayNotification(
          usReId: widget.userRelationship.usReId!, value: value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cài đặt thông báo"),
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
                    "Nhắc nhở chăm sóc",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Switch(
                    value: _remidNotification,
                    onChanged: _changeRemidNotification,
                  )
                ],
              ),
              SizedBox(height: 10.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sau khoảng thời gian không chăm sóc",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
              SizedBox(height: 10.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MutiSwicthButton(
                    onSelectLong: _changeHowLongRemid,
                    intLong: _howLongRemid,
                  ),
                ],
              ),
              SizedBox(height: 10.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chăm sóc theo lịch",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Switch(
                    value: _scheduleNotification,
                    onChanged: _changeScheduleNotification,
                  )
                ],
              ),
              SizedBox(height: 10.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sinh nhật",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Switch(
                    value: _birthdayNotification,
                    onChanged: _changeBirthdayNotification,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
