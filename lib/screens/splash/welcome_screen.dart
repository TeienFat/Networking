import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:networking/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 100.sp),
                          child: Image.asset(
                            'assets/images/wel-1.png',
                          ),
                        ),
                        SizedBox(height: 60.sp),
                        Text(
                          "Kết nối các mối quan hệ",
                          style: GoogleFonts.lobster(
                            color: kColorScheme.primary,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(100.sp, 45.sp),
                              backgroundColor: kColorScheme.primary,
                              foregroundColor: kColorScheme.onPrimary),
                          onPressed: () {
                            controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.linear);
                          },
                          child: Text(
                            "Tiếp",
                            style: GoogleFonts.lobster(
                              fontSize: 22.sp,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 100.sp),
                          child: Image.asset(
                            'assets/images/wel-2.png',
                          ),
                        ),
                        SizedBox(height: 80.sp),
                        Text(
                          "Chăm sóc các mối quan hệ",
                          style: GoogleFonts.lobster(
                            color: kColorScheme.primary,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(100.sp, 45.sp),
                              backgroundColor: kColorScheme.primary,
                              foregroundColor: kColorScheme.onPrimary),
                          onPressed: () {
                            controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.linear);
                          },
                          child: Text(
                            "Tiếp",
                            style: GoogleFonts.lobster(
                              fontSize: 22.sp,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 140.sp),
                          child: Image.asset(
                            'assets/images/wel-3.png',
                          ),
                        ),
                        SizedBox(height: 21.sp),
                        Text(
                          "Dễ dàng lập lịch chăm sóc",
                          style: GoogleFonts.lobster(
                            color: kColorScheme.primary,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(100.sp, 45.sp),
                              backgroundColor: kColorScheme.primary,
                              foregroundColor: kColorScheme.onPrimary),
                          onPressed: () {
                            controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.linear);
                          },
                          child: Text(
                            "Tiếp",
                            style: GoogleFonts.lobster(
                              fontSize: 22.sp,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 180.sp),
                          child: Image.asset(
                            'assets/images/wel-4.png',
                          ),
                        ),
                        SizedBox(height: 66.sp),
                        Text(
                          "Sẵn sàng trò chuyện mọi nơi",
                          style: GoogleFonts.lobster(
                            color: kColorScheme.primary,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(200.sp, 45.sp),
                              backgroundColor: kColorScheme.primary,
                              foregroundColor: kColorScheme.onPrimary),
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "/Auth", (route) => false);
                          },
                          child: Text(
                            "Bắt đầu ngay",
                            style: GoogleFonts.lobster(
                              fontSize: 22.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.sp,
            ),
            SmoothPageIndicator(
              controller: controller,
              count: 4,
              effect: WormEffect(
                  dotHeight: 16,
                  dotWidth: 16,
                  type: WormType.normal,
                  activeDotColor: kColorScheme.primary),
            ),
            SizedBox(
              height: 10.sp,
            ),
          ],
        ),
      ),
    );
  }
}
