import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/apis/apis_chat.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/main.dart';
import 'package:networking/models/user_model.dart';
import 'package:flutter/material.dart';

class RequestsMessage extends StatelessWidget {
  const RequestsMessage(
      {super.key,
      required this.userChat,
      required this.chatRoomId,
      required this.reLoad});
  final Users userChat;
  final String chatRoomId;
  final void Function(bool block) reLoad;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          backgroundImage: userChat.imageUrl!.isNotEmpty
              ? NetworkImage(userChat.imageUrl!)
              : AssetImage('assets/images/user.png') as ImageProvider,
          radius: 60,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          userChat.userName!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Card(
            child: Container(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: Column(
                  children: [
                    Icon(
                      Icons.handshake,
                      size: 50,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      userChat.userName! + ' muốn kết nối với bạn',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColorScheme.onPrimary,
                          ),
                          onPressed: () {
                            APIsChat.blockUser(userChat.userId!);
                            Navigator.of(context)
                                .pushReplacementNamed("/MainChat");
                            toast("Đã chặn người dùng");
                          },
                          child: Text(
                            'Chặn',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColorScheme.primary,
                            foregroundColor: kColorScheme.onPrimary,
                          ),
                          onPressed: () {
                            APIsChat.acceptRequestsMessage(chatRoomId);
                            reLoad(false);
                          },
                          child: Text(
                            'Chấp nhận',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
