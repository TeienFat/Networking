import 'package:flutter/material.dart';

class MenuPickVideo extends StatelessWidget {
  const MenuPickVideo({super.key, required this.onPickVideo});
  final Function(bool type) onPickVideo;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight / 7,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      iconSize: 50,
                      onPressed: () {
                        Navigator.pop(context);
                        onPickVideo(true);
                      },
                      icon: Icon(Icons.camera),
                    ),
                    Text(
                      "Máy ảnh",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      iconSize: 50,
                      onPressed: () {
                        Navigator.pop(context);
                        onPickVideo(false);
                      },
                      icon: Icon(Icons.image),
                    ),
                    Text(
                      "Thư viện",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
