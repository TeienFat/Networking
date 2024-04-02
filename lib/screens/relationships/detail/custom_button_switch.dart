import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';

class MySliverButtonSwicth extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Users user;
  final UserRelationship userRelationship;
  MySliverButtonSwicth(
      {required this.expandedHeight,
      required this.user,
      required this.userRelationship});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container();
  }

  @override
  double get maxExtent => 200.sp;

  @override
  double get minExtent => 70.sp;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
