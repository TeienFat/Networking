import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/chatbot/chatbot_screen.dart';
import 'package:networking/widgets/relationship_card.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tiengviet/tiengviet.dart';

class RelationshipScreen extends StatefulWidget {
  const RelationshipScreen({super.key});

  @override
  State<RelationshipScreen> createState() => _RelationshipScreenState();
}

class _RelationshipScreenState extends State<RelationshipScreen> {
  int _currentListNum = 0;
  var _isSearching = false;
  List<UserRelationship> _usReSearch = [];

  Users? _getUser(List<Users> users, String userId) {
    for (var user in users) {
      if (user.userId!.length == userId.length && user.userId! == userId) {
        return user;
      }
    }
    return null;
  }

  bool _checkInWeek(DateTime targetDate) {
    DateTime today = DateTime.now();
    DateTime oneWeekAgo = today.subtract(Duration(days: 7));
    if (targetDate.isAfter(oneWeekAgo) && targetDate.isBefore(today)) {
      return true;
    } else {
      return false;
    }
  }

  DateTime _getLastDayOfSuccess(List<RelationshipCare> reCares, String usReId) {
    reCares = reCares
        .where((element) => element.usReId == usReId && element.isFinish == 1)
        .toList();
    reCares.sort(
      (a, b) {
        if (a.endTime!.isBefore(b.endTime!)) {
          return 1;
        }
        if (a.endTime!.isAfter(b.endTime!)) {
          return -1;
        }
        if (isSameDay(a.endTime!, b.endTime!)) {
          if (a.startTime!.hour > b.startTime!.hour) {
            return 1;
          }
          if (a.startTime!.hour == b.startTime!.hour) {
            if (a.startTime!.minute >= b.startTime!.minute) return 1;
          }
          return -1;
        }
        return 0;
      },
    );
    return reCares.first.endTime!;
  }

