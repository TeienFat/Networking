import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/main.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/widgets/relationship_card.dart';
import 'package:tiengviet/tiengviet.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({
    super.key,
  });
  // final List<UserRelationship> usReList;
  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredNumDay;
  String? _getUserName(List<Users> users, String userId) {
    for (var user in users) {
      if (user.userId!.length == userId.length && user.userId! == userId) {
        return user.userName!.split(' ').last;
      }
    }
    return null;
  }

  Users? _getUser(List<Users> users, String userId) {
    for (var user in users) {
      if (user.userId!.length == userId.length && user.userId! == userId) {
        return user;
      }
    }
    return null;
  }

  void _initNumDay() async {
    final my = await APIsUser.getUserFromId(currentUserId);
    _enteredNumDay = my!.numDayOfAutoDelete!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _initNumDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mối quan hệ xóa gần đây"),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.sp),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      title: Text(
                        "Thay đổi thời gian tự động xóa mối quan hệ",
                        textAlign: TextAlign.center,
                      ),
                      content: Form(
                          key: _formKey,
                          child: TextFormField(
                            initialValue: _enteredNumDay.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Nhập số ngày tự đông xóa",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Vui lòng không để trống";
                              }
                              if (value.length <= 0) {
                                return 'Số ngày không hợp lệ';
                              }

                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredNumDay = int.parse(newValue!);
                            },
                          )),
                      actions: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.grey)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Hủy"),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.green)),
                          onPressed: () {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              context.read<UserListBloc>().add(
                                  UpdateUserNumDayOfAutoDelete(
                                      userId: currentUserId,
                                      numDayOfAutoDelete: _enteredNumDay));
                              showSnackbar(
                                context,
                                "Đã thay đổi thời gian tự động xóa",
                                Duration(seconds: 3),
                                true,
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text("Xác nhận"),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.timer_sharp,
                  size: 30.sp,
                )),
          )
        ],
      ),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          final users = state.users;
          return BlocBuilder<ReCareListBloc, ReCareListState>(
            builder: (context, state) {
              final reCares = state.reCares;
              return BlocBuilder<UsReListBloc, UsReListState>(
                builder: (context, state) {
                  var usRes = state.usRes;
                  usRes = usRes
                      .where(
                        (element) => element.deleteAt != null,
                      )
                      .toList();
                  final my = _getUser(users, currentUserId);
                  _enteredNumDay = my!.numDayOfAutoDelete!;

                  if (state is UsReListUploaded && usRes.isNotEmpty) {
                    for (var us in usRes) {
                      final timeCheck = currentUserId ==
                              '44f5bf86-81c1-4cc5-970d-dc4b83c872d9'
                          ? DateTime.now().difference(us.deleteAt!).inMinutes >=
                              1
                          : DateTime.now().difference(us.deleteAt!).inDays >=
                              my.numDayOfAutoDelete!;
                      if (timeCheck) {
                        final u = _getUser(users, us.myRelationShipId!);

                        if (u!.imageUrl! != '') {
                          File(u.imageUrl!).delete();
                        }
                        for (var reca in reCares) {
                          if (reca.usReId!.length == us.usReId!.length &&
                              reca.usReId == us.usReId) {
                            if (reca.contentImage!.isNotEmpty) {
                              for (var image in reca.contentImage!) {
                                File(image).delete();
                              }
                            }
                            context.read<ReCareListBloc>().add(DeleteReCare(
                                reCareId: reca.reCareId!, usRe: us));
                          }
                        }
                        context
                            .read<UsReListBloc>()
                            .add(DeleteUsRe(usReId: us.usReId!));
                        context
                            .read<UserListBloc>()
                            .add(DeleteUser(userId: u.userId!));
                      }
                    }
                    List<UserRelationship> usReSort = usRes;
                    usReSort.sort(
                      (a, b) {
                        final userNameA =
                            _getUserName(users, a.myRelationShipId!);
                        final userNameB =
                            _getUserName(users, b.myRelationShipId!);
                        return TiengViet.parse(userNameA!.toLowerCase())
                            .compareTo(
                                TiengViet.parse(userNameB!.toLowerCase()));
                      },
                    );

                    return Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: Column(
                        children: [
                          Container(
                            height: ScreenUtil().screenHeight * 0.68,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 5.sp),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    for (var user in users)
                                      if ((user.userId!.length ==
                                              usReSort[index]
                                                  .myRelationShipId!
                                                  .length) &&
                                          (user.userId ==
                                              usReSort[index]
                                                  .myRelationShipId!))
                                        Column(
                                          children: [
                                            RelationShipCard.trash(
                                                userRelationship:
                                                    usReSort[index],
                                                user: user),
                                            SizedBox(
                                              height: 10.sp,
                                            )
                                          ],
                                        ),
                                  ],
                                );
                              },
                              itemCount: usReSort.length,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 180.sp, bottom: 20.sp),
                          child: Icon(
                            FontAwesomeIcons.trashCan,
                            size: 200.sp,
                            color: Colors.grey[300],
                          ),
                        ),
                        Text(
                          "Thùng rác trống",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
