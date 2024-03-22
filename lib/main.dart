import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/screens/auth/auth.dart';
import 'package:networking/screens/auth/forgot_password/reset_password.dart';
import 'package:networking/screens/auth/verify_email.dart';
import 'package:networking/screens/auth/waitting_auth.dart';
import 'package:networking/screens/home/main_screen.dart';
import 'package:networking/screens/splash/splash_screen.dart';
import 'package:networking/screens/splash/welcome_screen.dart';

import 'firebase_options.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 251, 148, 0));
var kDarkColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(1, 207, 46, 46));
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: ScreenUtil.defaultSize,
      builder: (context, child) {
        return MaterialApp(
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
            useMaterial3: true,
            colorScheme: kColorScheme,
            // appBarTheme: const AppBarTheme().copyWith(
            //   backgroundColor: kColorScheme.primary,
            //   foregroundColor: kColorScheme.primaryContainer,
            // ),
            // cardTheme: const CardTheme().copyWith(
            //   color: kColorScheme.secondaryContainer,
            //   margin: const EdgeInsets.symmetric(
            //     horizontal: 16,
            //     vertical: 8,
            //   ),
            // ),
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
            // '/Auth': (BuildContext context) => new StreamBuilder(
            //       stream: FirebaseAuth.instance.authStateChanges(),
            //       builder: (context, snapshot) {
            //         // if (snapshot.connectionState == ConnectionState.waiting) {
            //         //   return const Authenticating();
            //         // }
            //         if (snapshot.hasData) {
            //           return const VerifyEmail();
            //         }
            //         return const AuthScreen();
            //       },
            //     ),
            '/Auth': (BuildContext context) => new AuthScreen(),
            '/Welcome': (BuildContext context) => new WelcomeScreen(),
            '/Main': (BuildContext context) => new MainScreen(),
          },
        );
      },
    );
  }
}
