import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/take_care/detail/detail_relationship_care.dart';
import 'package:networking/screens/take_care/edit/edit_relationship_care.dart';
import 'package:networking/screens/take_care/edit/evaluate.dart';
import 'package:table_calendar/table_calendar.dart';

class ReCareCard extends StatefulWidget {
  const ReCareCard({
    super.key,
    required this.reCare,
    required this.userRelationship,
    required this.listType,
  }) : load = null;
  const ReCareCard.schedule(
      {super.key,
      required this.reCare,
      required this.userRelationship,
      required this.listType,
      required this.load});
  final RelationshipCare reCare;
  final UserRelationship userRelationship;
  final int listType;
  final void Function()? load;

  @override
  State<ReCareCard> createState() => _ReCareCardState();
}

class _ReCareCardState extends State<ReCareCard> {
  void _onEvaluate(bool isSuccess) {
    context.read<ReCareListBloc>().add(UpdateIsFinish(
        reCareId: widget.reCare.reCareId!, isFinish: isSuccess ? 1 : 0));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reCare.isFinish == 2) {
      if (DateTime.now().isAfter(widget.reCare.startTime!)) {
        context.read<ReCareListBloc>().add(
            UpdateIsFinish(reCareId: widget.reCare.reCareId!, isFinish: -1));
      } else {
        if (isSameDay(widget.reCare.startTime!, DateTime.now()) &&
            widget.reCare.startTime!.hour == DateTime.now().hour) {
          Timer(
            widget.reCare.startTime!.difference(DateTime.now()),
            () {
              setState(() {});
            },
          );
        }
      }
    }
    Color _bgCardColor;

    Icon _iconCard;
    switch (widget.reCare.isFinish) {
      case 1:
        _bgCardColor = Colors.green[200]!;
        _iconCard = Icon(
          FontAwesomeIcons.check,
          size: 28.sp,
          color: Colors.green,
        );
        break;
      case 2:
        _bgCardColor = Colors.amber[100]!;
        _iconCard = _iconCard = Icon(
          FontAwesomeIcons.running,
          size: 28.sp,
          color: Colors.amber[600],
        );
      case 0:
        _bgCardColor = Colors.red[200]!;
        _iconCard = _iconCard = Icon(
          FontAwesomeIcons.ban,
          size: 28.sp,
          color: Colors.red,
        );
        break;

      default:
        _bgCardColor = Colors.blue[200]!;
        _iconCard = _iconCard = Icon(
          FontAwesomeIcons.clockRotateLeft,
          size: 28.sp,
          color: Colors.blue,
        );
    }
    return Slidable(
      endActionPane: ActionPane(motion: DrawerMotion(), children: [
        if (widget.reCare.isFinish == 2)
          SlidableAction(
            onPressed: (context) async {
              if (widget.load != null) {
                await Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => EditRelationshipCare(
                      reCare: widget.reCare,
                      userRelationship: widget.userRelationship,
                    ),
                  ),
                )
                    .then(
                  (value) {
                    if (value != null && value) {
                      widget.load!.call();
                    }
                  },
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditRelationshipCare(
                        reCare: widget.reCare,
                        userRelationship: widget.userRelationship),
                  ),
                );
              }
            },
            backgroundColor: Color.fromARGB(255, 238, 184, 6),
            foregroundColor: Colors.white,
            icon: FontAwesomeIcons.edit,
          ),
        SlidableAction(
          onPressed: (context) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  "Xóa mục chăm sóc",
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "Bạn chắc chắn muốn xóa mục chăm sóc này?",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Hủy"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () {
                      if (widget.reCare.contentImage!.isNotEmpty) {
                        for (var image in widget.reCare.contentImage!) {
                          File(image).delete();
                        }
                      }
                      context
                          .read<ReCareListBloc>()
                          .add(DeleteReCare(reCareId: widget.reCare.reCareId!));

                      showSnackbar(
                        context,
                        "Đã xóa mục chăm sóc",
                        Duration(seconds: 2),
                        true,
                      );

                      Navigator.of(context).pop(true);
                    },
                    child: Text("Xóa"),
                  ),
                ],
              ),
            ).then((value) {
              if (value != null && value && widget.load != null) {
                widget.load!.call();
              }
            });
          },
          backgroundColor: Color.fromARGB(255, 219, 38, 6),
          foregroundColor: Colors.white,
          icon: FontAwesomeIcons.trash,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.sp),
              bottomRight: Radius.circular(5.sp)),
        ),
      ]),
      child: InkWell(
        onTap: () async {
          if (widget.reCare.isFinish != 2) {
            await Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => DetailRelationshipCare(
                    reCare: widget.reCare,
                    userRelationship: widget.userRelationship),
              ),
            )
                .then((value) {
              if (value != null && value) {
                widget.load!.call();
              }
            });
          }
        },
        onLongPress: widget.reCare.isFinish != 2
            ? () {
                showModalBottomSheet(
                  useSafeArea: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => EvaluateReCare(
                    onEvaluate: (isSuccess) => _onEvaluate(isSuccess),
                    initIsSuccess: widget.reCare.isFinish == 0 ? false : true,
                  ),
                );
              }
            : null,
        child: Container(
          decoration: BoxDecoration(
              color: _bgCardColor,
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
                width: ScreenUtil().screenWidth * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reCare.title!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.listType != 5)
                      Row(
                        children: [
                          BlocBuilder<UserListBloc, UserListState>(
                            builder: (context, state) {
                              if (state is UserListUploaded &&
                                  state.users.isNotEmpty) {
                                final users = state.users;
                                for (var user in users) {
                                  if ((user.userId!.length ==
                                          widget.userRelationship
                                              .myRelationShipId!.length) &&
                                      (user.userId ==
                                          widget.userRelationship
                                              .myRelationShipId!)) {
                                    return Text(user.userName!);
                                  }
                                }
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          SizedBox(
                            width: 5.sp,
                          ),
                          showRelationshipTypeIcon(
                              widget
                                  .userRelationship.relationships!.first.type!,
                              12.sp),
                          SizedBox(
                            width: 5.sp,
                          ),
                          Text(widget
                              .userRelationship.relationships!.first.name!),
                        ],
                      ),
                    Row(
                      children: [
                        checkAllDay(widget.reCare.startTime!,
                                widget.reCare.endTime!)
                            ? Text("Cả ngày")
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("Bắt đầu:"), Text("Kết thúc:")],
                              ),
                        SizedBox(
                          width: 3.sp,
                        ),
                        isSameDay(widget.reCare.startTime!,
                                    widget.reCare.endTime!) &&
                                checkAllDay(widget.reCare.startTime!,
                                    widget.reCare.endTime!)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getRowDateTime(
                                      widget.reCare.startTime!,
                                      11.sp,
                                      12.sp,
                                      checkAllDay(widget.reCare.startTime!,
                                          widget.reCare.endTime!)),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getRowDateTime(
                                      widget.reCare.startTime!,
                                      11.sp,
                                      12.sp,
                                      checkAllDay(widget.reCare.startTime!,
                                          widget.reCare.endTime!)),
                                  getRowDateTime(
                                      widget.reCare.endTime!,
                                      11.sp,
                                      12.sp,
                                      checkAllDay(widget.reCare.startTime!,
                                          widget.reCare.endTime!)),
                                ],
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              widget.listType == 0 || widget.listType == 5
                  ? _iconCard
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
