import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/widgets/popup_menu_detail_relationship.dart';

enum Menu { preview, share, getLink, remove, download }

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Users user;
  final UserRelationship userRelationship;
  MySliverAppBar(
      {required this.expandedHeight,
      required this.user,
      required this.userRelationship});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double valueOpacityShow = (shrinkOffset / expandedHeight);
    if (shrinkOffset <= 20) {
      valueOpacityShow = (shrinkOffset / expandedHeight);
    } else {
      valueOpacityShow = (shrinkOffset / expandedHeight) + 0.25;
    }

    if (valueOpacityShow > 1.0) valueOpacityShow = 1.0;
    double valueOpacityHide;
    if (shrinkOffset <= 20) {
      valueOpacityHide = 1 - (shrinkOffset / expandedHeight);
    } else {
      valueOpacityHide = 1 - ((shrinkOffset / expandedHeight) + 0.4);
    }

    if (valueOpacityHide < 0.0) valueOpacityHide = 0.0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          alignment: Alignment.centerLeft,
          color: Colors.purple[50],
          child: Stack(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuDetailRelationship(
                user: user,
                userRelationship: userRelationship,
              ),
            ),
          ]),
        ),
        Container(),
        Positioned(
          left: MediaQuery.of(context).size.width / 10,
          child: Opacity(
            opacity: valueOpacityShow,
            child: Padding(
              padding: EdgeInsets.only(top: 20.sp),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.sp),
                      border: Border.all(color: Colors.white, width: 1.5.sp)),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    backgroundImage: user.imageUrl != ''
                        ? FileImage(
                            File(user.imageUrl!),
                          ) as ImageProvider
                        : AssetImage('assets/images/user.png'),
                    radius: 25.sp,
                  ),
                ),
                SizedBox(
                  width: 10.sp,
                ),
                Container(
                  width: ScreenUtil().screenWidth * 0.52,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.userName!,
                        style: TextStyle(fontSize: 16.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5.sp,
                      ),
                      Row(
                        children: getRowRelationship(
                            userRelationship.relationships!, 1, 12.sp, 12.sp),
                      ),
                    ],
                  ),
                ),
                userRelationship.special!
                    ? Icon(
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(3, 3),
                          ),
                        ],
                        Icons.star,
                        color: Colors.yellow[700],
                        size: 35.sp,
                      )
                    : SizedBox(),
              ]),
            ),
          ),
        ),
        Positioned.fill(
          top: expandedHeight / 4.5 - shrinkOffset,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: valueOpacityHide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75.sp),
                        border: Border.all(color: Colors.white, width: 3.sp)),
                    child: Stack(children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        backgroundImage: user.imageUrl != ''
                            ? FileImage(
                                File(user.imageUrl!),
                              ) as ImageProvider
                            : AssetImage('assets/images/user.png'),
                        radius: 70.sp,
                      ),
                      userRelationship.special!
                          ? Positioned.fill(
                              top: -3.sp,
                              right: -0.5.sp,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(3, 5),
                                    ),
                                  ],
                                  Icons.star,
                                  color: Colors.yellow[700],
                                  size: 45.sp,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ]),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.sp),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ]),
                      child: Column(
                        children: [
                          Text(
                            user.userName!,
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          userRelationship.time_of_care! > 0
                              ? Text(
                                  "Đã chăm sóc " +
                                      userRelationship.time_of_care.toString() +
                                      ' lần',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 5.sp,
                          ),
                          Text(
                            "Đã thêm vào " +
                                DateFormat('dd/MM/yyyy')
                                    .format(userRelationship.createdAt!),
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 90.sp;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
