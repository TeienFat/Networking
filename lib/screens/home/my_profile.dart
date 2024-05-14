import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/screens/relationships/detail/list_info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.myId});
  final String myId;
  @override
  Widget build(BuildContext context) {
    context.read<UserListBloc>().add(LoadUserList());
    return BlocBuilder<UserListBloc, UserListState>(
      builder: (context, state) {
        if (state is UserListUploaded && state.users.isNotEmpty) {
          final users = state.users;
          for (var user in users) {
            if (user.userId!.length == myId.length && user.userId == myId) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75.sp),
                        border: Border.all(color: Colors.white, width: 3.sp)),
                    child: Stack(children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[100],
                        backgroundImage: user.imageUrl != ''
                            ? FileImage(
                                File(user.imageUrl!),
                              ) as ImageProvider
                            : AssetImage('assets/images/user.png'),
                        radius: 70.sp,
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
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
                              offset: Offset(0, 5),
                            ),
                          ]),
                      child: Column(
                        children: [
                          Text(
                            user.userName!,
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: ListInfo.myProfile(
                      user: user,
                    ),
                  ),
                ],
              );
            }
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
