import 'package:flutter/material.dart';

class MenuAddChat extends StatelessWidget {
  const MenuAddChat({super.key, required this.onAddChat});
  final Function(bool type) onAddChat;
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
                        onAddChat(true);
                      },
                      icon: Icon(Icons.group_add),
                    ),
                    Text(
                      "Tạo nhóm",
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
                        onAddChat(false);
                      },
                      icon: Icon(Icons.person_add),
                    ),
                    Text(
                      "Người dùng",
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
