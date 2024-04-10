import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/detail/detail_relationship.dart';
import 'package:networking/screens/relationships/edit/edit_relationship.dart';
import 'package:networking/screens/relationships/share/share_relationship.dart';

class RelationShipCard extends StatefulWidget {
  const RelationShipCard(
      {super.key, required this.user, required this.userRelationship});
  final UserRelationship userRelationship;
  final Users user;

  @override
  State<RelationShipCard> createState() => _RelationShipCardState();
}

class _RelationShipCardState extends State<RelationShipCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: DrawerMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ShareRelationship(
                    user: widget.user,
                    userRelationship: widget.userRelationship),
              ),
            );
          },
          backgroundColor: Color(0xFF0392CF),
          foregroundColor: Colors.white,
          icon: FontAwesomeIcons.shareAlt,
        ),
        SlidableAction(
          onPressed: (context) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditRelationship(
                    user: widget.user,
                    userRelationship: widget.userRelationship),
              ),
            );
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
                  "Xóa mối quan hệ",
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "Bạn chắc chắn muốn xóa mối quan hệ này?",
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
                      if (widget.user.imageUrl! != '') {
                        File(widget.user.imageUrl!).delete();
                      }

                      context.read<UsReListBloc>().add(
                          DeleteUsRe(usReId: widget.userRelationship.usReId!));
                      context
                          .read<UserListBloc>()
                          .add(DeleteUser(userId: widget.user.userId!));
                      showSnackbar(
                          context,
                          "Đã xóa mối quan hệ",
                          Duration(seconds: 3),
                          true,
                          ScreenUtil().screenHeight - 120);
                      Navigator.of(context)..pop();
                    },
                    child: Text("Xóa"),
                  ),
                ],
              ),
            );
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
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailRelationship(
                user: widget.user, userRelationship: widget.userRelationship),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(5.sp)),
          padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 5.sp),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[100],
                backgroundImage: widget.user.imageUrl != ''
                    ? FileImage(File(widget.user.imageUrl!)) as ImageProvider
                    : AssetImage('assets/images/user.png'),
                radius: 30.sp,
              ),
              SizedBox(
                width: 10.sp,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.userName!,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Row(
                    children: getRowRelationship(
                        widget.userRelationship.relationships!,
                        2,
                        12.sp,
                        12.sp),
                  ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  Text("Đã chăm sóc: ${widget.userRelationship.time_of_care}"),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.userRelationship.special!
                      ? Icon(
                          Icons.star,
                          color: Colors.yellow[700],
                          size: 35.sp,
                          shadows: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(3, 3),
                            ),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Text(calculateTimeRange(widget.userRelationship.createdAt!)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
