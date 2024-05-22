import 'dart:io';

import 'package:networking/apis/apis_chat.dart';
import 'package:networking/main.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/models/message_model.dart';
import 'package:networking/widgets/menu_pick_image.dart';
import 'package:networking/widgets/menu_pick_video.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewMessage extends StatefulWidget {
  NewMessage({
    super.key,
    required this.chatRoom,
    required this.onUpload,
  }) : messageReply = null;
  NewMessage.reply({
    super.key,
    required this.chatRoom,
    required this.onUpload,
    required this.messageReply,
  });
  final ChatRoom chatRoom;
  final Function(bool upLoad) onUpload;
  final MessageChat? messageReply;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  bool _isTyping = false;

  TextEditingController _messageController = TextEditingController();
  void _sendTextMessage() {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    APIsChat.sendMessage(widget.chatRoom, enteredMessage.trim(), TypeSend.text,
        widget.messageReply);
  }

  @override
  Widget build(BuildContext context) {
    void _sendImageMessage(bool pickerType) async {
      var pickedImage;
      if (pickerType) {
        pickedImage = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 100,
          maxWidth: 295,
        );
        if (pickedImage == null) {
          return;
        }
        setState(() {
          widget.onUpload(true);
        });
        await APIsChat.sendMediaMessage(
            0, widget.chatRoom, File(pickedImage.path), widget.messageReply);
        setState(() {
          widget.onUpload(false);
        });
      } else {
        pickedImage = await ImagePicker().pickMultiImage(
          imageQuality: 100,
          maxWidth: 295,
        );
        if (pickedImage == null) {
          return;
        }
        setState(() {
          widget.onUpload(true);
        });
        for (var i in pickedImage) {
          await APIsChat.sendMediaMessage(
              0, widget.chatRoom, File(i.path), widget.messageReply);
        }
        setState(() {
          widget.onUpload(false);
        });
      }
    }

    void _sendVideoMessage(bool pickerType) async {
      var pickedImage;
      if (pickerType) {
        pickedImage = await ImagePicker().pickVideo(
          source: ImageSource.camera,
        );
        if (pickedImage == null) {
          return;
        }
        setState(() {
          widget.onUpload(true);
        });
        await APIsChat.sendMediaMessage(
            1, widget.chatRoom, File(pickedImage.path), widget.messageReply);
        setState(() {
          widget.onUpload(false);
        });
      } else {
        pickedImage =
            await ImagePicker().pickVideo(source: ImageSource.gallery);
        if (pickedImage == null) {
          return;
        }
        setState(() {
          widget.onUpload(true);
        });
        await APIsChat.sendMediaMessage(
            1, widget.chatRoom, File(pickedImage.path), widget.messageReply);
        setState(() {
          widget.onUpload(false);
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _isTyping
              ? IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    setState(() {
                      _isTyping = false;
                    });
                  },
                  icon: Icon(Icons.add),
                )
              : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            useSafeArea: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => MenuPickImage(
                              onPickImage: (type) => _sendImageMessage(type),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.image,
                          color: kColorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            useSafeArea: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => MenuPickVideo(
                              onPickVideo: (type) => _sendVideoMessage(type),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.video_library,
                          color: kColorScheme.primary,
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: Icon(
                      //     Icons.file_present,
                      //     color: kColorScheme.primary,
                      //   ),
                      // ),
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: Icon(
                      //     Icons.mic_none,
                      //     color: kColorScheme.primary,
                      //   ),
                      // ),
                    ],
                  ),
                ),
          Expanded(
            child: TextField(
              maxLines: null,
              textInputAction: TextInputAction.newline,
              maxLength: 2000,
              controller: _messageController,
              style: TextStyle(fontSize: 18),
              textCapitalization: TextCapitalization.sentences,
              onTap: () {
                setState(() {
                  _isTyping = true;
                });
              },
              onChanged: (value) {
                setState(() {
                  _isTyping = true;
                });
              },
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                filled: true,
                counterText: '',
                fillColor: kColorScheme.surfaceVariant,
                hintStyle: TextStyle(color: Colors.grey),
                hintText: "Aa",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kColorScheme.primary, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kColorScheme.primary, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _sendTextMessage,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
