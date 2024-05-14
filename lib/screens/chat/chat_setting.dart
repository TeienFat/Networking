import 'package:networking/apis/apis_chat.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/main.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/screens/chat/profile_of_others.dart';
import 'package:networking/widgets/change_name_image_group.dart';
import 'package:networking/screens/chat/list_user_in_group.dart';
import 'package:networking/screens/chat/pin_message_screen.dart';
import 'package:networking/screens/chat/search_message_screen.dart';
import 'package:flutter/material.dart';

class ChatSettingScreen extends StatefulWidget {
  const ChatSettingScreen.direct(
      {super.key, required this.chatRoom, required this.userChat})
      : groupName = "";
  const ChatSettingScreen.group(
      {super.key, required this.chatRoom, required this.groupName})
      : this.userChat = null;
  final ChatRoom chatRoom;
  final String groupName;
  final Users? userChat;
  @override
  State<ChatSettingScreen> createState() => _ChatSettingScreenState();
}

class _ChatSettingScreenState extends State<ChatSettingScreen> {
  var chatRoomName;
  var chatRoomImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatRoomName = widget.chatRoom.chatroomname!.isNotEmpty
        ? widget.chatRoom.chatroomname!
        : widget.groupName;
    if (widget.chatRoom.imageUrl!.isNotEmpty) {
      chatRoomImage = widget.chatRoom.imageUrl!;
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rời khỏi đoạn chat?'),
        content: const Text(
            'Cuộc trò chuyện này sẽ được lưu trữ và bạn sẽ không nhận được bất kì tin nhắn mới nào nữa.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              await APIsChat.leaveTheGroupChat(widget.chatRoom, currentUserId);
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed("/MainChat");
              toast("Đã rời khỏi nhóm");
            },
            child: Text(
              'Rời khỏi',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _blockUser(String userid) async {
    await APIsChat.blockUser(userid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pop({'image': chatRoomImage, 'name': chatRoomName});
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 5, left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.chatRoom.type!
                  ? CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.amber,
                      backgroundImage: widget.userChat!.imageUrl!.isNotEmpty
                          ? NetworkImage(widget.userChat!.imageUrl!)
                          : AssetImage('assets/images/user.png')
                              as ImageProvider,
                    )
                  : CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.amber,
                      backgroundImage: widget.chatRoom.imageUrl!.isNotEmpty
                          ? NetworkImage(chatRoomImage)
                          : AssetImage('assets/images/group_chat.png')
                              as ImageProvider,
                    ),
              SizedBox(
                height: 10,
              ),
              widget.chatRoom.type!
                  ? Text(
                      widget.userChat!.userName!,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      chatRoomName,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              widget.chatRoom.type!
                  ? TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileOfOthersScreen(
                                    id: widget.userChat!.userId!)));
                      },
                      child: Text(
                        'Xem trang cá nhân',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800]),
                      ))
                  : TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            useSafeArea: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => ChangeNameImageGroup(
                                chatRoom: widget.chatRoom)).then((value) {
                          if (value != null) {
                            if (value['image'] != null) {
                              print(value['image']);
                              setState(() {
                                chatRoomImage = value['image'];
                                widget.chatRoom.imageUrl = value['image'];
                              });
                            }
                            setState(() {
                              chatRoomName = value['name'];
                              widget.chatRoom.chatroomname = value['name'];
                            });
                          }
                        });
                        ;
                      },
                      child: Text(
                        'Đổi ảnh hoặc tên',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800]),
                      )),
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchMessageScreen(
                            chatroom: widget.chatRoom,
                          )));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tìm kiếm trong cuộc trò chuyện',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.search)
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PinMessageScreen(
                            chatroom: widget.chatRoom,
                          )));
                },
                child: Container(
                  height: 55,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Xem tin nhắn đã ghim',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.pin_invoke)
                    ],
                  ),
                ),
              ),
              if (!widget.chatRoom.type!)
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ListUserInGroup(chatRoom: widget.chatRoom),
                      ),
                    );
                  },
                  child: Container(
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Xem thành viên trong đoạn chat",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
              widget.chatRoom.type!
                  ? InkWell(
                      onTap: () {
                        _blockUser(widget.userChat!.userId!);
                        Navigator.of(context).pushReplacementNamed("/MainChat");
                        toast("Đã chặn người dùng");
                      },
                      child: Container(
                        height: 55,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Chặn",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.block),
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: _showDialog,
                      child: Container(
                        height: 55,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rời khỏi đoạn chat",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            ),
                            Icon(
                              Icons.exit_to_app,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
