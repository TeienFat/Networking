import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/detail/custom_appbar.dart';
import 'package:networking/screens/relationships/detail/custom_button_switch.dart';
import 'package:networking/screens/relationships/detail/list_info.dart';
import 'package:networking/screens/take_care/new/new_relationship_care.dart';
import 'package:networking/widgets/take_care_card.dart';
import 'package:table_calendar/table_calendar.dart';

class DetailRelationship extends StatefulWidget {
  const DetailRelationship(
      {super.key,
      required this.user,
      required this.userRelationship,
      this.page = true})
      : fromNotification = false;
  const DetailRelationship.fromNotification(
      {super.key,
      required this.user,
      required this.userRelationship,
      this.page = true})
      : fromNotification = true;
  final Users user;
  final UserRelationship userRelationship;
  final bool page;
  final bool fromNotification;

  @override
  State<DetailRelationship> createState() => _DetailRelationshipState();
}

class _DetailRelationshipState extends State<DetailRelationship> {
  late bool _page;
  void _onChangePage(bool page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _page = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsReListBloc, UsReListState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
              child: Material(
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: MySliverAppBar(
                      expandedHeight: ScreenUtil().screenHeight / 2.5,
                      user: widget.user,
                      userRelationship: widget.userRelationship,
                      fromNotification: widget.fromNotification),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: MySliverButtonSwicth(
                      user: widget.user,
                      userRelationship: widget.userRelationship,
                      onChangePage: _onChangePage,
                      page: _page),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _page
                        ? Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: ListInfo(
                                user: widget.user,
                                userRelationship: widget.userRelationship),
                          )
                        : BlocBuilder<ReCareListBloc, ReCareListState>(
                            builder: (context, state) {
                              if (state is ReCareListUploaded &&
                                  state.reCares.isNotEmpty) {
                                final reCares = state.reCares;
                                reCares.sort(
                                  (a, b) {
                                    if (a.endTime!.isBefore(b.endTime!)) {
                                      return 1;
                                    }

                                    if (a.endTime!.isAfter(b.endTime!)) {
                                      return -1;
                                    }
                                    if (isSameDay(a.endTime!, b.endTime!)) {
                                      if (a.startTime!.hour >
                                          b.startTime!.hour) {
                                        return 1;
                                      }
                                      if (a.startTime!.hour ==
                                          b.startTime!.hour) {
                                        if (a.startTime!.minute >=
                                            b.startTime!.minute) return 1;
                                      }
                                      return -1;
                                    }
                                    return 0;
                                  },
                                );
                                List<Widget> listCard = [];
                                for (var reca in reCares) {
                                  if (reca.usReId ==
                                      widget.userRelationship.usReId) {
                                    listCard.add(Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.sp, vertical: 5.sp),
                                      child: ReCareCard(
                                        reCare: reca,
                                        userRelationship:
                                            widget.userRelationship,
                                        listType: 5,
                                      ),
                                    ));
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsets.only(top: 10.sp),
                                  child: Column(
                                    children: listCard,
                                  ),
                                );
                              }
                              return Padding(
                                padding: EdgeInsets.only(top: 50.sp),
                                child: Center(
                                    child: Text(
                                  "Hãy thiết lập chăm sóc mới!",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                )),
                              );
                            },
                          ),
                    SizedBox(height: 100.sp),
                  ]),
                )
              ],
            ),
          )),
          floatingActionButton: _page
              ? null
              : FloatingActionButton(
                  backgroundColor: Colors.orange[600],
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewRelationshipCare.fromUsRe(
                          userRelationship: widget.userRelationship,
                          users: widget.user,
                          initStartDay: DateTime.now(),
                          initEndDay: DateTime.now(),
                        ),
                      )),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 35.sp,
                  ),
                ),
        );
      },
    );
  }
}
