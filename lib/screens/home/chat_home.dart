import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_chat.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/main.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/widgets/chatroom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiengviet/tiengviet.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  bool isSearching = false;

  List<ChatRoom> _listChatroom = [];
  List<ChatRoom> _searchListChatRoom = [];

  Future<void> _runFilter(String enteredKeyword) async {
    var mapName = await APIsChat.getNameInfo();
    List<String> nameList = mapName.values.toList();
    List<String> _searchListId = [];
    _searchListChatRoom.clear();
    for (var name in nameList) {
      if (TiengViet.parse(name)
          .toLowerCase()
          .contains(TiengViet.parse(enteredKeyword).toLowerCase())) {
        var key = mapName.keys.firstWhere((value) => mapName[value] == name);
        _searchListId.add(key);
      }
    }
    for (var room in _listChatroom) {
      bool isParticipant = _searchListId
          .any((element) => room.participants!.keys.contains(element));

      if (_searchListId.contains(room.chatroomid!) || isParticipant) {
        _searchListChatRoom.add(room);
      }
    }
    setState(() {
      isSearching = true;
      _searchListChatRoom;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('pause')) APIsChat.updateStatus(false);
      if (message.toString().contains('resume')) APIsChat.updateStatus(true);
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          searchBar(_runFilter, ScreenUtil().screenWidth),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: APIsChat.getAllChatroom(),
            builder: (ctx, chatroomSnapshot) {
              if (chatroomSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  heightFactor: 10,
                  child: CircularProgressIndicator(),
                );
              }
              if (!chatroomSnapshot.hasData ||
                  chatroomSnapshot.data!.docs.isEmpty) {
                return const Center(
                  heightFactor: 10,
                  child: Text(
                    'Không tìm thấy đoạn chat nào',
                  ),
                );
              }
              if (chatroomSnapshot.hasError) {
                return const Center(
                  heightFactor: 10,
                  child: Text(
                    'Có gì đó sai sai',
                  ),
                );
              }
              final data = chatroomSnapshot.data!.docs;
              _listChatroom = data
                  .map<ChatRoom>((e) => ChatRoom.fromMap(e.data()))
                  .toList();
              _listChatroom.sort((a, b) {
                if (int.parse(a.lastSend!) > (int.parse(b.lastSend!))) {
                  return 0;
                }
                return 1;
              });
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 5.sp),
                height: ScreenUtil().screenHeight * 0.7,
                child: ListView.builder(
                  itemCount: isSearching
                      ? (_searchListChatRoom.isEmpty
                          ? 1
                          : _searchListChatRoom.length)
                      : _listChatroom.length,
                  itemBuilder: (ctx, index) {
                    if (isSearching) {
                      if (_searchListChatRoom.isEmpty)
                        return Center(
                            child: Text('Không tìm thấy đoạn chat nào'));
                      bool typeRoom = _searchListChatRoom[index].type!;
                      List<String> userIdLisst = _searchListChatRoom[index]
                          .participants!
                          .keys
                          .toList();
                      String userid = userIdLisst.elementAt(0);
                      if (userid == currentUserId)
                        userid = userIdLisst.elementAt(1);
                      if (typeRoom) {
                        return StreamBuilder(
                          stream: APIsChat.getInfoUser(userid.toString()),
                          builder: (ctx, usersnapshot) {
                            if (usersnapshot.hasData) {
                              final data = usersnapshot.data!.docs;
                              final list = data
                                  .map((e) => Users.fromMap(e.data()))
                                  .toList();
                              return ChatRoomCard.direct(
                                  chatRoom: _searchListChatRoom[index],
                                  userchat: list[0]);
                            } else
                              return Container();
                          },
                        );
                      }
                      return FutureBuilder(
                          future: APIsChat.getChatRoomName(
                              _searchListChatRoom[index]),
                          builder: (ctx, usersnapshot) {
                            if (usersnapshot.connectionState ==
                                ConnectionState.done) {
                              String groupName = usersnapshot.data!;
                              return ChatRoomCard.group(
                                chatRoom: _searchListChatRoom[index],
                                groupName: groupName,
                              );
                            } else
                              return Container();
                          });
                    } else {
                      bool typeRoom = _listChatroom[index].type!;
                      List<String> userIdLisst =
                          _listChatroom[index].participants!.keys.toList();
                      String userid = userIdLisst.elementAt(0);
                      if (userid == currentUserId)
                        userid = userIdLisst.elementAt(1);
                      if (typeRoom) {
                        return StreamBuilder(
                          stream: APIsChat.getInfoUser(userid.toString()),
                          builder: (ctx, usersnapshot) {
                            if (usersnapshot.hasData) {
                              final data = usersnapshot.data!.docs;
                              final list = data
                                  .map((e) => Users.fromMap(e.data()))
                                  .toList();
                              return ChatRoomCard.direct(
                                  chatRoom: _listChatroom[index],
                                  userchat: list[0]);
                            } else
                              return Container();
                          },
                        );
                      }
                      return FutureBuilder(
                          future:
                              APIsChat.getChatRoomName(_listChatroom[index]),
                          builder: (ctx, usersnapshot) {
                            if (usersnapshot.connectionState ==
                                ConnectionState.done) {
                              String groupName = usersnapshot.data!;
                              return ChatRoomCard.group(
                                chatRoom: _listChatroom[index],
                                groupName: groupName,
                              );
                            } else
                              return Container();
                          });
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
