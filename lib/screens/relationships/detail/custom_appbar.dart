import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';

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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          color: Colors.purple[50],
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
        Container(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 7,
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Padding(
              padding: EdgeInsets.only(top: 10.sp),
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
                  width: ScreenUtil().screenWidth * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.userName!,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(
                        height: 5.sp,
                      ),
                      FutureBuilder(
                        future: getRowRelationship(
                            userRelationship.relationships!, 1, 12.sp, 12.sp),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                                child: Column(
                              children: [
                                Text(
                                  "Chưa thiết lập mối quan hệ",
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            ));
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(
                              "Có gì đó sai sai...",
                              style: TextStyle(fontSize: 12.sp),
                            ));
                          }
                          return Row(
                            children: snapshot.data!,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2.5 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 3.35,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75.sp),
                  border: Border.all(color: Colors.white, width: 3.sp)),
              child: CircleAvatar(
                backgroundColor: Colors.grey[100],
                backgroundImage: user.imageUrl != ''
                    ? FileImage(
                        File(user.imageUrl!),
                      ) as ImageProvider
                    : AssetImage('assets/images/user.png'),
                radius: 70.sp,
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
  double get minExtent => 70.sp;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
