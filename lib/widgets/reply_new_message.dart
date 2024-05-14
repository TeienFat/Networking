import 'package:networking/models/message_model.dart';
import 'package:flutter/material.dart';

class ReplyNewMessage extends StatelessWidget {
  const ReplyNewMessage(
      {super.key,
      required this.isMe,
      required this.messageChat,
      required this.onCancel});

  final bool isMe;
  final MessageChat messageChat;
  final Function() onCancel;
  @override
  Widget build(BuildContext context) {
    String msgRep;
    switch (messageChat.type) {
      case TypeSend.image:
        msgRep = 'Hình ảnh';
        break;
      case TypeSend.video:
        msgRep = 'Video';
        break;
      default:
        msgRep = messageChat.msg!;
    }
    return Column(
      children: [
        Divider(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isMe
                      ? Text(
                          "Đang trả lời chính bạn",
                          style: TextStyle(fontSize: 15),
                        )
                      : Row(
                          children: [
                            Text(
                              "Đang trả lời ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              messageChat.userName!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        ),
                  Container(
                      width: 280,
                      child: Text(
                        msgRep,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ))
                ],
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: onCancel,
              icon: Icon(Icons.cancel_sharp),
            )
          ],
        )
      ],
    );
  }
}
