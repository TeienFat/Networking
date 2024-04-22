import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/helpers/helpers.dart';

class ScaleImage extends StatelessWidget {
  ScaleImage({super.key, required this.imageUrl, required this.onDelete});
  final String imageUrl;
  final Function(String imageUrl) onDelete;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              onDelete(imageUrl);
              Navigator.pop(context);
              toast("Đã xóa ảnh");
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5.sp),
        child: Center(
          child: Container(
            width: double.maxFinite,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.sp)),
              child: Image.file(
                File(imageUrl),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
