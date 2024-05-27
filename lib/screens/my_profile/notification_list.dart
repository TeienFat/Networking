import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/bloc/notification_list/notification_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/notification_model.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/detail/detail_relationship.dart';
import 'package:networking/screens/take_care/detail/detail_relationship_care.dart';
import 'package:networking/screens/take_care/schedule/schedule.dart';
import 'package:networking/widgets/notification_card.dart';
import 'package:table_calendar/table_calendar.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key, required this.listNoti});
  final List<Notifications> listNoti;

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  bool _checkHasTodayEvent(List<Notifications> listNoti) {
    for (var noti in listNoti) {
      if (isSameDay(noti.period, DateTime.now())) return true;
    }
    return false;
  }

  String? _getNotiIdFirstBefore(List<Notifications> listNoti) {
    for (var noti in listNoti) {
      if (checkDayBefore(noti.period!, DateTime.now())) return noti.notiId;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    for (var noti in widget.listNoti) {
      if (noti.status == 0) {
        context
            .read<NotificationListBloc>()
            .add(UpdateNotiStatus(notiId: noti.notiId!, status: 1));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Thông báo"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<NotificationListBloc, NotificationListState>(
          builder: (context, state) {
            var notifications = state.notifications;
            notifications = notifications
                .where(
                  (element) => element.status != -1,
                )
                .toList();
            notifications.sort(
              (a, b) {
                if (a.period!.isBefore(b.period!)) {
                  return 1;
                }
                if (a.period!.isAfter(b.period!)) {
                  return -1;
                }
                return 0;
              },
            );
            if (state is NotificationListUploaded && notifications.isNotEmpty) {
              final beforeNotiId = _getNotiIdFirstBefore(notifications);
              return Column(
                children: [
                  if (_checkHasTodayEvent(notifications))
                    Padding(
                      padding: EdgeInsets.only(top: 10.sp, left: 5.sp),
                      child: Row(children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 30.sp,
                        ),
                        SizedBox(
                          width: 5.sp,
                        ),
                        Text(
                          "Hôm nay",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold),
                        )
                      ]),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(10.sp),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            if (beforeNotiId != null &&
                                notifications[index].notiId == beforeNotiId)
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10.sp, bottom: 5.sp),
                                child: Row(children: [
                                  Icon(
                                    Icons.history,
                                    color: Colors.blue[800],
                                    size: 30.sp,
                                  ),
                                  SizedBox(
                                    width: 5.sp,
                                  ),
                                  Text(
                                    "Trước đó",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                              ),
                            Slidable(
                              key: Key(notifications[index].notiId!),
                              endActionPane: ActionPane(
                                motion: DrawerMotion(),
                                dismissible: DismissiblePane(onDismissed: () {
                                  setState(() {
                                    context.read<NotificationListBloc>().add(
                                        DeleteNotification(
                                            notiId:
                                                notifications[index].notiId!));
                                  });
                                }),
                                children: [],
                              ),
                              child: InkWell(
                                onTap: () async {
                                  if (notifications[index].status != 2) {
                                    context.read<NotificationListBloc>().add(
                                          UpdateNotiStatus(
                                              notiId:
                                                  notifications[index].notiId!,
                                              status: 2),
                                        );
                                  }
                                  final payload = notifications[index].payload!;
                                  if (payload != 'Today') {
                                    List<String> datas =
                                        List<String>.from(jsonDecode(payload));
                                    if (datas.length == 3) {
                                      UserRelationship userRelationship =
                                          UserRelationship.fromMap(
                                              jsonDecode(datas[1]));
                                      Users? users =
                                          await APIsUser.getUserFromId(
                                              datas[2]);
                                      Get.to(
                                        () => DetailRelationship(
                                          userRelationship: userRelationship,
                                          user: users!,
                                          page: false,
                                        ),
                                      );
                                    } else {
                                      RelationshipCare reCare =
                                          RelationshipCare.fromMap(
                                              jsonDecode(datas[0]));
                                      final reca = await APIsReCare.getReCare(
                                          reCare.reCareId!);
                                      UserRelationship userRelationship =
                                          UserRelationship.fromMap(
                                              jsonDecode(datas[1]));
                                      Get.to(
                                        () => DetailRelationshipCare(
                                          reCare: reca!,
                                          userRelationship: userRelationship,
                                          route: false,
                                        ),
                                      );
                                    }
                                  } else {
                                    List<RelationshipCare> reCares =
                                        await APIsReCare
                                            .getAllMyRelationshipCare();
                                    List<RelationshipCare> eventsToday = reCares
                                        .where((element) => isSameDay(
                                            element.startTime!, DateTime.now()))
                                        .toList();
                                    Get.to(() => ScheduleScreen(
                                        listEventsToday: eventsToday));
                                  }
                                },
                                child: Column(
                                  children: [
                                    NotificationCard(
                                        notifications: notifications[index]),
                                    SizedBox(
                                      height: 10.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: notifications.length,
                    ),
                  ),
                ],
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.notifications_off_outlined,
                    size: 200.sp,
                    color: Colors.grey[300],
                  ),
                ),
                Text(
                  "Không có thông báo nào",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