  bool _checkContainsUsRe(String usReId) {
    for (var usRe in _usReSearch) {
      if (usRe.usReId!.length == usReId.length && usRe.usReId! == usReId) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    List<Container> _listTextButton = [
      Container(
        decoration: BoxDecoration(
          color: _currentListNum == 0 ? Colors.grey[300] : null,
          borderRadius: BorderRadius.all(Radius.circular(20.sp)),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              _currentListNum = 0;
              _isSearching = false;
              _usReSearch = [];
            });
          },
          child: Text('Tất cả'),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: _currentListNum == 1 ? Colors.grey[300] : null,
          borderRadius: BorderRadius.all(Radius.circular(20.sp)),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              _currentListNum = 1;
              _isSearching = false;
              _usReSearch = [];
            });
          },
          child: Text('Mới thêm'),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: _currentListNum == 2 ? Colors.grey[300] : null,
          borderRadius: BorderRadius.all(Radius.circular(20.sp)),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              _currentListNum = 2;
              _isSearching = false;
              _usReSearch = [];
            });
          },
          child: Text('Đã chăm sóc'),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: _currentListNum == 3 ? Colors.grey[300] : null,
          borderRadius: BorderRadius.all(Radius.circular(20.sp)),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              _currentListNum = 3;
              _isSearching = false;
              _usReSearch = [];
            });
          },
          child: Text('Chưa chăm sóc'),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: _currentListNum == 4 ? Colors.grey[300] : null,
          borderRadius: BorderRadius.all(Radius.circular(20.sp)),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              _currentListNum = 4;
              _isSearching = false;
              _usReSearch = [];
            });
          },
          child: Text('Chăm sóc đặc biệt'),
        ),
      ),
    ];
    return Column(
      children: [
        BlocBuilder<ReCareListBloc, ReCareListState>(
          builder: (context, state) {
            final reCares = state.reCares;
            return BlocBuilder<UsReListBloc, UsReListState>(
              builder: (context, state) {
                if (state is UsReListUploaded && state.usRes.isNotEmpty) {
                  final usRes = state.usRes;
                  List<UserRelationship> usReSort = usRes;
                  switch (_currentListNum) {
                    case 1:
                      usReSort = usRes
                          .where((element) => _checkInWeek(element.createdAt!))
                          .toList();
                      usReSort.sort(
                        (a, b) {
                          if (a.createdAt!.isBefore(b.createdAt!)) {
                            return 1;
                          }

                          if (a.createdAt!.isAfter(b.createdAt!)) {
                            return -1;
                          }
                          return 0;
                        },
                      );
                      break;
                    case 2:
                      usReSort = usRes
                          .where((element) => element.time_of_care! > 0)
                          .toList();
                      usReSort.sort(
                        (a, b) {
                          final timeA =
                              _getLastDayOfSuccess(reCares, a.usReId!);
                          final timeB =
                              _getLastDayOfSuccess(reCares, b.usReId!);
                          if (timeA.isBefore(timeB)) {
                            return 1;
                          }
                          if (timeA.isAfter(timeB)) {
                            return -1;
                          }
                          return 0;
                        },
                      );

                      break;
                    case 3:
                      usReSort = usRes
                          .where((element) => element.time_of_care == 0)
                          .toList();

                      break;
                    case 4:
                      usReSort = usRes
                          .where((element) => element.special == true)
                          .toList();

                      break;
                    default:
                      usReSort = usRes;
                  }
                  return BlocBuilder<UserListBloc, UserListState>(
                    builder: (context, state) {
                      final users = state.users;
                      void _runFilter(String _enteredKeyword) {
                        _usReSearch.clear();
                        for (var usRe in usReSort) {
                          for (var user in users) {
                            if ((user.userId!.length ==
                                    usRe.myRelationShipId!.length) &&
                                (user.userId == usRe.myRelationShipId!)) {
                              for (var rela in usRe.relationships!) {
                                if (TiengViet.parse(user.userName!)
                                        .toLowerCase()
                                        .contains(
                                            TiengViet.parse(_enteredKeyword)
                                                .toLowerCase()) ||
                                    TiengViet.parse(rela.name!)
                                        .toLowerCase()
                                        .contains(
                                            TiengViet.parse(_enteredKeyword)
                                                .toLowerCase())) {
                                  if (!_checkContainsUsRe(usRe.usReId!)) {
                                    _usReSearch.add(usRe);
                                  }
                                }
                              }
                            }
                          }
                        }
                        setState(() {
                          _isSearching = true;
                          _usReSearch;
                        });
                      }

                      return Padding(
                        padding: EdgeInsets.all(5.sp),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5.sp,
                            ),
                            Row(
                              children: [
                                searchBar(_runFilter,
                                    ScreenUtil().screenWidth - 70.sp),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChatBotScreen(),
                                          ));
                                    },
                                    child: Row(
                                      children: [Icon(FontAwesomeIcons.robot)],
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            Container(
                              height: 40.sp,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      _listTextButton[index],
                                      SizedBox(
                                        width: 10.sp,
                                      ),
                                    ],
                                  );
                                },
                                itemCount: _listTextButton.length,
                              ),
                            ),
                            SizedBox(
                              height: 10.sp,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.sp),
                              height: ScreenUtil().screenHeight * 0.68,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final listUsRe =
                                      _isSearching ? _usReSearch : usReSort;
                                  if (_isSearching && _usReSearch.isEmpty) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 200.sp),
                                        child: Text(
                                          "Không tìm thấy mối quan hệ nào",
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                      ),
                                    );
                                  }
                                  return Column(
                                    children: [
                                      BlocBuilder<UserListBloc, UserListState>(
                                          builder: (context, state) {
                                        if (state is UserListUploaded &&
                                            state.users.isNotEmpty) {
                                          final users = state.users;
                                          usRes.sort(
                                            (a, b) {
                                              final userA = _getUser(
                                                  users, a.myRelationShipId!);
                                              final userB = _getUser(
                                                  users, b.myRelationShipId!);
                                              return userA!.userName!
                                                  .compareTo(userB!.userName!);
                                            },
                                          );

                                          for (var user in users) {
                                            if ((user.userId!.length ==
                                                    listUsRe[index]
                                                        .myRelationShipId!
                                                        .length) &&
                                                (user.userId ==
                                                    listUsRe[index]
                                                        .myRelationShipId!)) {
                                              return RelationShipCard(
                                                  userRelationship:
                                                      listUsRe[index],
                                                  user: user);
                                            }
                                          }
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }),
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                    ],
                                  );
                                },
                                itemCount: _isSearching
                                    ? _usReSearch.isEmpty
                                        ? 1
                                        : _usReSearch.length
                                    : usReSort.length,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 180.sp, right: 50.sp, bottom: 50.sp),
                      child: Icon(
                        FontAwesomeIcons.usersSlash,
                        size: 200.sp,
                        color: Colors.grey[300],
                      ),
                    ),
                    Text(
                      "Chưa có mối quan hệ nào",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
