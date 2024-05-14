import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:networking/apis/apis_chat.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/main.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/models/message_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatRoomCard extends StatefulWidget {
  ChatRoomCard.direct(
      {super.key, required this.chatRoom, required this.userchat})
      : this.groupName = '';
  ChatRoomCard.group(
      {super.key, required this.chatRoom, required this.groupName})
      : this.userchat = null;

  final ChatRoom chatRoom;
  final Users? userchat;
  final String groupName;

  @override
  State<ChatRoomCard> createState() => _ChatRoomCardState();
}

class _ChatRoomCardState extends State<ChatRoomCard> {
  MessageChat? _message;
  String? msg;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text("Xoá đoạn chat này?"),
                        content: Container(
                          child: Text(
                              "Bạn không thể hoàn tác sau khi xoá cuộc trò chuyện này."),
                        ),
                        actions: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.grey)),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("Huỷ")),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.red)),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                APIsChat.deleteChatRoom(
                                    widget.chatRoom.chatroomid!);
                              },
                              child: Text("Xoá"))
                        ],
                      ));
            },
            backgroundColor: Color.fromARGB(255, 219, 38, 6),
            foregroundColor: Colors.white,
            icon: FontAwesomeIcons.trash,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (widget.chatRoom.type!) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatScreen.direct(
                      chatRoom: widget.chatRoom,
                      userChat: widget.userchat,
                    )));
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen.group(
                    chatRoom: widget.chatRoom, groupName: widget.groupName),
              ),
            );
          }
        },
        child: StreamBuilder(
            stream: APIsChat.getLastMessage(widget.chatRoom.chatroomid!),
            builder: (context, lastMessageSnapshot) {
              if (lastMessageSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!lastMessageSnapshot.hasData ||
                  lastMessageSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'Không tìm thấy tin nhắn nào',
                  ),
                );
              }
              if (lastMessageSnapshot.hasError) {
                return const Center(
                  heightFactor: 10,
                  child: Text(
                    'Có gì đó sai sai',
                  ),
                );
              }
              final data = lastMessageSnapshot.data!.docs;
              final list =
                  data.map((e) => MessageChat.fromMap(e.data())).toList();
              if (list.isNotEmpty) _message = list[0];
              switch (_message!.type) {
                case TypeSend.image:
                  msg = 'Đã gửi một ảnh';
                  break;
                case TypeSend.video:
                  msg = 'Đã gửi một video';
                  break;
                default:
                  msg = _message!.msg;
              }
              if (_message!.fromId == currentUserId &&
                  _message!.type! != TypeSend.sound) {
                msg = "Bạn: " + msg!;
              }
              if (_message!.fromId != currentUserId &&
                  _message!.type! != TypeSend.notification) {
                msg = APIsChat.getLastWordOfName(_message!.userName!) +
                    ": " +
                    msg!;
              }
              return Container(
                margin: const EdgeInsets.only(bottom: 12, top: 16),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: CircleAvatar(
                              backgroundColor: Colors.amber,
                              radius: 30,
                              backgroundImage: widget.chatRoom.type!
                                  ? (widget.userchat!.imageUrl!.isNotEmpty
                                      ? NetworkImage(widget.userchat!.imageUrl!)
                                      : AssetImage('assets/images/user.png')
                                          as ImageProvider)
                                  : (widget.chatRoom.imageUrl != ''
                                      ? NetworkImage(widget.chatRoom.imageUrl!)
                                      : AssetImage(
                                              'assets/images/group_chat.png')
                                          as ImageProvider)),
                        ),
                        if (widget.chatRoom.type! && widget.userchat!.isOnline!)
                          Positioned(
                            right: -1,
                            top: -1,
                            child: Container(
                              width: 17,
                              height: 17,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(44, 192, 105, 1),
                                  shape: BoxShape.circle,
                                  border: Border.symmetric(
                                      horizontal: BorderSide(
                                          width: 2, color: Colors.white),
                                      vertical: BorderSide(
                                          width: 2, color: Colors.white))),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.chatRoom.type!
                            ? Text(
                                widget.userchat!.userName!,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              )
                            : Text(
                                widget.chatRoom.chatroomname != ''
                                    ? widget.chatRoom.chatroomname!
                                    : widget.groupName,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                        Row(
                          children: [
                            _message == null
                                ? SizedBox()
                                : Container(
                                    width: 190,
                                    child: !_message!.read!
                                                .contains(currentUserId) &&
                                            _message!.fromId != currentUserId
                                        ? Text(
                                            msg!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : Text(
                                            msg!,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                            SizedBox(
                              width: 10,
                            ),
                            Text(MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent!)),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    _message == null
                        ? SizedBox()
                        : !_message!.read!.contains(currentUserId) &&
                                _message!.fromId != currentUserId
                            ? Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent.shade400,
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            : SizedBox()
                  ],
                ),
              );
            }),
      ),
    );
  }
}
