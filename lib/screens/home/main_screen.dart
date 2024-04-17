import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_relationships.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/screens/home/chat_home.dart';
import 'package:networking/screens/home/my_profile.dart';
import 'package:networking/screens/home/relationships.dart';
import 'package:networking/screens/home/take_care.dart';
import 'package:networking/screens/relationships/new/new_relationship.dart';
import 'package:networking/screens/take_care/new_relationship_care.dart';
import 'package:networking/widgets/bottom_navigartion_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

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

        // final meId = await APIsAuth.getCurrentUserId();
        // APIsUsRe.removeTable('relationships');
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
          builder: (context) => NewRelationshipCare(),
        ));
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
            SizedBox(height: 10.sp),
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
