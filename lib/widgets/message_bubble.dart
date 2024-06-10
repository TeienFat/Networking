import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_chat.dart';
import 'package:networking/helpers/helpers.dart';
import 'package:networking/models/message_model.dart';
import 'package:networking/widgets/bubble_image.dart';
import 'package:networking/widgets/bubble_video.dart';
import 'package:networking/widgets/menu_option_chatscreen.dart';
import 'package:networking/widgets/reply_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble.first(
      {super.key,
      required this.message,
      required this.chatRoomId,
      required this.isMe,
      required this.typeChat,
      required this.isLastInSequence,
      required this.isLastMessage,
      required this.onSwipe,
      required this.onTapReply,
      required this.isScrollTo})
      : isFirstInSequence = true;
  MessageBubble.second(
      {super.key,
      required this.chatRoomId,
      required this.message,
      required this.isMe,
      required this.typeChat,
      required this.isLastInSequence,
      required this.isLastMessage,
      required this.onSwipe,
      required this.onTapReply,
      required this.isScrollTo})
      : isFirstInSequence = false;
  final MessageChat message;
  final String chatRoomId;
  final bool typeChat;
  final bool isMe;
  final bool isFirstInSequence;
  final bool isLastInSequence;
  final bool isLastMessage;
  final Function(MessageChat messageChat, bool isMe) onSwipe;
  final Function(String messageIdToScroll) onTapReply;
  final bool isScrollTo;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  var currentUserId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0.5,
      upperBound: 1,
    );
    animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutBack,
    );
    if (widget.isScrollTo) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    APIsAuth.getCurrentUserId().then((value) => currentUserId = value);

    final theme = Theme.of(context);
    Map<String, dynamic> _messageReply = ({});
    if (widget.message.messageReply != ({})) {
      _messageReply = widget.message.messageReply!;
    }
    if (!widget.message.read!.contains(currentUserId)) {
      APIsChat.updateMessageReadStatus(
          widget.chatRoomId, widget.message.messageId!);
    }
    List<String> listRead = widget.message.read!;
    listRead.removeWhere((element) => element == currentUserId);
    return Stack(
      children: [
        if (widget.message.userImage != null && widget.isFirstInSequence)
          Positioned(
            top: 15,
            child: CircleAvatar(
              backgroundColor: Colors.amber,
              backgroundImage: widget.message.userImage!.isNotEmpty
                  ? NetworkImage(
                      widget.message.userImage!,
                    )
                  : AssetImage('assets/images/user.png') as ImageProvider,
              radius: 18,
            ),
          ),
        GestureDetector(
          onLongPress: () async {
            final bool isPin = await APIsChat.checkPinMessage(
                widget.message.messageId!, widget.chatRoomId);
            showModalBottomSheet(
              useSafeArea: true,
              isScrollControlled: true,
              context: context,
              builder: (context) => MenuChatScreen(
                chatroomId: widget.chatRoomId,
                messageId: widget.message.messageId!,
                isPin: isPin,
              ),
            );
          },
          child: Container(
            margin:
                widget.isMe ? null : const EdgeInsets.symmetric(horizontal: 45),
            child: Row(
              mainAxisAlignment:
                  widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (widget.isFirstInSequence) const SizedBox(height: 30),
                    if (widget.message.userName != null &&
                        !widget.typeChat &&
                        !widget.isMe &&
                        widget.isFirstInSequence)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 13,
                          right: 13,
                        ),
                        child: Text(
                          widget.message.userName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    SwipeTo(
                      swipeSensitivity: 10,
                      animationDuration: Duration(milliseconds: 200),
                      offsetDx: 0.8,
                      leftSwipeWidget: Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.reply,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      rightSwipeWidget: Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.reply,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onLeftSwipe: widget.isMe
                          ? (details) {
                              widget.onSwipe(widget.message, widget.isMe);
                            }
                          : null,
                      onRightSwipe: widget.isMe
                          ? null
                          : (details) {
                              widget.onSwipe(widget.message, widget.isMe);
                            },
                      child: Column(
                        crossAxisAlignment: widget.isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (_messageReply.isNotEmpty)
                            InkWell(
                                onTap: () {
                                  widget.onTapReply(_messageReply['messageId']);
                                },
                                child: ReplyBubble(
                                    chatRoomId: widget.chatRoomId,
                                    messageReplyFromId: _messageReply['fromId'],
                                    messageReplyUserName:
                                        _messageReply['userName'],
                                    messageReplyMsg: _messageReply['msg'],
                                    messageReplyType: _messageReply['type'] ==
                                            TypeSend.text.name
                                        ? TypeSend.text
                                        : _messageReply['type'] ==
                                                TypeSend.image.name
                                            ? TypeSend.image
                                            : _messageReply['type'] ==
                                                    TypeSend.video.name
                                                ? TypeSend.video
                                                : TypeSend.notification,
                                    messageSent: widget.message,
                                    isMe: widget.isMe)),
                          Stack(
                            children: [
                              widget.isScrollTo
                                  ? AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) =>
                                          ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      ),
                                      child: Container(
                                        decoration: widget.message.type! ==
                                                TypeSend.text
                                            ? BoxDecoration(
                                                color: widget.isMe
                                                    ? Colors.grey[300]
                                                    : theme.colorScheme
                                                        .primaryContainer,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: !widget.isMe
                                                      ? Radius.zero
                                                      : const Radius.circular(
                                                          12),
                                                  topRight: widget.isMe
                                                      ? Radius.zero
                                                      : const Radius.circular(
                                                          12),
                                                  bottomLeft:
                                                      const Radius.circular(12),
                                                  bottomRight:
                                                      const Radius.circular(12),
                                                ),
                                              )
                                            : null,
                                        constraints:
                                            const BoxConstraints(maxWidth: 295),
                                        padding: widget.message.type! ==
                                                TypeSend.text
                                            ? const EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 14,
                                              )
                                            : null,
                                        margin: _messageReply.isEmpty
                                            ? const EdgeInsets.symmetric(
                                                vertical: 4,
                                              )
                                            : EdgeInsets.only(bottom: 4),
                                        child: Column(
                                          crossAxisAlignment: widget.isMe
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            widget.message.type! ==
                                                    TypeSend.text
                                                ? Text(
                                                    widget.message.msg!,
                                                    style: TextStyle(
                                                      height: 1.3,
                                                      color: widget.isMe
                                                          ? Colors.black87
                                                          : theme.colorScheme
                                                              .onPrimaryContainer,
                                                    ),
                                                    softWrap: true,
                                                  )
                                                : widget.message.type! ==
                                                        TypeSend.image
                                                    ? ImageBubble(
                                                        imageUrl:
                                                            widget.message.msg!,
                                                        isMe: widget.isMe)
                                                    : widget.message.type! ==
                                                            TypeSend.video
                                                        ? VideoBubble(
                                                            videoUrl: widget
                                                                .message.msg!,
                                                            isMe: widget.isMe,
                                                          )
                                                        : SizedBox(),
                                            if (widget.isLastInSequence)
                                              SizedBox(
                                                height: 10,
                                              ),
                                            if (widget.isLastInSequence)
                                              Text(
                                                MyDateUtil.getFormattedTime(
                                                    context: context,
                                                    time: widget.message.sent
                                                        .toString()),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: widget.isMe
                                                      ? Colors.black87
                                                      : theme.colorScheme
                                                          .onPrimaryContainer,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: widget.message.type! ==
                                              TypeSend.text
                                          ? BoxDecoration(
                                              color: widget.isMe
                                                  ? Colors.grey[300]
                                                  : theme.colorScheme
                                                      .primaryContainer,
                                              borderRadius: BorderRadius.only(
                                                topLeft: !widget.isMe
                                                    ? Radius.zero
                                                    : const Radius.circular(12),
                                                topRight: widget.isMe
                                                    ? Radius.zero
                                                    : const Radius.circular(12),
                                                bottomLeft:
                                                    const Radius.circular(12),
                                                bottomRight:
                                                    const Radius.circular(12),
                                              ),
                                            )
                                          : null,
                                      constraints:
                                          const BoxConstraints(maxWidth: 275),
                                      padding:
                                          widget.message.type! == TypeSend.text
                                              ? const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 14,
                                                )
                                              : null,
                                      margin: _messageReply.isEmpty
                                          ? const EdgeInsets.symmetric(
                                              vertical: 4,
                                            )
                                          : EdgeInsets.only(bottom: 4),
                                      child: Column(
                                        crossAxisAlignment: widget.isMe
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.end,
                                        children: [
                                          widget.message.type! == TypeSend.text
                                              ? Text(
                                                  widget.message.msg!,
                                                  style: TextStyle(
                                                    height: 1.3,
                                                    color: widget.isMe
                                                        ? Colors.black87
                                                        : theme.colorScheme
                                                            .onPrimaryContainer,
                                                  ),
                                                  softWrap: true,
                                                )
                                              : widget.message.type! ==
                                                      TypeSend.image
                                                  ? ImageBubble(
                                                      imageUrl:
                                                          widget.message.msg!,
                                                      isMe: widget.isMe)
                                                  : widget.message.type! ==
                                                          TypeSend.video
                                                      ? VideoBubble(
                                                          videoUrl: widget
                                                              .message.msg!,
                                                          isMe: widget.isMe,
                                                        )
                                                      : SizedBox(),
                                          if (widget.isLastInSequence)
                                            SizedBox(
                                              height: 10,
                                            ),
                                          if (widget.isLastInSequence)
                                            Text(
                                              MyDateUtil.getFormattedTime(
                                                  context: context,
                                                  time: widget.message.sent
                                                      .toString()),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: widget.isMe
                                                    ? Colors.black87
                                                    : theme.colorScheme
                                                        .onPrimaryContainer,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                              if (widget.message.isPin!.isNotEmpty)
                                widget.isMe
                                    ? Positioned.fill(
                                        left: -3,
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Icon(
                                              Icons.push_pin,
                                              size: 16,
                                              color: Colors.red,
                                            )))
                                    : Positioned.fill(
                                        right: -3,
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                              Icons.push_pin,
                                              size: 16,
                                              color: Colors.red,
                                            )))
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.isMe &&
                        widget.isLastMessage &&
                        listRead.isNotEmpty)
                      Icon(
                        Icons.done_all_rounded,
                        color: Colors.green,
                      ),
                    if (widget.isMe &&
                        widget.isLastMessage &&
                        widget.isLastInSequence &&
                        listRead.isEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 3.0),
                          child: Text(
                            'Đã gửi',
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.isMe
                                  ? Colors.white
                                  : theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
