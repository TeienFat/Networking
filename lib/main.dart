import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/bloc/notification_list/notification_list_bloc.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user/user_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/notification/local_notifications.dart';
import 'package:networking/screens/auth/auth.dart';
import 'package:networking/screens/chatbot/api_chatbot_key.dart';
import 'package:networking/screens/home/main_screen.dart';
import 'package:networking/screens/splash/splash_screen.dart';
import 'package:networking/screens/splash/welcome_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'firebase_options.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 149, 0));
var kDarkColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(1, 207, 46, 46));
var currentUserId;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotifications.init();
  currentUserId = await APIsAuth.getCurrentUserId();
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );
  print(currentUserId);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => UsReListBloc()..add(LoadUsReList())),
          BlocProvider(
              create: (context) => UserListBloc()..add(LoadUserList())),
          BlocProvider(
              create: (context) => ReCareListBloc()..add(LoadReCareList())),
          BlocProvider(
              create: (context) =>
                  NotificationListBloc()..add(LoadNotificationList())),
          BlocProvider(create: (context) => UserBloc()),
        ],
        child: ScreenUtilInit(
          designSize: ScreenUtil.defaultSize,
          builder: (context, child) {
            return GetMaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,

              // darkTheme: ThemeData.dark().copyWith(
              //   useMaterial3: true,
              //   colorScheme: kDarkColorScheme,
              //   cardTheme: const CardTheme().copyWith(
              //     color: kDarkColorScheme.secondaryContainer,
              //     margin: const EdgeInsets.symmetric(
              //       horizontal: 16,
              //       vertical: 8,
              //     ),
              //   ),
              //   elevatedButtonTheme: ElevatedButtonThemeData(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: kDarkColorScheme.primaryContainer,
              //       foregroundColor: kDarkColorScheme.onPrimaryContainer,
              //     ),
              //   ),
              // ),
              theme: ThemeData().copyWith(
                scaffoldBackgroundColor: Colors.white,
                useMaterial3: true,
                colorScheme: kColorScheme,
                // appBarTheme: const AppBarTheme().copyWith(
                //   backgroundColor: kColorScheme.primary,
                //   foregroundColor: kColorScheme.primaryContainer,
                // ),
                cardTheme: const CardTheme()
                    .copyWith(elevation: 2.sp, color: Colors.white),

                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      foregroundColor: Colors.black),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9.sp),
                  ),
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp),
                  errorStyle: TextStyle(fontSize: 12.sp),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.black),
                    textStyle: MaterialStatePropertyAll(
                      TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
                textTheme: ThemeData().textTheme.copyWith(
                      titleLarge: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: Colors.black,
                      ),
                      titleMedium: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                      titleSmall: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
              ),
              home: const SplashScreen(),
              routes: <String, WidgetBuilder>{
                '/Auth': (BuildContext context) => new AuthScreen(),
                '/Welcome': (BuildContext context) => new WelcomeScreen(),
                '/Main': (BuildContext context) => new MainScreen(),
                '/MainRecare': (BuildContext context) => new MainScreen(
                      index: 1,
                    ),
                '/MainChat': (BuildContext context) => new MainScreen(
                      index: 2,
                    ),
              },
            );
          },
        ));
  }
}
