import 'package:cached_network_image/cached_network_image.dart';
import 'package:networking/screens/chat/scale_image.dart';
import 'package:flutter/material.dart';

class ImageBubble extends StatelessWidget {
  const ImageBubble({super.key, required this.imageUrl, required this.isMe});
  final String imageUrl;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScaleImage(
                  imageUrl: imageUrl,
                  scale: 1.35,
                )));
      },
      child: ClipRRect(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: const CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.image_rounded),
        ),
        borderRadius: BorderRadius.only(
          topLeft: !isMe ? Radius.zero : const Radius.circular(12),
          topRight: isMe ? Radius.zero : const Radius.circular(12),
          bottomLeft: const Radius.circular(12),
          bottomRight: const Radius.circular(12),
        ),
      ),
    );
  }
}
