import 'package:flutter/material.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/screens/relationships/share/share_relationship.dart';

enum Menu { setting, share, logout }

class PopupMenuMyProfile extends StatelessWidget {
  const PopupMenuMyProfile({
    super.key,
    // required this.user, required this.userRelationship
  });
  // final String user;
  // final UserRelationship userRelationship;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.more_vert),
      onSelected: (Menu item) async {
        switch (item) {
          case Menu.setting:
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => ShareRelationship(
            //         user: user, userRelationship: userRelationship),
            //   ),
            // );
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
          default:
            APIsAuth.logout();
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/Auth", (route) => false); // FirebaseAuth.instance.signOut();
          // APIs.updateStatus(false);
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
