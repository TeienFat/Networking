import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:tiengviet/tiengviet.dart';

class PickRelationship extends StatefulWidget {
  const PickRelationship({super.key, required this.onPickRelationship});
  final Function(UserRelationship? usRe, Users? user) onPickRelationship;
  @override
  State<PickRelationship> createState() => _PickRelationshipState();
}

class _PickRelationshipState extends State<PickRelationship> {
  final TextEditingController _searchController = TextEditingController();
  var _showList = false;
  var _isSearching = false;
  var _selected = false;
  var _selectedUserName;
  var _selectedRelationships;
  List<UserRelationship> _usReSearch = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsReListBloc, UsReListState>(
      builder: (context, state) {
        if (state is UsReListUploaded && state.usRes.isNotEmpty) {
          final usRes = state.usRes;
          return Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.all(
                  Radius.circular(5.sp),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ]),
            child: Padding(
              padding: EdgeInsets.all(5.sp),
              child: BlocBuilder<UserListBloc, UserListState>(
                builder: (context, state) {
                  if (state is UserListUploaded && state.users.isNotEmpty) {
                    final users = state.users;
                    void _runFilter(String _enteredKeyword) {
                      _usReSearch.clear();
                      for (var usRe in usRes) {
                        for (var user in users) {
                          if ((user.userId!.length ==
                                  usRe.myRelationShipId!.length) &&
                              (user.userId == usRe.myRelationShipId!)) {
                            if (TiengViet.parse(user.userName!)
                                .toLowerCase()
                                .contains(TiengViet.parse(_enteredKeyword)
                                    .toLowerCase())) {
                              _usReSearch.add(usRe);
                            }
                          }
                        }
                      }

                      setState(() {
                        _isSearching = true;
                        _usReSearch;
                      });
                    }

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _selected
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.sp),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _selectedUserName,
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                        SizedBox(
                                          height: 5.sp,
                                        ),
                                        Row(
                                          children: getRowRelationship(
                                              _selectedRelationships,
                                              2,
                                              12.sp,
                                              12.sp),
                                        ),
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Mối quan hệ",
                                      ),
                                      onChanged: (value) {
                                        _runFilter(value);
                                      },
                                      onTap: () {
                                        setState(() {
                                          _showList = true;
                                        });
                                      },
                                    ),
                                  ),
                            Spacer(),
                            IconButton(
                                color: Colors.black,
                                onPressed: _selected
                                    ? () {
                                        setState(() {
                                          _selected = false;
                                          _selectedUserName = null;
                                          _selectedRelationships = null;
                                          widget.onPickRelationship(null, null);
                                          _showList = true;
                                        });
                                      }
                                    : () {
                                        setState(() {
                                          _showList = !_showList;
                                        });
                                      },
                                icon: _selected
                                    ? Icon(Icons.cancel)
                                    : Icon(Icons.arrow_drop_down)),
                            _selected
                                ? SizedBox()
                                : Padding(
                                    padding: EdgeInsets.only(right: 5.sp),
                                    child: Text(
                                      "*",
                                      style: TextStyle(
                                          fontSize: 18.sp, color: Colors.red),
                                    ),
                                  ),
                          ],
                        ),
                        _showList ? hr : SizedBox(),
                        _showList
                            ? Container(
                                height: ScreenUtil().screenHeight * 0.20,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    if (_isSearching && _usReSearch.isEmpty) {
                                      return Center(
                                          child:
                                              Text("Không có mối quan hệ nào"));
                                    }
                                    final listUsRe =
                                        _isSearching ? _usReSearch : usRes;
                                    for (var user in users) {
                                      if ((user.userId!.length ==
                                              listUsRe[index]
                                                  .myRelationShipId!
                                                  .length) &&
                                          (user.userId ==
                                              listUsRe[index]
                                                  .myRelationShipId!)) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              _showList = false;
                                              _selected = true;
                                              _selectedUserName =
                                                  user.userName!;
                                              _selectedRelationships =
                                                  listUsRe[index].relationships;
                                              widget.onPickRelationship(
                                                  listUsRe[index], user);
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.sp),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user.userName!,
                                                  style: TextStyle(
                                                      fontSize: 14.sp),
                                                ),
                                                SizedBox(
                                                  height: 5.sp,
                                                ),
                                                Row(
                                                  children: getRowRelationship(
                                                      listUsRe[index]
                                                          .relationships!,
                                                      2,
                                                      12.sp,
                                                      12.sp),
                                                ),
                                                user.userId !=
                                                        listUsRe.last
                                                            .myRelationShipId
                                                    ? hr
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    return SizedBox();
                                  },
                                  itemCount: _isSearching
                                      ? _usReSearch.isEmpty
                                          ? 1
                                          : _usReSearch.length
                                      : usRes.length,
                                ),
                              )
                            : SizedBox(),
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          );
        }
        return Center(child: Text("Chưa có mối quan hệ nào"));
      },
    );
  }
}
