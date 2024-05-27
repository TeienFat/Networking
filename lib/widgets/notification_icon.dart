import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/notification_list/notification_list_bloc.dart';
import 'package:networking/models/notification_model.dart';
import 'package:networking/screens/my_profile/notification_list.dart';
import 'package:table_calendar/table_calendar.dart';

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key, required this.notifications});
  final List<Notifications> notifications;

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  @override
  Widget build(BuildContext context) {
    for (var noti in widget.notifications) {
      if (noti.status == -1) {
        if (DateTime.now().isAfter(noti.period!)) {
          context
              .read<NotificationListBloc>()
              .add(UpdateNotiStatus(notiId: noti.notiId!, status: 0));
        } else {
          if (isSameDay(noti.period!, DateTime.now()) &&
              noti.period!.hour == DateTime.now().hour) {
            Timer(
              noti.period!.difference(DateTime.now()),
              () {
                setState(() {});
              },
            );
          }
        }
      }
    }
    List<Notifications> _listNotification = widget.notifications
        .where(
          (element) => element.status == 0,
        )
        .toList();
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationList(
              listNoti: _listNotification,
            ),
          ),
        );
      },
      icon: Stack(
        children: [
          Icon(
            Icons.notifications_rounded,
            color: Colors.black,
            size: 30.sp,
          ),
          if (_listNotification.length > 0)
            Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.all(
                      _listNotification.length <= 9 ? 5.sp : 2.sp),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Text(
                    _listNotification.length.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
