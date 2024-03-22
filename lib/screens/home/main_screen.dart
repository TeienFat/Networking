import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/screens/home/chat_home.dart';
import 'package:networking/screens/home/my_profile.dart';
import 'package:networking/screens/home/relationships.dart';
import 'package:networking/screens/home/take_care_list.dart';
import 'package:networking/widgets/bottom_navigartion_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  List screens = const [
    RelationshipScreen(),
    TakeCareScreen(),
    ChatScreen(),
    ProfileScreen()
  ];

  String title = 'Các mối quan hệ';

  void onTab(int index) {
    setState(() {
      currentIndex = index;
      switch (currentIndex) {
        case 0:
          title = 'Các mối quan hệ';
          break;
        case 1:
          title = 'Chăm sóc mối quan hệ';
          break;
        case 2:
          title = 'Trò chuyện';
          break;
      }
    });
  }

  void onTapAdd(int index) async {
    switch (index) {
      case 0:
        // APIsUser.getAllUser();
        // final meId = await APIsAuth.getCurrentUserId();
        // if (meId != null) {
        //   APIsUsRe.createNewUsRe('2af962fa-e2e6-4d69-80c4-d142621be197',
        //       '796b5c38-806b-4d94-b11e-3d1cb3b06735');
        // }
        // APIsUsRe.getAllMyRelationship();

        break;
      case 1:
        print("B");
        break;
      case 2:
        print("C");
        break;
      case 3:
        print("D");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Column(
          children: [
            currentIndex == 3
                ? SizedBox()
                : Text(
                    textAlign: TextAlign.center,
                    title,
                    style:
                        TextStyle(fontSize: 23.sp, fontWeight: FontWeight.bold),
                  ),
            screens[currentIndex]
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: MyBottomNavigartionBar(
              currentIndex: currentIndex, onTapIcon: onTab, onTapAdd: onTapAdd),
        ),
      ]),
    ));
  }
}
