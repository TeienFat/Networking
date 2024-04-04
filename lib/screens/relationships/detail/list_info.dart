import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';

class ListInfo extends StatelessWidget {
  const ListInfo(
      {super.key, required this.user, required this.userRelationship});
  final Users user;
  final UserRelationship userRelationship;
  @override
  List<Widget> _getAllOtherInfo() {
    List<Widget> list = [];

    user.otherInfo!.forEach((key, value) {
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ScreenUtil().screenWidth,
            child: Row(
              children: [
                SizedBox(
                  width: 10.sp,
                ),
                FaIcon(FontAwesomeIcons.circleInfo),
                SizedBox(
                  width: 17.sp,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                          fontSize: 14.sp, overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          key == user.otherInfo!.keys.last ? SizedBox() : hr,
        ],
      ));
    });

    return list;
  }

  Widget build(BuildContext context) {
    List<Widget> listRowRelationship = getAllRowRelationship(
        userRelationship.relationships!, 14.sp, 20.sp, 20.sp);
    return Column(
      children: [
        Container(
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
          child: Padding(
            padding: EdgeInsets.all(5.sp),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  padding: EdgeInsets.all(5.sp),
                  child: Text(
                    "Mối quan hệ với tôi",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                ),
                SizedBox(
                  height: 5.sp,
                ),
                Column(
                  children: listRowRelationship
                      .map((e) => Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: e,
                              ),
                              e != listRowRelationship.last ? hr : SizedBox(),
                            ],
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.sp,
        ),
        Container(
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
          child: Padding(
            padding: EdgeInsets.all(5.sp),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10.sp,
                    ),
                    FaIcon(FontAwesomeIcons.birthdayCake),
                    SizedBox(
                      width: 20.sp,
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(user.birthday!),
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14.sp),
                    ),
                    SizedBox(
                      width: 20.sp,
                    ),
                    Spacer(),
                    !user.gender!
                        ? Icon(
                            Icons.man_2_rounded,
                            size: 40.sp,
                            color: Colors.blue,
                          )
                        : Icon(
                            Icons.woman_rounded,
                            size: 40.sp,
                            color: Colors.pink,
                          ),
                  ],
                ),
                hr,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.sp,
                      ),
                      FaIcon(FontAwesomeIcons.mapLocationDot),
                      SizedBox(
                        width: 15.sp,
                      ),
                      Column(
                        children: user.address!.map((e) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: ScreenUtil().screenWidth * 0.75,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        e.province!['name'] != null &&
                                                e.district!['name'] != null &&
                                                e.wards!['name'] != null
                                            ? Text(
                                                e.street != ''
                                                    ? "${e.street}, ${e.wards!['name']}, ${e.district!['name']}, ${e.province!['name']}"
                                                    : "${e.wards!['name']}, ${e.district!['name']}, ${e.province!['name']}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.sp),
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                          height: e.province!['name'] != null &&
                                                  e.district!['name'] != null &&
                                                  e.wards!['name'] != null
                                              ? 5
                                              : 0,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              e.type == 3 && e.name != null
                                                  ? e.name!
                                                  : showAddressTypeText(
                                                      e.type!),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.sp),
                                            ),
                                            SizedBox(
                                              width: 10.sp,
                                            ),
                                            showAddressTypeIcon(e.type!, 12.sp),
                                          ],
                                        ),
                                        e != user.address!.last
                                            ? hr
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                hr,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.sp,
                      ),
                      FaIcon(FontAwesomeIcons.solidHeart),
                      SizedBox(
                        width: 17.sp,
                      ),
                      Text(
                        user.hobby!,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                hr,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.sp,
                      ),
                      FaIcon(FontAwesomeIcons.phone),
                      SizedBox(
                        width: 17.sp,
                      ),
                      Text(
                        user.phone!,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                hr,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.sp,
                      ),
                      Icon(
                        Icons.mail,
                      ),
                      SizedBox(
                        width: 17.sp,
                      ),
                      Text(
                        user.email!,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                hr,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.sp,
                      ),
                      FaIcon(FontAwesomeIcons.facebook),
                      SizedBox(
                        width: 17.sp,
                      ),
                      Text(
                        user.facebook!.keys.first,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                hr,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Row(children: [
                    SizedBox(
                      width: 10.sp,
                    ),
                    FaIcon(FontAwesomeIcons.skype),
                    SizedBox(
                      width: 20.sp,
                    ),
                    Text(
                      user.skype!.keys.first,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14.sp),
                    ),
                  ]),
                ),
                hr,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5.sp,
                      ),
                      Image.asset(
                        'assets/images/icon-zalo.png',
                        width: 25.sp,
                      ),
                      SizedBox(
                        width: 18.sp,
                      ),
                      Text(
                        user.zalo!.keys.first,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                hr,
                Column(
                  children: _getAllOtherInfo(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
