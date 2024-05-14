class ChatRoom {
  String? chatroomid;
  String? chatroomname;
  String? imageUrl;
  Map<String, bool>? participants;
  bool? type;
  Map<String, String>? isRequests;
  String? lastSend;
  String? admin;

  ChatRoom(
      {required this.chatroomid,
      required this.chatroomname,
      required this.imageUrl,
      required this.participants,
      required this.type,
      required this.isRequests,
      required this.lastSend,
      required this.admin});

  ChatRoom.fromMap(Map<String, dynamic> map) {
    chatroomid = map['chatroomid'];
    chatroomname = map['chatroomname'];
    imageUrl = map['imageUrl'];
    participants = Map<String, bool>.from(map['participants']);
    type = map['type'];
    isRequests = Map<String, String>.from(map['isRequests']);
    lastSend = map['lastSend'];
    admin = map['admin'];
  }

  Map<String, dynamic> toMap() {
    return ({
      'chatroomid': chatroomid,
      'chatroomname': chatroomname,
      'imageUrl': imageUrl,
      'participants': participants,
      'type': type,
      'isRequests': isRequests,
      'lastSend': lastSend,
      'admin': admin,
    });
  }
}
