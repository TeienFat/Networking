import 'dart:io';
import 'package:networking/apis/apis_chat.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/widgets/menu_pick_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChangeNameImageGroup extends StatefulWidget {
  const ChangeNameImageGroup({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  @override
  State<ChangeNameImageGroup> createState() => _Change_Name_Image_GroupState();
}

class _Change_Name_Image_GroupState extends State<ChangeNameImageGroup> {
  TextEditingController txtTenNhom = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtTenNhom.text = widget.chatRoom.chatroomname!;
  }

  File? _pickedImageFile;
  void _updateImages(bool pickerType) async {
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
        _pickedImageFile = File(pickedImage.path);
      });
    } else {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 295,
      );
      if (pickedImage == null) {
        return;
      }
      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(10.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Hủy',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Text(
                "Đổi ảnh nhóm",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () async {
                  await APIsChat.updateNameChatRoom(
                      widget.chatRoom.chatroomid!, txtTenNhom.text);
                  if (_pickedImageFile != null) {
                    final imageUrl = await APIsChat.updateImageChatRoom(
                        widget.chatRoom.chatroomid!,
                        _pickedImageFile!,
                        widget.chatRoom.imageUrl!);
                    Navigator.of(context)
                        .pop({'image': imageUrl, 'name': txtTenNhom.text});
                  } else {
                    Navigator.of(context).pop({'name': txtTenNhom.text});
                  }
                },
                child: Text(
                  'Xong',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          CircleAvatar(
            backgroundColor: Colors.amber,
            backgroundImage: widget.chatRoom.imageUrl!.isNotEmpty
                ? NetworkImage(widget.chatRoom.imageUrl!)
                : AssetImage('assets/images/group_chat.png') as ImageProvider,
            radius: 60,
            foregroundImage:
                _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
          ),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (context) => MenuPickImage(
                  onPickImage: (type) => this._updateImages(type),
                ),
              );
            },
            child: Text(
              'Chọn ảnh',
              style: TextStyle(fontSize: 16, color: Colors.blue[800]),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: txtTenNhom,
              decoration: InputDecoration(
                labelText: 'Đặt tên nhóm',
                border: OutlineInputBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
