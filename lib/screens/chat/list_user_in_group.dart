import 'package:networking/apis/apis_chat.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/widgets/user_card.dart';
import 'package:flutter/material.dart';

class ListUserInGroup extends StatefulWidget {
  const ListUserInGroup({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  State<ListUserInGroup> createState() => _ListUserInGroupState();
}

class _ListUserInGroupState extends State<ListUserInGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thành viên đoạn chat"),
      ),
      body: StreamBuilder(
          stream: APIsChat.getParticipants(widget.chatRoom.chatroomid!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                heightFactor: 10,
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                heightFactor: 10,
                child: Text(
                  'Không có dữ liệu',
                ),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                heightFactor: 10,
                child: Text(
                  'Có gì đó sai sai',
                ),
              );
            }
            final data = snapshot.data!;
            ChatRoom chatRoom = ChatRoom.fromMap(data.data()!);
            var listUserId = chatRoom.participants!.keys.toList();
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listUserId.length.toString() + " thành viên",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListView.builder(
                          itemCount: listUserId.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                              future: APIsChat.getUserFormId(listUserId[index]),
                              builder: (ctx, usersnapshot) {
                                if (usersnapshot.connectionState ==
                                    ConnectionState.done) {
                                  Users userchat = usersnapshot.data!;
                                  return Column(
                                    children: [
                                      UserCard.listParticipant(
                                          chatRoom: widget.chatRoom,
                                          user: userchat),
                                      Divider(
                                        height: 3,
                                      )
                                    ],
                                  );
                                } else
                                  return Container();
                              },
                            );
                          },
                        )),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
