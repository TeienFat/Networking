import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/relationship_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/widgets/relationship_card.dart';
import 'package:tiengviet/tiengviet.dart';

class ListEditRelationship extends StatefulWidget {
  const ListEditRelationship(
      {super.key, required this.newUser, required this.newRelationships})
      : type = true;
  const ListEditRelationship.fromPhonebook(
      {super.key, required this.newUser, required this.newRelationships})
      : type = false;
  final Users? newUser;
  final List<Relationship>? newRelationships;
  final bool type;
  @override
  State<ListEditRelationship> createState() => _ListEditRelationshipState();
}

class _ListEditRelationshipState extends State<ListEditRelationship> {
  var _isSearching = false;
  List<UserRelationship> _usReSearch = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn mối quan hệ muốn cập nhật"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<UserListBloc, UserListState>(
          builder: (context, state) {
            final users = state.users;
            return BlocBuilder<UsReListBloc, UsReListState>(
              builder: (context, state) {
                if (state is UsReListUploaded && state.usRes.isNotEmpty) {
                  var usRes = state.usRes;
                  usRes = usRes
                      .where(
                        (element) => element.deleteAt == null,
                      )
                      .toList();
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

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.sp,
                          ),
                          searchBar(
                              _runFilter, ScreenUtil().screenWidth - 20.sp),
                          SizedBox(
                            height: 20.sp,
                          ),
                          Container(
                            height: ScreenUtil().screenHeight * 0.7,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 5.sp),
                              itemBuilder: (context, index) {
                                if (_isSearching && _usReSearch.isEmpty) {
                                  return Center(
                                      child: Text("Không có mối quan hệ nào"));
                                }
                                final listUsRe =
                                    _isSearching ? _usReSearch : usRes;
                                return Column(
                                  children: [
                                    BlocBuilder<UserListBloc, UserListState>(
                                        builder: (context, state) {
                                      if (state is UserListUploaded &&
                                          state.users.isNotEmpty) {
                                        final users = state.users;
                                        for (var user in users) {
                                          if ((user.userId!.length ==
                                                  listUsRe[index]
                                                      .myRelationShipId!
                                                      .length) &&
                                              (user.userId ==
                                                  listUsRe[index]
                                                      .myRelationShipId!)) {
                                            return widget.type
                                                ? RelationShipCard.update(
                                                    userRelationship:
                                                        listUsRe[index],
                                                    user: user,
                                                    newUser: widget.newUser,
                                                    newRelationships:
                                                        widget.newRelationships,
                                                  )
                                                : RelationShipCard
                                                    .updateFromPhonebook(
                                                    userRelationship:
                                                        listUsRe[index],
                                                    user: user,
                                                    newUser: widget.newUser,
                                                    newRelationships:
                                                        widget.newRelationships,
                                                  );
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
                                  : usRes.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Center(
                  child: Text("Hãy thiết lập các mối quan hệ mới"),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
