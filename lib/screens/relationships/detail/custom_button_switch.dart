import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/widgets/customize_switch_button.dart';

class MySliverButtonSwicth extends SliverPersistentHeaderDelegate {
  final Users user;
  final UserRelationship userRelationship;
  final Function(bool page) onChangePage;
  MySliverButtonSwicth(
      {required this.user,
      required this.userRelationship,
      required this.onChangePage});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      color: Colors.white,
      child: MyAnimatedToggle(
        values: ['Thông tin', 'Chăm sóc'],
        onToggleCallback: (value) {
          onChangePage(value);
        },
        buttonColorLeft: Colors.orange[600]!,
        buttonColorRight: Colors.orange[600]!,
        backgroundColor: Colors.grey[400]!,
        textColor: Colors.black,
        buttonHeight: 60.sp,
        buttonWidth: ScreenUtil().screenWidth,
      ),
    );
  }

  @override
  double get maxExtent => 90.sp;

  @override
  double get minExtent => 90.sp;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
