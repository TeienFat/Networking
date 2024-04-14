import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/detail/detail_relationship.dart';
import 'package:networking/screens/relationships/edit/edit_relationship.dart';
import 'package:networking/screens/relationships/share/share_relationship.dart';

class ReCareCard extends StatefulWidget {
  const ReCareCard(
      {super.key,
      required this.reCare,
      required this.userRelationship,
      required this.listType});
  final RelationshipCare reCare;
  final UserRelationship userRelationship;
  final int listType;

  @override
  State<ReCareCard> createState() => _ReCareCardState();
}

class _ReCareCardState extends State<ReCareCard> {
  @override
  Widget build(BuildContext context) {
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
        SlidableAction(
          onPressed: (context) {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => EditRelationship(
            //         user: widget.user,
            //         userRelationship: widget.userRelationship),
            //   ),
            // );
          },
          backgroundColor: Color.fromARGB(255, 238, 184, 6),
          foregroundColor: Colors.white,
          icon: FontAwesomeIcons.edit,
        ),
        SlidableAction(
          onPressed: (context) {
            // showDialog(
            //   context: context,
            //   builder: (context) => AlertDialog(
            //     title: Text(
            //       "Xóa mối quan hệ",
            //       textAlign: TextAlign.center,
            //     ),
            //     content: Text(
            //       "Bạn chắc chắn muốn xóa mối quan hệ này?",
            //       textAlign: TextAlign.center,
            //     ),
            //     actions: [
            //       ElevatedButton(
            //         style: ButtonStyle(
            //             backgroundColor: MaterialStatePropertyAll(Colors.grey)),
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //         child: Text("Hủy"),
            //       ),
            //       ElevatedButton(
            //         style: ButtonStyle(
            //             backgroundColor: MaterialStatePropertyAll(Colors.red)),
            //         onPressed: () {
            //           if (widget.user.imageUrl! != '') {
            //             File(widget.user.imageUrl!).delete();
            //           }

            //           context.read<UsReListBloc>().add(
            //               DeleteUsRe(usReId: widget.userRelationship.usReId!));
            //           context
            //               .read<UserListBloc>()
            //               .add(DeleteUser(userId: widget.user.userId!));
            //           showSnackbar(
            //               context,
            //               "Đã xóa mối quan hệ",
            //               Duration(seconds: 3),
            //               true,
            //               ScreenUtil().screenHeight - 120);
            //           Navigator.of(context)..pop();
            //         },
            //         child: Text("Xóa"),
            //       ),
            //     ],
            //   ),
            // );
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
        // onTap: () => Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => DetailRelationship(
        //         user: widget.user, userRelationship: widget.userRelationship),
        //   ),
        // ),
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
                      widget.reCare.contentText!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                            widget.userRelationship.relationships!.first.type!,
                            12.sp),
                        SizedBox(
                          width: 5.sp,
                        ),
                        Text(
                            widget.userRelationship.relationships!.first.name!),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("Bắt đầu:"), Text("Kết thúc:")],
                        ),
                        SizedBox(
                          width: 3.sp,
                        ),
                        Column(
                          children: [
                            getRowDateTime(widget.reCare.startTime!),
                            getRowDateTime(widget.reCare.endTime!),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              widget.listType == 0 ? _iconCard : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}