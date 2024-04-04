import 'package:flutter/material.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/edit/edit_relationship.dart';

enum Menu { notification, edit, share, remove }

class PopupMenuDetailRelationship extends StatefulWidget {
  const PopupMenuDetailRelationship(
      {super.key, required this.user, required this.userRelationship});
  final Users user;
  final UserRelationship userRelationship;
  @override
  State<PopupMenuDetailRelationship> createState() =>
      _PopupMenuDetailRelationshipState();
}

class _PopupMenuDetailRelationshipState
    extends State<PopupMenuDetailRelationship> {
  void _onRemoveRelationship() {}

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.more_vert),
      onSelected: (Menu item) {
        switch (item) {
          case Menu.notification:
            print("A");
            break;
          case Menu.edit:
            print("E");
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditRelationship(
                    user: widget.user,
                    userRelationship: widget.userRelationship),
              ),
            );
            break;
          case Menu.share:
            print("S");
            APIsUsRe.getAllMyRelationship();

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
                      APIsUsRe.removeUsRe(widget.userRelationship.usReId!);
                      APIsUser.removeUser(widget.user.userId!);
                      Navigator.pop(context);
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/Main", (route) => false);
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
