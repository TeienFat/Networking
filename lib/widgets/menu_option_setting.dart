import 'package:networking/apis/apis_chat.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/main.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:flutter/material.dart';
import 'package:networking/models/message_model.dart';
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
    Future<void> _showDialog(BuildContext context, bool deleteChatRoom) async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(!deleteChatRoom
              ? 'Xóa $username ra khỏi nhóm?'
              : 'Xóa $username ra khỏi nhóm và giải tán nhóm?'),
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
                if (deleteChatRoom) {
                  await APIsChat.deleteChatRoomFull(chatRoom.chatroomid!);
                  toast("Đã giải tán nhóm");
                  Navigator.of(context).pushReplacementNamed("/MainChat");
                } else {
                  await APIsChat.leaveTheGroupChat(chatRoom, userId);
                  await APIsChat.sendMessage(
                      chatRoom,
                      userName + " đã bị xóa khỏi nhóm",
                      TypeSend.notification,
                      null);
                  Navigator.pop(context);
                }
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
                    if (chatRoom.participants!.length == 2) {
                      await _showDialog(context, true);
                    } else {
                      await _showDialog(context, false);
                    }
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
