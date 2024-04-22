import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:networking/screens/take_care/detail/scale_image.dart';

class ListContentImage extends StatefulWidget {
  const ListContentImage(
      {super.key, required this.listImage, required this.onDelete});
  final List<dynamic> listImage;
  final Function(String imageUrl) onDelete;
  @override
  State<ListContentImage> createState() => _ListContentImageState();
}

class _ListContentImageState extends State<ListContentImage> {
  List<File> _listFileImage = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listFileImage = widget.listImage.map((e) => File(e)).toList();
  }

  void _removeImage(File imageFile) {
    setState(() {
      _listFileImage.remove(imageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ảnh chăm sóc"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(5.sp),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            children: [
              for (int i = 0; i < _listFileImage.length; i++)
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScaleImage(
                          imageUrl: _listFileImage[i].path,
                          onDelete: (imageUrl) {
                            widget.onDelete(imageUrl);
                            _removeImage(_listFileImage[i]);
                          },
                        ),
                      )),
                  child: Image.file(
                    _listFileImage[i],
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
