import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/relationship_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/widgets/relationship_card.dart';

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
  // int _currentListNum = 0;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Chọn mối quan hệ muốn cập nhật"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<UsReListBloc, UsReListState>(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        searchBar(() => _runFilter("_enteredKeyword"),
                            ScreenUtil().screenWidth - 20),
                      ],
                    ),
                    SizedBox(
                      height: 5.sp,
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
                                      return widget.type
                                          ? RelationShipCard.update(
                                              userRelationship: usRes[index],
                                              user: user,
                                              newUser: widget.newUser,
                                              newRelationships:
                                                  widget.newRelationships,
                                            )
                                          : RelationShipCard
                                              .updateFromPhonebook(
                                              userRelationship: usRes[index],
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
                        itemCount: usRes.length,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: Text("Hãy thiết lập các mối quan hệ mới"),
            );
          },
        ),
      ),
    );
  }
}
