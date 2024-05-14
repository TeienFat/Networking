import 'package:networking/apis/apis_chat.dart';
import 'package:networking/widgets/bubble_image.dart';
import 'package:networking/widgets/bubble_video.dart';
import 'package:flutter/material.dart';
import 'package:networking/models/message_model.dart';

class ReplyBubble extends StatelessWidget {
  const ReplyBubble({
    super.key,
    required this.chatRoomId,
    required this.messageReplyFromId,
    required this.messageReplyUserName,
    required this.messageReplyMsg,
    required this.messageReplyType,
    required this.messageSent,
    required this.isMe,
  });
  final String chatRoomId;
  final String messageReplyFromId;
  final String messageReplyUserName;
  final String messageReplyMsg;
  final TypeSend messageReplyType;
  final MessageChat messageSent;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    String? titleReply;
    if (messageSent.fromId == messageReplyFromId && isMe) {
      titleReply = 'Bạn đã trả lời chính mình';
    }
    if (messageSent.fromId == messageReplyFromId && !isMe) {
      titleReply = messageReplyUserName + ' đã trả lời chính mình';
    }
    if (messageSent.fromId != messageReplyFromId && isMe) {
      titleReply = 'Bạn đã trả lời ' + messageReplyUserName;
    }
    if (messageSent.fromId != messageReplyFromId &&
        !isMe &&
        messageReplyFromId == APIsChat.firebaseAuth.currentUser!.uid) {
      titleReply = messageSent.userName! + ' đã trả lời bạn';
    } else {
      if (messageSent.fromId != messageReplyFromId && !isMe) {
        titleReply =
            messageSent.userName! + ' đã trả lời ' + messageReplyUserName;
      }
    }

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: isMe ? 0 : 10, right: isMe ? 10 : 0),
          child: Row(
            children: [
              Icon(
                Icons.reply,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                titleReply!,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Container(
          decoration: messageReplyType == TypeSend.text
              ? BoxDecoration(
                  color: Color.fromARGB(10, 0, 0, 0),
                  borderRadius: BorderRadius.only(
                    bottomLeft: !isMe ? Radius.zero : const Radius.circular(12),
                    bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                  ),
                )
              : null,
          constraints: const BoxConstraints(
            maxWidth: 240,
          ),
          padding: messageReplyType == TypeSend.text
              ? const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                )
              : null,
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              messageReplyType == TypeSend.text
                  ? Text(
                      messageReplyMsg,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        color: Colors.black87,
                      ),
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )
                  : messageReplyType == TypeSend.image
                      ? ImageBubble(imageUrl: messageReplyMsg, isMe: isMe)
                      : messageReplyType == TypeSend.video
                          ? VideoBubble(
                              videoUrl: messageReplyMsg,
                              isMe: isMe,
                            )
                          : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
