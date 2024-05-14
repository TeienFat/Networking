import 'package:networking/apis/apis_chat.dart';
import 'package:networking/main.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:flutter/material.dart';
import 'package:networking/screens/chat/profile_of_others.dart';

class MenuOptionSetting extends StatelessWidget {
  const MenuOptionSetting(
      {super.key,
      required this.chatRoom,
      required this.userId,
      required this.userName});
  final ChatRoom chatRoom;
  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    String username = APIsChat.getLastWordOfName(userName);
    Future<void> _showDialog(BuildContext context) async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Xóa $username ra khỏi nhóm?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.blue[400],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await APIsChat.leaveTheGroupChat(chatRoom, userId);
                Navigator.pop(context);
              },
              child: Text(
                'Xóa',
                style: TextStyle(
                  color: kColorScheme.error,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: chatRoom.admin == currentUserId
              ? constraints.maxHeight / 4
              : constraints.maxHeight / 6,
          child: Column(
            children: [
              if (chatRoom.admin == currentUserId)
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await _showDialog(context);
                  },
                  child: Container(
                    height: chatRoom.admin == currentUserId
                        ? constraints.maxHeight / 15
                        : constraints.maxHeight / 14,
                    width: constraints.maxWidth,
                    child: Center(
                      child: Text(
                        "Xóa khỏi đoạn chat",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              if (chatRoom.admin == currentUserId) Divider(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileOfOthersScreen(
                                id: userId,
                              )));
                },
                child: Container(
                  height: chatRoom.admin == currentUserId
                      ? constraints.maxHeight / 15
                      : constraints.maxHeight / 14,
                  width: constraints.maxWidth,
                  child: Center(
                    child: Text(
                      "Xem thông tin cá nhân",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: chatRoom.admin == currentUserId
                      ? constraints.maxHeight / 15
                      : constraints.maxHeight / 14,
                  width: constraints.maxWidth,
                  child: Center(
                    child: Text(
                      "Đóng",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
