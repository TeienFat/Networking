import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/screens/home/main_screen.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = APIsAuth.firebaseAuth.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        Duration(seconds: 3),
        (timer) => checkEmailVerified(),
      );
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = APIsAuth.firebaseAuth.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi khi xác minh Email của bạn!'),
        ),
      );
    }
  }

  Future checkEmailVerified() async {
    await APIsAuth.firebaseAuth.currentUser!.reload();
    setState(() {
      isEmailVerified = APIsAuth.firebaseAuth.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? MainScreen()
      : Scaffold(
          body: Padding(
            padding: EdgeInsets.all(15.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 100.sp),
                  child: Image.asset("assets/images/v-email.png"),
                ),
                SizedBox(
                  height: 50.sp,
                ),
                Text(
                  "Xác minh Email của bạn",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Chúng tôi đã gửi một email đến ',
                          style: TextStyle(
                              fontSize: 20, color: Colors.black, height: 1.5),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${APIsAuth.firebaseAuth.currentUser!.email}',
                              style: TextStyle(
                                color: Colors.orange[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                                text:
                                    ' để xác minh địa chỉ email của bạn và kích hoạt tài khoản '),
                            TextSpan(
                              text: 'Networking.',
                              style: TextStyle(
                                color: Colors.orange[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Vui lòng kiểm tra email và tiến hành xác minh.",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      // onPressed: canResendEmail ? sendVerificationEmail : null,
                      icon: Icon(
                        Icons.email,
                        size: 30,
                      ),
                      label: Text(
                        'Gửi lại Email',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: APIsAuth.firebaseAuth.signOut,
                      child: Text(
                        "Đóng",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
}
