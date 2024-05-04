import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:networking/bloc/usRe_list/us_re_list_bloc.dart';
import 'package:networking/bloc/user_list/user_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/edit/edit_relationship.dart';
import 'package:networking/screens/relationships/share/share_relationship.dart';

enum Menu { notification, edit, share, remove }

class PopupMenuDetailRelationship extends StatelessWidget {
  const PopupMenuDetailRelationship(
      {super.key, required this.user, required this.userRelationship});
  final Users user;
  final UserRelationship userRelationship;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.more_vert),
      onSelected: (Menu item) {
        switch (item) {
          case Menu.notification:
            break;
          case Menu.edit:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditRelationship(
                    user: user, userRelationship: userRelationship),
              ),
            );
            break;
          case Menu.share:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ShareRelationship(
                    user: user, userRelationship: userRelationship),
              ),
            );

            break;
          default:
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  "Xóa mối quan hệ",
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "Bạn chắc chắn muốn xóa mối quan hệ này?",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Hủy"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () {
                      if (user.imageUrl! != '') {
                        File(user.imageUrl!).delete();
                      }

                      context
                          .read<UsReListBloc>()
                          .add(DeleteUsRe(usReId: userRelationship.usReId!));
                      context
                          .read<UserListBloc>()
                          .add(DeleteUser(userId: user.userId!));
                      showSnackbar(
                        context,
                        "Đã xóa mối quan hệ",
                        Duration(seconds: 3),
                        true,
                      );
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    },
                    child: Text("Xóa"),
                  ),
                ],
              ),
            );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.notification,
          child: ListTile(
            leading: Icon(Icons.edit_notifications),
            title: Text('Thông báo'),
          ),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.edit,
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Chỉnh sửa'),
          ),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.share,
          child: ListTile(
            leading: Icon(Icons.share_outlined),
            title: Text('Chia sẻ'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<Menu>(
          value: Menu.remove,
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Xóa'),
          ),
        ),
      ],
    );
  }
}
