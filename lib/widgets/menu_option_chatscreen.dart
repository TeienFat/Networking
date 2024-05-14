import 'package:networking/apis/apis_chat.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MenuChatScreen extends StatelessWidget {
  const MenuChatScreen(
      {super.key,
      required this.messageId,
      required this.chatroomId,
      required this.isPin});
  final bool isPin;
  final String messageId;
  final String chatroomId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight / 8,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                        iconSize: 35,
                        onPressed: () {
                          if (isPin) {
                            APIsChat.pinMessage(messageId, chatroomId, false);
                            Fluttertoast.showToast(
                                msg: "Đã bỏ ghim tin nhắn",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            APIsChat.pinMessage(messageId, chatroomId, true);
                            Fluttertoast.showToast(
                                msg: "Ghim tin nhắn thành công",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          Navigator.pop(context);
                        },
                        icon: isPin
                            ? Icon(Icons.bookmark_remove)
                            : Icon(Icons.push_pin)),
                    isPin
                        ? Text(
                            "Bỏ ghim",
                            style: TextStyle(fontSize: 20),
                          )
                        : Text(
                            "Ghim",
                            style: TextStyle(fontSize: 20),
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
