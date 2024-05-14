import 'package:networking/apis/apis_chat.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/models/message_model.dart';
import 'package:networking/widgets/menu_option_chatscreen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PinMessageScreen extends StatelessWidget {
  PinMessageScreen({super.key, required this.chatroom});
  final ChatRoom chatroom;

  List<MessageChat> listPinMessage = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tin nhắn đã ghim'),
      ),
      body: StreamBuilder(
        stream: APIsChat.getPinMessage(chatroom.chatroomid!),
        builder: (ctx, pinMessageSnapshot) {
          if (pinMessageSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!pinMessageSnapshot.hasData ||
              pinMessageSnapshot.data!.docs.isEmpty) {
            return Center(child: Text('Không có tin nhắn nào được ghim'));
          }
          if (pinMessageSnapshot.hasError) {
            return Center(child: Text('Có gì sai sai'));
          }
          final data = pinMessageSnapshot.data!.docs;
          listPinMessage =
              data.map((e) => MessageChat.fromMap(e.data())).toList();
          listPinMessage.sort((a, b) {
            if (int.parse(a.isPin!) < (int.parse(b.isPin!))) {
              return 1;
            } else if (int.parse(a.isPin!) > int.parse(b.isPin!)) {
              return -1;
            }
            return 0;
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: listPinMessage.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {},
                            onLongPress: () {
                              showModalBottomSheet(
                                useSafeArea: true,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => MenuChatScreen(
                                  chatroomId: chatroom.chatroomid!,
                                  messageId: listPinMessage[index].messageId!,
                                  isPin: true,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundImage: listPinMessage[index]
                                            .userImage!
                                            .isNotEmpty
                                        ? NetworkImage(
                                            listPinMessage[index].userImage!)
                                        : AssetImage('assets/images/user.png')
                                            as ImageProvider,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listPinMessage[index].userName!,
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
                                                listPinMessage[index].type! ==
                                                        TypeSend.text
                                                    ? listPinMessage[index].msg!
                                                    : (listPinMessage[index]
                                                                .type! ==
                                                            TypeSend.video
                                                        ? 'Một video'
                                                        : 'Một ảnh'),
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 93, 93, 93)),
                                              ),
                                            ),
                                            Text(MyDateUtil.getLastMessageTime(
                                                context: context,
                                                time: listPinMessage[index]
                                                    .sent!)),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
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
          );
        },
      ),
    );
  }
}
