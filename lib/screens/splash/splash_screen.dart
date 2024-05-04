import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_relationships.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/take_care/detail/detail_relationship_care.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    if (notificationAppLaunchDetails!.didNotificationLaunchApp) {
      final payload =
          notificationAppLaunchDetails.notificationResponse!.payload;
      List<String> datas = List<String>.from(jsonDecode(payload!));
      RelationshipCare reCare = RelationshipCare.fromMap(jsonDecode(datas[0]));
      UserRelationship userRelationship =
          UserRelationship.fromMap(jsonDecode(datas[1]));
      Get.to(
        () => DetailRelationshipCare.fromNotification(
          reCare: reCare,
          userRelationship: userRelationship,
          route: true,
        ),
      );
    } else {
      if (firstTime) {
        Navigator.of(context).pushReplacementNamed("/Welcome");
      } else {
        if (logged) {
          Navigator.of(context).pushReplacementNamed("/Main");
        } else {
          Navigator.of(context).pushReplacementNamed("/Auth");
        }
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
