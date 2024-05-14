import 'package:networking/apis/apis_chat.dart';
import 'package:networking/main.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/models/message_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/screens/chat/chat_setting.dart';
import 'package:networking/widgets/chat_message.dart';
import 'package:networking/widgets/new_message.dart';
import 'package:networking/widgets/reply_new_message.dart';
import 'package:networking/widgets/requests_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen.group({super.key, required this.chatRoom, required this.groupName})
      : this.userChat = null;
  ChatScreen.direct({super.key, required this.chatRoom, required this.userChat})
      : this.groupName = "";
  final ChatRoom chatRoom;
  final String groupName;
  final Users? userChat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isSearching = false;
  bool _hasReply = false;
  bool _isMe = false;
  var chatRoomName;
  var chatRoomImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.chatRoom.type!) {
      chatRoomName = widget.chatRoom.chatroomname!.isNotEmpty
          ? widget.chatRoom.chatroomname!
          : widget.groupName;
    }
    if (widget.chatRoom.imageUrl!.isNotEmpty) {
      chatRoomImage = widget.chatRoom.imageUrl!;
    }
  }

  MessageChat _messageChat = MessageChat(
      messageId: "",
      fromId: "",
      msg: "",
      read: [],
      sent: "",
      userName: "",
      userImage: "",
      type: TypeSend.text,
      receivers: [],
      isPin: "",
      messageReply: ({}));

  Future<void> goSettingScreen(BuildContext context) async {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => widget.chatRoom.type!
            ? ChatSettingScreen.direct(
                chatRoom: widget.chatRoom, userChat: widget.userChat)
            : ChatSettingScreen.group(
                chatRoom: widget.chatRoom, groupName: widget.groupName),
      ),
    )
        .then((value) {
      if (value != null) {
        setState(() {
          chatRoomName = value['name'];
          chatRoomImage = value['image'];
          if (value['image'] != null) {
            widget.chatRoom.imageUrl = value['image'];
            widget.chatRoom.chatroomname = value['name'];
          }
        });
      }
    });
  }

  late bool isRequests = widget.chatRoom.type! &&
      widget.chatRoom.isRequests! != ({}) &&
      widget.chatRoom.isRequests!['to'] == currentUserId;
  void reLoad(bool block) {
    setState(() {
      if (!block) isRequests = false;
    });
  }

  bool _isUploading = false;
  void _onUpload(bool upLoad) {
    setState(() {
      _isUploading = upLoad;
    });
  }

  void _onReply(bool isMe, MessageChat messageChat) {
    setState(() {
      _hasReply = true;
      _isMe = isMe;
      _messageChat = messageChat;
    });
  }

  void _cancelReply() {
    setState(() {
      _hasReply = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Users> list;
    return Scaffold(
      appBar: AppBar(
        title: widget.chatRoom.type!
            ? StreamBuilder(
                stream:
                    APIsChat.getInfoUser(widget.userChat!.userId.toString()),
                builder: (ctx, usersnapshot) {
                  if (usersnapshot.hasData) {
                    final data = usersnapshot.data!.docs;
                    list = data.map((e) => Users.fromMap(e.data())).toList();
                    return Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.amber,
                              backgroundImage: list[0].imageUrl!.isNotEmpty
                                  ? NetworkImage(list[0].imageUrl!)
                                  : AssetImage('assets/images/user.png')
                                      as ImageProvider,
                            ),
                            if (list[0].isOnline!)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 13,
                                  height: 13,
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
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 225.4,
                                child: Text(
                                  list[0].userName!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              list[0].isOnline!
                                  ? const Text(
                                      'Online',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : const Text(
                                      'Offline',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else
                    return Container();
                },
              )
            : Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.amber,
                    backgroundImage: widget.chatRoom.imageUrl!.isNotEmpty
                        ? NetworkImage(chatRoomImage)
                        : AssetImage('assets/images/group_chat.png')
                            as ImageProvider,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 225.4,
                          child: Text(
                            chatRoomName,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            onPressed: () {
              goSettingScreen(context);
            },
            icon: Icon(Icons.info),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessage(
              chatRoom: widget.chatRoom,
              onMessageSwipe: (messageChat, isMe) {
                _onReply(isMe, messageChat);
              },
            ),
          ),
          if (_isUploading)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 13.0),
                child: CircularProgressIndicator(),
              ),
            ),
          if (_hasReply)
            ReplyNewMessage(
              isMe: _isMe,
              messageChat: _messageChat,
              onCancel: _cancelReply,
            ),
          isRequests
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: RequestsMessage(
                      userChat: widget.userChat!,
                      chatRoomId: widget.chatRoom.chatroomid!,
                      reLoad: reLoad),
                )
              : _hasReply
                  ? NewMessage.reply(
                      chatRoom: widget.chatRoom,
                      onUpload: (upLoad) {
                        _onUpload(upLoad);
                      },
                      messageReply: _messageChat)
                  : NewMessage(
                      chatRoom: widget.chatRoom,
                      onUpload: (upLoad) {
                        _onUpload(upLoad);
                      },
                    ),
        ],
      ),
    );
  }
}
