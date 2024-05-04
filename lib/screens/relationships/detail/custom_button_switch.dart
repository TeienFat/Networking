import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/widgets/customize_switch_button.dart';

class MySliverButtonSwicth extends SliverPersistentHeaderDelegate {
  final Users user;
  final UserRelationship userRelationship;
  final bool page;
  final Function(bool page) onChangePage;
  MySliverButtonSwicth(
      {required this.user,
      required this.userRelationship,
      required this.onChangePage,
      required this.page});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.sp),
          bottomRight: Radius.circular(15.sp),
        ),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      // color: Colors.white,
      child: Column(
        children: [
          MyAnimatedToggle(
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
          if (!page)
            SizedBox(
              height: 10.sp,
            ),
          if (!page)
            BlocBuilder<ReCareListBloc, ReCareListState>(
              builder: (context, state) {
                var success = 0;
                var failure = 0;
                var passed = 0;
                var waiting = 0;
                final reCares = state.reCares;
                for (var reca in reCares) {
                  if (reca.usReId == userRelationship.usReId) {
                    if (reca.isFinish == 1) success += 1;
                    if (reca.isFinish == 0) failure += 1;
                    if (reca.isFinish == -1) passed += 1;
                    if (reca.isFinish == 2) waiting += 1;
                  }
                }
                return Padding(
                  padding: EdgeInsets.all(5.sp),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                        padding: EdgeInsets.all(5.sp),
                        child: Text(
                          "Thống kê các mục chăm sóc",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Thành công",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.sp,
                              ),
                              Text(
                                success.toString(),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.sp,
                              ),
                              Text(
                                "mục",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Thất bại",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.sp,
                              ),
                              Text(
                                failure.toString(),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.sp,
                              ),
                              Text(
                                "mục",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Quá hạn",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.sp,
                              ),
                              Text(
                                passed.toString(),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.sp,
                              ),
                              Text(
                                "mục",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Đang chờ",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.sp,
                              ),
                              Text(
                                waiting.toString(),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.sp,
                              ),
                              Text(
                                "mục",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => page ? 90.sp : 225.sp;

  @override
  double get minExtent => page ? 90.sp : 225.sp;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
