import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:networking/widgets/menu_pick_image.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(
      {super.key, required this.onPickImage, this.initImageUrl});
  final File? initImageUrl;
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initImageUrl != null) {
      _pickedImageFile = widget.initImageUrl;
    }
  }

  void _pickImage(bool pickerType) async {
    var pickedImage;
    if (pickerType) {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
      if (pickedImage == null) {
        return;
      }
      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });

      widget.onPickImage(_pickedImageFile!);
    } else {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (pickedImage == null) {
        return;
      }
      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });

      widget.onPickImage(_pickedImageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 70.sp,
          backgroundColor: Colors.grey,
          child: Image.asset(
            "assets/images/user.png",
            width: 100.sp,
          ),
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
                  onPickImage: (type) => _pickImage(type),
                ),
              );
            },
            child: Text(
              "Chọn ảnh",
              style: TextStyle(fontSize: 14.sp, color: Colors.blue[400]),
            )),
      ],
    );
  }
}
