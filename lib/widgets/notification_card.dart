import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/notification_list/notification_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/notification_model.dart';
import 'package:networking/notification/local_notifications.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({super.key, required this.notifications});
  final Notifications notifications;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int id = double.parse(widget.notifications.notiId!).round();
    LocalNotifications.cancel(id);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notifications.status == 0) {
      context.read<NotificationListBloc>().add(
          UpdateNotiStatus(notiId: widget.notifications.notiId!, status: 1));
    }
    return Container(
      decoration: BoxDecoration(
          color: widget.notifications.status == 2
              ? Colors.white
              : Colors.amber[100],
          borderRadius: BorderRadius.circular(5.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ]),
      padding: EdgeInsets.all(10.sp),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.sp)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.sp)),
              child: widget.notifications.usReImage != ''
                  ? Image.file(
                      File(widget.notifications.usReImage!),
                      width: 50.sp,
                      height: 50.sp,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/user.png',
                      width: 50.sp,
                      height: 50.sp,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(
            width: 10.sp,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.notifications.title!),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Icon(Icons.history, size: 15.sp, color: Colors.grey[600]),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Text(
                    calculateTimeRange(widget.notifications.period!),
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
              Container(
                  width: ScreenUtil().screenWidth * 0.7,
                  child: Text(
                    widget.notifications.body!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
              Text(widget.notifications.contentBody!),
            ],
          ),
        ],
      ),
    );
  }
}
