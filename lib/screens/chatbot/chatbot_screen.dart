import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:networking/apis/apis_chatbot.dart';
import 'package:networking/main.dart';
import 'package:networking/models/message_model.dart';
import 'package:networking/screens/chatbot/api_chatbot_key.dart';
import 'package:networking/screens/chatbot/chatbot_message_bubble.dart';
import 'package:flutter/material.dart';

class ChatBotScreen extends StatefulWidget {
  ChatBotScreen({super.key});
  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final Gemini gemini = Gemini.instance;
  var _isLoading = false;
  TextEditingController _messageController = TextEditingController();
  List<MessageChat> _listMessage = [];
  void _sendMessage() async {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final nowBot = DateTime.now().millisecondsSinceEpoch + 1;
    final enteredMessage = _messageController.text;
    await APIsChatBot.getDataForChatBot();
    final data = await APIsChatBot.getDataForChatBot();
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();
    setState(() {
      _listMessage.add(MessageChat(
          messageId: "",
          fromId: currentUserId,
          msg: enteredMessage.trim(),
          read: [],
          sent: now,
          userName: "",
          userImage: "",
          type: TypeSend.text,
          receivers: [],
          isPin: "",
          messageReply: ({})));
    });
    try {
      String question = BEGIN_CHAT_BOT +
          data +
          "hãy trả lời câu hỏi sau của tôi dựa trên dữ liệu này.\n" +
          enteredMessage +
          CONSTRAINT_CHAT_BOT;
      gemini
          .streamGenerateContent(
        question,
      )
          .listen((event) {
        MessageChat? lastMessage = _listMessage.firstOrNull;
        if (lastMessage != null && lastMessage.fromId == 'chatbot') {
          lastMessage = _listMessage.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.msg = lastMessage.msg! + response;
          setState(
            () {
              _listMessage = [lastMessage!, ..._listMessage];
              _isLoading = false;
            },
          );
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          setState(() {
            _listMessage.add(MessageChat(
                messageId: "",
                fromId: 'chatbot',
                msg: response,
                read: [],
                sent: nowBot.toString(),
                userName: "Networking",
                userImage: "",
                type: TypeSend.text,
                receivers: [],
                isPin: "",
                messageReply: ({})));
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    gemini.info(model: 'gemini-1.5-pro-latest');
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber,
              backgroundImage:
                  AssetImage('assets/images/logo.png') as ImageProvider,
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
                      "Trợ lý Networking",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(13),
              reverse: true,
              itemCount: _listMessage.length,
              itemBuilder: (context, index) {
                _listMessage.sort((a, b) {
                  if (int.parse(a.sent!) < (int.parse(b.sent!))) {
                    return 1;
                  } else if (int.parse(a.sent!) > int.parse(b.sent!)) {
                    return -1;
                  }
                  return 0;
                });
                final chatMessage = _listMessage[index];
                final currentMessageUserId = chatMessage.fromId;
                return MessageChatBotBubble(
                  message: chatMessage,
                  isMe: currentUserId == currentMessageUserId,
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 11.sp, vertical: 10.sp),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.amber,
                          backgroundImage: AssetImage('assets/images/logo.png')
                              as ImageProvider,
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        LoadingAnimationWidget.stretchedDots(
                            color: Colors.orange, size: 40.sp),
                      ],
                    )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        maxLength: 2000,
                        controller: _messageController,
                        style: TextStyle(fontSize: 18),
                        textCapitalization: TextCapitalization.sentences,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          filled: true,
                          counterText: '',
                          fillColor: kColorScheme.surfaceVariant,
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Aa",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kColorScheme.primary, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kColorScheme.primary, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        _sendMessage();
                        setState(() {
                          _isLoading = true;
                        });
                      },
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
