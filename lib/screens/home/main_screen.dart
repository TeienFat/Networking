import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_relationships.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/screens/home/chat_home.dart';
import 'package:networking/screens/home/relationships.dart';
import 'package:networking/screens/home/take_care.dart';
import 'package:networking/screens/home/my_profile.dart';
import 'package:networking/screens/my_profile/edit_my_profile.dart';
import 'package:networking/screens/relationships/new/new_relationship.dart';
import 'package:networking/screens/take_care/new/new_relationship_care.dart';
import 'package:networking/widgets/bottom_navigartion_bar.dart';
import 'package:networking/widgets/popup_menu_my_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.index = 0});
  final int index;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  String? myId = '';
  late Widget screens;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.index;
    if (widget.index == 1) {
      screens = TakeCareScreen();
    } else {
      screens = RelationshipScreen();
    }
  }

  String title = 'Các mối quan hệ';

  void onTab(int index) async {
    if (index == 3) {
      myId = await APIsAuth.getCurrentUserId();
    }
    setState(() {
      currentIndex = index;

      switch (currentIndex) {
        case 0:
          screens = RelationshipScreen();
          title = 'Các mối quan hệ';
          break;
        case 1:
          screens = TakeCareScreen();
          title = 'Chăm sóc mối quan hệ';
          break;
        case 2:
          screens = ChatScreen();
          title = 'Trò chuyện';
          break;
        case 3:
          screens = ProfileScreen(
            myId: myId!,
          );
          break;
      }
    });
  }

  void onTapAdd(int index) async {
    switch (index) {
      case 0:
        // APIsUsRe.removeTable('usRes');
        // APIsUser.getAllUser();
        // final meId = await APIsAuth.getCurrentUserId();
        // if (meId != null) {
        //   APIsUsRe.createNewUsRe(meId, '98648d8b-c35f-45b7-b9a6-df4824937a21');
        // }
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewRelationship(),
        ));
        // APIsUsRe.getAllMyRelationship();
        break;
      case 1:
        // APIsReCare.getAllMyRelationshipCare();

        // APIsUsRe.removeTable('reCares');
        // APIsRelationship.addListDefaut();
        // APIsUser.getAllUser();
        // APIsUsRe.getAllMyRelationship();
        // APIsReCare.removeReCare('d81f7fc8-692a-4497-aa7e-c76222a6e067');
        // APIsReCare.createNewReCare(
        //     uuid.v4(),
        //     meId!,
        //     '458753d1-b11c-4fee-9201-3b51f7e59ef3',
        //     DateTime(2024, 8, 30, 7, 00),
        //     DateTime(2024, 8, 30, 23, 59),
        //     'Dự lễ tốt nghiệp');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewRelationshipCare(
              initStartDay: DateTime.now(), initEndDay: DateTime.now()),
        ));
        break;
      case 2:
        break;
      case 3:
        final meId = await APIsAuth.getCurrentUserId();
        Users? user = await APIsUser.getUserFromId(meId!);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditMyProfile(user: user!),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.sp,
              ),
              Row(
                mainAxisAlignment: currentIndex != 3
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.end,
                children: [
                  if (currentIndex != 3)
                    Text(
                      textAlign: TextAlign.center,
                      title,
                      style: TextStyle(
                          fontSize: 23.sp, fontWeight: FontWeight.bold),
                    ),
                  if (currentIndex == 3) PopupMenuMyProfile(),
                ],
              ),
              screens,
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigartionBar(
          currentIndex: currentIndex, onTapIcon: onTab, onTapAdd: onTapAdd),
    );
  }
}
