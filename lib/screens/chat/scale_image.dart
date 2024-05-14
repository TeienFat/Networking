import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';

// ignore: must_be_immutable
class ScaleImage extends StatefulWidget {
  ScaleImage({super.key, required this.imageUrl, required this.scale});
  final String imageUrl;
  final double scale;
  @override
  State<ScaleImage> createState() => _ScaleImageState();
}

void _saveNetworkImage(String imageUrl) async {
  GallerySaver.saveImage(imageUrl, albumName: 'Networking Ảnh').then((success) {
    if (success != null && success) {
      Fluttertoast.showToast(
          msg: "Lưu ảnh thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  });
}

class _ScaleImageState extends State<ScaleImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.cancel_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _saveNetworkImage(widget.imageUrl);
            },
            icon: Icon(Icons.download_sharp),
          ),
        ],
      ),
      body: Center(
        child: Transform.scale(
          scale: widget.scale,
          child: ClipRRect(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              placeholder: (context, url) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: const CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.image_rounded),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
