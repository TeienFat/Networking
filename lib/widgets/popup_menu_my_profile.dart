import 'package:flutter/material.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_chat.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/screens/my_profile/setting.dart';
import 'package:networking/screens/my_profile/trash.dart';
import 'package:networking/screens/relationships/share/share_relationship.dart';

enum Menu { setting, share, trash, logout }

class PopupMenuMyProfile extends StatelessWidget {
  const PopupMenuMyProfile({super.key});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.more_vert),
      onSelected: (Menu item) async {
        switch (item) {
          case Menu.setting:
            final meId = await APIsAuth.getCurrentUserId();
            Users? user = await APIsUser.getUserFromId(meId!);
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => SettingScreen(
                        myId: meId,
                        notificationEnabled: user!.notification!,
                      )),
            );
            break;
          case Menu.share:
            final meId = await APIsAuth.getCurrentUserId();
            Users? user = await APIsUser.getUserFromId(meId!);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ShareRelationship.myProfile(user: user!),
              ),
            );
            break;
          case Menu.trash:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TrashScreen(),
              ),
            );
            break;
          default:
            final meId = await APIsAuth.getCurrentUserId();
            Users? user = await APIsUser.getUserFromId(meId!);
            if (user!.notification!) {
              APIsUsRe.setNotificationForAllUsRe(false);
            }
            APIsAuth.logout();
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/Auth", (route) => false);
            APIsChat.updateStatus(false);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.setting,
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Cài đặt'),
          ),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.share,
          child: ListTile(
            leading: Icon(Icons.share_outlined),
            title: Text('Chia sẻ'),
          ),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.trash,
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Thùng rác'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<Menu>(
          value: Menu.logout,
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
          ),
        ),
      ],
    );
  }
}
