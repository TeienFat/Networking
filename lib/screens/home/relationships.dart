import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/widgets/relationship_card.dart';

class RelationshipScreen extends StatefulWidget {
  const RelationshipScreen({super.key});

  @override
  State<RelationshipScreen> createState() => _RelationshipScreenState();
}

class _RelationshipScreenState extends State<RelationshipScreen> {
  int _currentListNum = 0;
  // late List<Future<Users?>> _listMyRelationShip;

  void _runFilter(String _enteredKeyword) {
    // _searchList.clear();
    // for (var user in _list) {
    //   if (TiengViet.parse(user.username!)
    //     .toLowerCase()
    //     .contains(TiengViet.parse(_enteredKeyword).toLowerCase())) {
    //   _searchList.add(user);
    //   }
    // }
    // setState(() {
    //   isSearching = true;
    //   _searchList;
    // });
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
            });
          },
          child: Text('Chăm sóc đặc biệt'),
        ),
      ),
    ];
    return BlocBuilder<UsReListBloc, UsReListState>(
      builder: (context, state) {
        if (state is UsReListUploaded && state.usRes.isNotEmpty) {
          final usRes = state.usRes;
          return Padding(
            padding: EdgeInsets.all(5.sp),
            child: Column(
              children: [
                SizedBox(
                  height: 5.sp,
                ),
                Row(
                  children: [
                    searchBar(() => _runFilter("_enteredKeyword")),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.filter_list_outlined,
                        size: 35.sp,
                      ),
                    ),
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
                  height: ScreenUtil().screenHeight * 0.7,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          BlocBuilder<UserListBloc, UserListState>(
                              builder: (context, state) {
                            if (state is UserListUploaded &&
                                state.users.isNotEmpty) {
                              final users = state.users;
                              for (var user in users) {
                                if ((user.userId!.length ==
                                        usRes[index]
                                            .myRelationShipId!
                                            .length) &&
                                    (user.userId ==
                                        usRes[index].myRelationShipId!)) {
                                  return RelationShipCard(
                                      userRelationship: usRes[index],
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
                    itemCount: usRes.length,
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
