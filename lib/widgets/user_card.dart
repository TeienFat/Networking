import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:networking/apis/apis_chat.dart';
import 'package:networking/main.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/screens/chat/chat_screen.dart';
import 'package:networking/screens/chat/profile_of_others.dart';
import 'package:networking/screens/relationships/new/new_relationship.dart';
import 'package:networking/widgets/menu_option_setting.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class UserCard extends StatefulWidget {
  const UserCard.contact({super.key, required this.user})
      : this.chatRoom = null,
        this.onTap = null,
        this.isNotChecked = null,
        this.room = 'contact';
  const UserCard.listParticipant(
      {super.key, required this.user, required this.chatRoom})
      : this.onTap = null,
        this.isNotChecked = null,
        this.room = 'listParticipants';
  const UserCard.createGroup(
      {super.key,
      required this.user,
      required this.onTap,
      required this.isNotChecked})
      : this.chatRoom = null,
        this.room = 'createGroup';

  final String room;
  final Users user;
  final ChatRoom? chatRoom;
  final void Function(Users user, bool isChecked)? onTap;
  final bool? isNotChecked;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Future<void> goToChatScreen(BuildContext ctx) async {
    final chatRoomId = uuid.v4();

    ChatRoom chatRoom =
        await APIsChat.createDirectChatroom(widget.user.userId!, chatRoomId);
    Navigator.of(ctx).push(MaterialPageRoute(
        builder: (context) => ChatScreen.direct(
              chatRoom: chatRoom,
              userChat: widget.user,
            )));
  }

  void _openMenuOptionOverlay() {
    if (currentUserId != widget.user.userId) {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => MenuOptionSetting(
            chatRoom: widget.chatRoom!,
            userId: widget.user.userId!,
            userName: widget.user.userName!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool? _isChecked;
    if (widget.isNotChecked != null) {
      _isChecked = widget.isNotChecked!;
    }
    return Slidable(
      endActionPane: widget.room == 'contact'
          ? ActionPane(
              motion: DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileOfOthersScreen(
                                  id: widget.user.userId!,
                                )));
                  },
                  backgroundColor: Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: FontAwesomeIcons.idCard,
                ),
                SlidableAction(
                  onPressed: (context) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewRelationship.initUser(
                                  user: widget.user,
                                  relationships: [],
                                )));
                  },
                  backgroundColor: Color.fromARGB(255, 238, 184, 6),
                  foregroundColor: Colors.white,
                  icon: FontAwesomeIcons.handshakeAngle,
                ),
              ],
            )
          : null,
      child: InkWell(
        onTap: () {
          switch (widget.room) {
            case 'contact':
              goToChatScreen(context);
              break;
            case 'listParticipants':
              _openMenuOptionOverlay();
            case 'createGroup':
              {
                setState(
                  () {
                    _isChecked = !_isChecked!;
                    widget.onTap!(widget.user, _isChecked!);
                  },
                );
              }
              break;
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, top: 16),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 30,
                      backgroundImage: widget.user.imageUrl!.isNotEmpty
                          ? NetworkImage(widget.user.imageUrl!)
                          : AssetImage('assets/images/user.png')
                              as ImageProvider,
                    ),
                  ),
                  if (widget.user.isOnline!)
                    Positioned(
                      right: -1,
                      top: -1,
                      child: Container(
                        width: 17,
                        height: 17,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(44, 192, 105, 1),
                            shape: BoxShape.circle,
                            border: Border.symmetric(
                                horizontal:
                                    BorderSide(width: 2, color: Colors.white),
                                vertical:
                                    BorderSide(width: 2, color: Colors.white))),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.userName!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  widget.room == 'contact' || widget.room == 'createGroup'
                      ? (widget.user.isOnline!
                          ? const Text(
                              'Online',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(173, 181, 189, 1)),
                            )
                          : const Text(
                              'Offline',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(173, 181, 189, 1)),
                            ))
                      : Text(
                          widget.chatRoom!.admin == widget.user.userId
                              ? 'Quản trị viên'
                              : 'Thành viên',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(173, 181, 189, 1)),
                        ),
                ],
              ),
              if (widget.room == 'createGroup') Spacer(),
              if (widget.room == 'createGroup')
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isChecked! ? kColorScheme.primary : null,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 3,
                        color: kColorScheme.primary,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: _isChecked
                          ? Icon(
                              Icons.check,
                              size: 18.0,
                              color: Color.fromARGB(255, 244, 234, 234),
                            )
                          : Icon(
                              null,
                              size: 18.0,
                            ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
