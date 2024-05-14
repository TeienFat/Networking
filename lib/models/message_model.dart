class MessageChat {
  String? messageId;
  String? fromId;
  String? msg;
  List<String>? read;
  String? sent;
  String? userName;
  String? userImage;
  TypeSend? type;
  List<String>? receivers;
  String? isPin;
  Map<String, dynamic>? messageReply;

  MessageChat(
      {required this.messageId,
      required this.fromId,
      required this.msg,
      required this.read,
      required this.sent,
      required this.userName,
      required this.userImage,
      required this.type,
      required this.receivers,
      required this.isPin,
      required this.messageReply});

  MessageChat.fromMap(Map<String, dynamic> map) {
    messageId = map['messageId'];
    fromId = map['fromId'];
    msg = map['msg'];
    read = List<String>.from(map['read']);
    sent = map['sent'];
    userName = map['userName'];
    userImage = map['userImage'];
    type = map['type'] == TypeSend.text.name
        ? TypeSend.text
        : map['type'] == TypeSend.image.name
            ? TypeSend.image
            : map['type'] == TypeSend.video.name
                ? TypeSend.video
                : TypeSend.notification;
    receivers = List<String>.from(map['receivers']);
    isPin = map['isPin'];
    messageReply = Map<String, dynamic>.from(map['messageReply']);
  }

  Map<String, dynamic> toMap() {
    return ({
      'messageId': messageId,
      'fromId': fromId,
      'msg': msg,
      'read': read,
      'sent': sent,
      'userName': userName,
      'userImage': userImage,
      'type': type!.name,
      'receivers': receivers,
      'isPin': isPin,
      'messageReply': messageReply,
    });
  }
}

enum TypeSend { text, image, video, file, sound, notification }
