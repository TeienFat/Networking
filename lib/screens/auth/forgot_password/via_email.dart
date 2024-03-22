import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViaEmail extends StatefulWidget {
  ViaEmail({super.key});

  @override
  State<ViaEmail> createState() => _ViaEmailState();
}

class _ViaEmailState extends State<ViaEmail> {
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
              Text("Hãy nhập Email"),
            ],
          ),
        ),
      ),
    );
  }
}
