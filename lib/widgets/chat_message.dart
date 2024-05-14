import 'package:networking/apis/apis_chat.dart';
import 'package:networking/main.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/models/message_model.dart';
import 'package:networking/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({
    super.key,
    required this.chatRoom,
    required this.onMessageSwipe,
  });
  final ChatRoom chatRoom;
  final Function(MessageChat messageChat, bool isMe) onMessageSwipe;
  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  List<MessageChat> listMessage = [];
  int? indexToScroll;
  final _scrollController = ScrollController();
  void _scrollToIndex(String messageIdToScroll) {
    indexToScroll = listMessage
        .indexWhere((element) => element.messageId == messageIdToScroll);
    _scrollController.animateTo(60.0 * indexToScroll!,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: APIsChat.getAllMessages(widget.chatRoom.chatroomid!),
      builder: (context, messageSnapshot) {
        if (messageSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            heightFactor: 10,
            child: CircularProgressIndicator(),
          );
        }
        if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
          return Center(
              heightFactor: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.waving_hand_rounded,
                    color: kColorScheme.primary,
                    size: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Say Hi!',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ));
        }
        if (messageSnapshot.hasError) {
          return const Center(
            heightFactor: 10,
            child: Text(
              'Có gì đó sai sai',
            ),
          );
        }
        final data = messageSnapshot.data!.docs;
        listMessage = data.map((e) => MessageChat.fromMap(e.data())).toList();
        listMessage.sort((a, b) {
          if (int.parse(a.sent!) < (int.parse(b.sent!))) {
            return 1;
          } else if (int.parse(a.sent!) > int.parse(b.sent!)) {
            return -1;
          }
          return 0;
        });

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(13),
          reverse: true,
          itemCount: listMessage.length,
          itemBuilder: (context, index) {
            final chatMessage = listMessage[index];
            final nextChatMessage =
                index + 1 < listMessage.length ? listMessage[index + 1] : null;
            final prevChatMessage =
                index - 1 >= 0 ? listMessage[index - 1] : null;
            final currentMessageUserId = chatMessage.fromId;
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage.fromId : null;
            final prevMessageUserId =
                prevChatMessage != null ? prevChatMessage.fromId : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;
            final prevUserIsSame = prevMessageUserId == currentMessageUserId;
            List<String> listReadPrevMessage = [];
            if (prevChatMessage != null) {
              listReadPrevMessage = prevChatMessage.read!;
              listReadPrevMessage
                  .removeWhere((element) => element == currentUserId);
            }

            if (chatMessage.type == TypeSend.notification) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  chatMessage.msg!,
                  style: TextStyle(fontSize: 12),
                ),
              ));
            }
            if (currentUserId == currentMessageUserId &&
                prevChatMessage != null &&
                listReadPrevMessage.isEmpty) {
              return MessageBubble.second(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe: true,
                isLastInSequence: false,
                isLastMessage: true,
                typeChat: widget.chatRoom.type!,
                onSwipe: widget.onMessageSwipe,
                onTapReply: (messageIdToScroll) {
                  _scrollToIndex(messageIdToScroll);
                },
                isScrollTo: index == indexToScroll,
              );
            }

            if (prevChatMessage == null &&
                currentUserId == currentMessageUserId) {
              return MessageBubble.second(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe: true,
                isLastInSequence: true,
                isLastMessage: true,
                typeChat: widget.chatRoom.type!,
                onSwipe: widget.onMessageSwipe,
                onTapReply: (messageIdToScroll) {
                  _scrollToIndex(messageIdToScroll);
                },
                isScrollTo: index == indexToScroll,
              );
            }
            if (!prevUserIsSame &&
                !nextUserIsSame &&
                currentMessageUserId != currentUserId) {
              return MessageBubble.first(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe: currentUserId == currentMessageUserId,
                isLastInSequence: true,
                isLastMessage: false,
                typeChat: widget.chatRoom.type!,
                onSwipe: widget.onMessageSwipe,
                onTapReply: (messageIdToScroll) {
                  _scrollToIndex(messageIdToScroll);
                },
                isScrollTo: index == indexToScroll,
              );
            }

            if (!prevUserIsSame) {
              return MessageBubble.second(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe: currentUserId == currentMessageUserId,
                isLastInSequence: true,
                isLastMessage: false,
                typeChat: widget.chatRoom.type!,
                onSwipe: widget.onMessageSwipe,
                onTapReply: (messageIdToScroll) {
                  _scrollToIndex(messageIdToScroll);
                },
                isScrollTo: index == indexToScroll,
              );
            }

            if (currentMessageUserId == currentUserId || nextUserIsSame) {
              return MessageBubble.second(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe: currentUserId == currentMessageUserId,
                isLastInSequence: false,
                isLastMessage: false,
                typeChat: widget.chatRoom.type!,
                onSwipe: widget.onMessageSwipe,
                onTapReply: (messageIdToScroll) {
                  _scrollToIndex(messageIdToScroll);
                },
                isScrollTo: index == indexToScroll,
              );
            } else
              return MessageBubble.first(
                message: chatMessage,
                chatRoomId: widget.chatRoom.chatroomid!,
                isMe: currentUserId == currentMessageUserId,
                isLastInSequence: false,
                isLastMessage: false,
                typeChat: widget.chatRoom.type!,
                onSwipe: widget.onMessageSwipe,
                onTapReply: (messageIdToScroll) {
                  _scrollToIndex(messageIdToScroll);
                },
                isScrollTo: index == indexToScroll,
              );
          },
        );
      },
    );
  }
}
