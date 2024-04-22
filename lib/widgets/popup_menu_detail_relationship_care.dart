import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/bloc/reCare_list/re_care_list_bloc.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_relationship_model.dart';

enum Menu { edit, remove }

class PopupMenuDetailRelationshipCare extends StatefulWidget {
  const PopupMenuDetailRelationshipCare({
    super.key,
    required this.reCare,
    required this.userRelationship,
  });
  final RelationshipCare reCare;
  final UserRelationship userRelationship;
  @override
  State<PopupMenuDetailRelationshipCare> createState() =>
      _PopupMenuDetailRelationshipCareState();
}

class _PopupMenuDetailRelationshipCareState
    extends State<PopupMenuDetailRelationshipCare> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.more_vert),
      onSelected: (Menu item) {
        switch (item) {
          case Menu.edit:
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => EditRelationship(
            //         user: widget.user,
            //         userRelationship: widget.userRelationship),
            //   ),
            // );
            break;

          default:
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  "Xóa mối mục chăm sóc",
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "Bạn chắc chắn muốn xóa mục chăm sóc này?",
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
                      if (widget.reCare.contentImage!.isNotEmpty) {
                        for (var image in widget.reCare.contentImage!) {
                          File(image).delete();
                        }
                      }

                      context
                          .read<ReCareListBloc>()
                          .add(DeleteReCare(reCareId: widget.reCare.reCareId!));

                      showSnackbar(
                          context,
                          "Đã xóa mục chăm sóc",
                          Duration(seconds: 3),
                          true,
                          ScreenUtil().screenHeight - 180);
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
        PopupMenuItem<Menu>(
          value: Menu.edit,
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Chỉnh sửa'),
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
