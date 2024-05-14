import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:networking/apis/apis_chat.dart';
import 'package:networking/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:networking/screens/relationships/detail/list_info.dart';
import 'package:networking/screens/relationships/new/new_relationship.dart';

class ProfileOfOthersScreen extends StatefulWidget {
  ProfileOfOthersScreen({super.key, required this.id});
  final String id;

  @override
  State<ProfileOfOthersScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileOfOthersScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: APIsChat.getUserFormId(widget.id),
      builder: (context, userIDSnapShot) {
        if (userIDSnapShot.connectionState == ConnectionState.done) {
          Users user = userIDSnapShot.data!;
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewRelationship.initUser(
                                    user: user,
                                  )));
                    },
                    icon: Icon(FontAwesomeIcons.handshakeAngle))
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(75.sp),
                            border:
                                Border.all(color: Colors.white, width: 3.sp)),
                        child: Stack(children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            backgroundImage: user.imageUrl != ''
                                ? NetworkImage(user.imageUrl!) as ImageProvider
                                : AssetImage('assets/images/user.png'),
                            radius: 70.sp,
                          ),
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
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: ListInfo.myProfile(
                          user: user,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else
          return Container();
      },
    );
  }
}
