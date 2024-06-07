import 'package:networking/models/message_model.dart';
import 'package:networking/widgets/bubble_image.dart';
import 'package:flutter/material.dart';

class MessageChatBotBubble extends StatefulWidget {
  MessageChatBotBubble({
    super.key,
    required this.message,
    required this.isMe,
  });
  final MessageChat message;
  final bool isMe;

  @override
  State<MessageChatBotBubble> createState() => _MessageChatBotBubbleState();
}

class _MessageChatBotBubbleState extends State<MessageChatBotBubble> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        if (!widget.isMe)
          Positioned(
            top: 15,
            child: CircleAvatar(
              backgroundColor: Colors.amber,
              backgroundImage:
                  AssetImage('assets/images/logo.png') as ImageProvider,
              radius: 18,
            ),
          ),
        Container(
          margin:
              widget.isMe ? null : const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment:
                widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: widget.isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (widget.message.userName != null && !widget.isMe)
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
                  widget.isMe
                      ? SizedBox(
                          height: 5,
                        )
                      : SizedBox(),
                  Container(
                    decoration: widget.message.type! == TypeSend.text
                        ? BoxDecoration(
                            color: widget.isMe
                                ? Colors.grey[300]
                                : theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.only(
                              topLeft: !widget.isMe
                                  ? Radius.zero
                                  : const Radius.circular(12),
                              topRight: widget.isMe
                                  ? Radius.zero
                                  : const Radius.circular(12),
                              bottomLeft: const Radius.circular(12),
                              bottomRight: const Radius.circular(12),
                            ),
                          )
                        : null,
                    constraints: const BoxConstraints(maxWidth: 295),
                    padding: widget.message.type! == TypeSend.text
                        ? const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 14,
                          )
                        : null,
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
                                      : theme.colorScheme.onPrimaryContainer,
                                ),
                                softWrap: true,
                              )
                            : widget.message.type! == TypeSend.image
                                ? ImageBubble(
                                    imageUrl: widget.message.msg!,
                                    isMe: widget.isMe)
                                : SizedBox(),
                      ],
                    ),
                  ),
                  !widget.isMe
                      ? SizedBox(
                          height: 5,
                        )
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
