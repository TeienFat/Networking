import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/detail/custom_appbar.dart';
import 'package:networking/screens/relationships/detail/custom_button_switch.dart';
import 'package:networking/screens/relationships/detail/list_info.dart';

class DetailRelationship extends StatefulWidget {
  const DetailRelationship(
      {super.key, required this.user, required this.userRelationship});
  final Users user;
  final UserRelationship userRelationship;

  @override
  State<DetailRelationship> createState() => _DetailRelationshipState();
}

class _DetailRelationshipState extends State<DetailRelationship> {
  bool _page = true;
  void _onChangePage(bool page) {
    setState(() {
      _page = page;
    });
  }

  void _onRemoveRelationship() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: MySliverAppBar(
                expandedHeight: ScreenUtil().screenHeight / 2.4,
                user: widget.user,
                userRelationship: widget.userRelationship),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: MySliverButtonSwicth(
                user: widget.user,
                userRelationship: widget.userRelationship,
                onChangePage: _onChangePage),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _page
                  ? Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: ListInfo(user: widget.user),
                    )
                  : Column(
                      children: [
                        listCardWidget(
                            text1: 'ĐÂY LÀ MỤC CHĂM SÓC:', text2: 'SỐ 1'),
                        listCardWidget(
                            text1: 'ĐÂY LÀ MỤC CHĂM SÓC:', text2: 'SỐ 2'),
                        listCardWidget(
                            text1: 'ĐÂY LÀ MỤC CHĂM SÓC:', text2: 'SỐ 3'),
                        listCardWidget(
                            text1: 'ĐÂY LÀ MỤC CHĂM SÓC:', text2: 'SỐ 4'),
                        listCardWidget(
                            text1: 'ĐÂY LÀ MỤC CHĂM SÓC:', text2: 'SỐ 5'),
                        listCardWidget(
                            text1: 'ĐÂY LÀ MỤC CHĂM SÓC:', text2: 'SỐ 6'),
                        listCardWidget(
                            text1: 'ĐÂY LÀ MỤC CHĂM SÓC:', text2: 'SỐ 7'),
                        listCardWidget(
                            text1: 'ĐÂY LÀ MỤC CHĂM SÓC:', text2: 'SỐ 8'),
                        listCardWidget(
                            text1: 'ĐÂY LÀ MỤC CHĂM SÓC:', text2: 'SỐ 9'),
                        listCardWidget(
                            text1: 'ĐÂY LÀ MỤC CHĂM SÓC:', text2: 'SỐ 10'),
                        listCardWidget(
                            text1: 'ĐÂY LÀ MỤC CHĂM SÓC:', text2: 'SỐ 11'),
                      ],
                    ),
            ]),
          )
        ],
      ),
    ));
  }

  Widget listCardWidget({required String text1, required text2}) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                fit: FlexFit.tight,
                child: Text(
                  text1,
                  style: const TextStyle(fontSize: 18),
                )),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Text(
                text2,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
