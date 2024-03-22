import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              top: 10.sp, bottom: 10.sp, left: 10.sp, right: 10.sp),
          child: Column(
            children: [
              Text("Heloo"),
            ],
          ),
        ),
      ),
    );
  }
}
