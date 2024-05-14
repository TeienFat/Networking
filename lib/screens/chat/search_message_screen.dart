import 'package:networking/apis/apis_chat.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/models/message_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchMessageScreen extends StatefulWidget {
  SearchMessageScreen({super.key, required this.chatroom});
  ChatRoom chatroom;

  @override
  State<SearchMessageScreen> createState() => _SearchMessageScreenState();
}

class _SearchMessageScreenState extends State<SearchMessageScreen> {
  List<MessageChat> listMessage = [];

  void searchMessage(String _enteredKeyword) async {
    listMessage = await APIsChat.getSearchMessage(
        _enteredKeyword, widget.chatroom.chatroomid!);
    listMessage.sort((a, b) {
      if (int.parse(a.sent!) < (int.parse(b.sent!))) {
        return 1;
      } else if (int.parse(a.sent!) > int.parse(b.sent!)) {
        return -1;
      }
      return 0;
    });
    setState(() {
      listMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromRGBO(247, 247, 252, 1),
            hintText: 'Tìm kiếm trong cuộc trò chuyện',
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
          onSubmitted: (value) {
            searchMessage(value);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              listMessage.length.toString() + " tin nhắn trùng khớp",
              style: TextStyle(
                  color: const Color.fromARGB(255, 169, 169, 169),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: listMessage.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundImage: listMessage[index]
                                      .userImage!
                                      .isNotEmpty
                                  ? NetworkImage(listMessage[index].userImage!)
                                  : AssetImage('assets/images/user.png')
                                      as ImageProvider,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listMessage[index].userName!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                Container(
                                  width: 300,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: Text(
                                          listMessage[index].msg!,
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 93, 93, 93)),
                                        ),
                                      ),
                                      Text(MyDateUtil.getLastMessageTime(
                                          context: context,
                                          time: listMessage[index].sent!)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 10,
                      )
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
