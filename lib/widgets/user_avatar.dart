import 'package:networking/main.dart';
import 'package:networking/models/user_model.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user, required this.deleteUser});
  final Users user;
  final void Function(Users user) deleteUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 95,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  width: 60,
                  height: 55,
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 30,
                      backgroundImage: user.imageUrl!.isNotEmpty
                          ? NetworkImage(user.imageUrl!)
                          : AssetImage('assets/images/user.png')
                              as ImageProvider,
                    ),
                  )),
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  child: InkWell(
                    onTap: () {
                      deleteUser(user);
                    },
                    child: Icon(
                      Icons.cancel,
                      size: 20,
                      color: kColorScheme.primary,
                    ),
                  ),
                  // width: 17,
                  // height: 17,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 244, 234, 234),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          Text(
            user.userName!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
