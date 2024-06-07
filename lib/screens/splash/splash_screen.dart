import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_relationships.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/notification/local_notifications.dart';
import 'package:networking/screens/relationships/detail/detail_relationship.dart';
import 'package:networking/screens/take_care/detail/detail_relationship_care.dart';
import 'package:networking/screens/take_care/schedule/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController_logo;
  late AnimationController _animationController_text;
  late Animation<double> animation_logo;
  late Animation<double> animation_text;

  checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time') ?? true;
    var _duration = new Duration(seconds: 3);

    if (!firstTime) {
      // not first time
      final myId = await APIsAuth.getCurrentUserId();
      if (myId != null) {
        Users? isMe = await APIsUser.getUserFromId(myId);
        if (isMe != null) {
          if (isMe.notification!) {
            LocalNotifications.showDailyNotifications(
                title: "Chăm sóc hôm nay!",
                body: "\u{1F4C6} Chăm sóc các mục chăm sóc hôm nay nào!",
                contentBody: [],
                payload: "Today");
          }
        }
      }

      return Timer(_duration, goToNextScreen(false));
    } else {
      // first time
      prefs.setBool('first_time', false);
      APIsRelationship.addListDefaut();
      return new Timer(_duration, goToNextScreen(true));
    }
  }

  goToNextScreen(bool firstTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool logged = prefs.getBool('logged') ?? false;

    final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();
    if (firstTime) {
      Navigator.of(context).pushReplacementNamed("/Welcome");
    } else {
      if (logged) {
        if (notificationAppLaunchDetails!.didNotificationLaunchApp) {
          final payload =
              notificationAppLaunchDetails.notificationResponse!.payload;
          if (payload != 'Today') {
            List<String> datas = List<String>.from(jsonDecode(payload!));
            if (datas.length == 3) {
              UserRelationship userRelationship =
                  UserRelationship.fromMap(jsonDecode(datas[1]));
              Users? users = await APIsUser.getUserFromId(datas[2]);
              Get.to(
                () => DetailRelationship.fromNotification(
                  userRelationship: userRelationship,
                  user: users!,
                  page: false,
                ),
              );
            } else {
              RelationshipCare reCare =
                  RelationshipCare.fromMap(jsonDecode(datas[0]));
              UserRelationship userRelationship =
                  UserRelationship.fromMap(jsonDecode(datas[1]));
              Get.to(
                () => DetailRelationshipCare.fromNotification(
                  reCare: reCare,
                  userRelationship: userRelationship,
                  route: true,
                ),
              );
            }
          } else {
            List<RelationshipCare> reCares =
                await APIsReCare.getAllMyRelationshipCare();
            List<RelationshipCare> eventsToday = reCares
                .where(
                    (element) => isSameDay(element.startTime!, DateTime.now()))
                .toList();
            Get.to(() =>
                ScheduleScreen.fromNotification(listEventsToday: eventsToday));
          }
        } else {
          Navigator.of(context).pushReplacementNamed("/Main");
        }
      } else {
        Navigator.of(context).pushReplacementNamed("/Auth");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController_logo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController_text = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
      lowerBound: 0,
      upperBound: 1,
    );

    animation_logo = CurvedAnimation(
      parent: _animationController_logo,
      curve: Curves.bounceOut,
    );

    animation_text = CurvedAnimation(
      parent: _animationController_text,
      curve: Curves.elasticInOut,
    );

    animation_logo.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController_text.forward();
      }
    });

    animation_text.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkFirstTime();
      }
    });
    _animationController_logo.forward();
  }

  @override
  void dispose() {
    _animationController_logo.dispose();
    _animationController_text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController_logo,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", width: 300.sp),
              SizedBox(
                height: 10.sp,
              ),
              AnimatedBuilder(
                animation: _animationController_text,
                child: Text("NETWORKING",
                    style: GoogleFonts.permanentMarker(
                      fontSize: 45.sp,
                      color: const Color.fromARGB(255, 193, 90, 11),
                    )),
                builder: (context, child) => SlideTransition(
                  position: Tween(
                    begin: Offset(10.0.sp, 0),
                    end: Offset(0, 0),
                  ).animate(animation_text),
                  child: child,
                ),
              ),
            ],
          ),
        ),
        builder: (context, child) => ScaleTransition(
          scale: animation_logo,
          child: child,
        ),
      ),
    );
  }
}
