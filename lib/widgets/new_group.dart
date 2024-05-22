import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_chat.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/main.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/screens/chat/chat_screen.dart';
import 'package:networking/widgets/user_avatar.dart';
import 'package:networking/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:tiengviet/tiengviet.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class NewGroupChat extends StatefulWidget {
  const NewGroupChat({super.key});

  @override
  State<NewGroupChat> createState() => _NewGroupChatState();
}

class _NewGroupChatState extends State<NewGroupChat> {
  List<Users> _list = [];
  List<Users> _searchList = [];
  List<Users> _listUser = [];
  final _groupNameController = TextEditingController();
  bool _canCreate = false;
  String tb = "";
  void _runFilter(String _enteredKeyword) {
    _searchList.clear();
    for (var user in _list) {
      if (TiengViet.parse(user.userName!)
          .toLowerCase()
          .contains(TiengViet.parse(_enteredKeyword).toLowerCase())) {
        _searchList.add(user);
      }
    }
    setState(() {
      _searchList;
    });
  }

  void _addUser(Users user, bool isAdd) {
    setState(() {
      if (isAdd) {
        _listUser.add(user);
      } else {
        _listUser.removeWhere(
          (element) => element.userId == user.userId,
        );
      }
      if (_listUser.length > 1) {
        _canCreate = true;
      } else {
        _canCreate = false;
      }
    });
  }

  void _deleteUser(Users user) {
    setState(
      () {
        _listUser.remove(user);
        if (_listUser.length < 2) {
          _canCreate = false;
        }
      },
    );
  }

  bool _checkContains(Users userChat) {
    for (Users user in _listUser) {
      if (user.userId == userChat.userId) return true;
    }
    return false;
  }

  Future<void> goToChatGroupScreen(BuildContext ctx) async {
    String chatRoomName = _groupNameController.text.trim();
    Map<String, bool> participantsId = {
      for (var item in _listUser) '${item.userId}': true
    };
    final chatRoomId = uuid.v4();
    ChatRoom chatRoom = await APIsChat.createGroupChatroom(participantsId,
        chatRoomId, chatRoomName.trim().isNotEmpty ? chatRoomName : '');
    String groupName = await APIsChat.getChatRoomName(chatRoom);
    Navigator.of(ctx).pop();
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen.group(
          chatRoom: chatRoom,
          groupName: groupName,
        ),
      ),
    );
  }

  int getIndexUser() {
    int index = 0;
    for (Users user in _list) {
      if (user.userId == currentUserId) {
        index = _list.indexOf(user);
        break;
      }
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Hủy",
                        style: TextStyle(fontSize: 20, color: Colors.blue[400]),
                      ),
                    ),
                    Text(
                      "Nhóm mới",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: _canCreate
                          ? () async {
                              FocusScope.of(context).unfocus();
                              await goToChatGroupScreen(context);
                            }
                          : null,
                      child: Text(
                        "Tạo",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: TextField(
                    controller: _groupNameController,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      hintStyle: TextStyle(
                        fontSize: 18,
                      ),
                      hintText: "Tên nhóm (không bắt buộc)",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                searchBar(_runFilter, ScreenUtil().screenWidth),
                if (_listUser.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 95,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        List<Users> _listUserReverse =
                            _listUser.reversed.toList();
                        return Row(
                          children: [
                            UserAvatar(
                              user: _listUser.length < 6
                                  ? _listUser[index]
                                  : _listUserReverse[index],
                              deleteUser: _deleteUser,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                          ],
                        );
                      },
                      itemCount: _listUser.length,
                      reverse: _listUser.length > 5 ? true : false,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 20),
                  child: Text(
                    "Gợi ý",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: APIsChat.getAllUser(),
                  builder: (ctx, userSnapshot) {
                    if (!userSnapshot.hasData ||
                        userSnapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'Không có người dùng nào.',
                        ),
                      );
                    }
                    if (userSnapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Có gì đó sai sai...',
                        ),
                      );
                    }
                    final data = userSnapshot.data!.docs;
                    _list = data.map((e) => Users.fromMap(e.data())).toList();
                    List<String> blockUsers = _list[getIndexUser()].blockUsers!;
                    _list.removeWhere(
                        (user) => blockUsers.contains(user.userId));
                    _list.removeWhere((user) => user.userId == currentUserId);
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchList.isEmpty
                            ? _list.length
                            : _searchList.length,
                        itemBuilder: (ctx, index) {
                          Users userChat = _searchList.isEmpty
                              ? _list[index]
                              : _searchList[index];
                          return Column(
                            children: [
                              UserCard.createGroup(
                                user: userChat,
                                onTap: _addUser,
                                isNotChecked:
                                    _checkContains(userChat) ? true : false,
                              ),
                              Divider(
                                height: 3,
                              )
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
