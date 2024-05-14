import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/main.dart';
import 'package:networking/models/chatroom_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:networking/models/message_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:tiengviet/tiengviet.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class APIsChat {
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static String token = "";

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('user')
        .where('userId', isNotEqualTo: currentUserId)
        .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getParticipants(
      String chatroomId) {
    return firestore.collection('chatrooms').doc(chatroomId).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllChatroom() {
    return firestore
        .collection('chatrooms')
        .where('participants.${currentUserId}', isEqualTo: true)
        .snapshots();
  }

  static Future<String> saveMedia(
      int type, String mediaName, File mediaFile, String path) async {
    final ext = mediaFile.path.split('.').last; // lấy định dạng file
    final storageRef =
        await fireStorage.ref().child(path).child('${mediaName}.$ext');
    switch (type) {
      case 0:
        // lưu file là image
        await storageRef.putFile(
            mediaFile, SettableMetadata(contentType: 'image/$ext'));
        break;
      case 1:
        // lưu file là video
        await storageRef.putFile(
            mediaFile, SettableMetadata(contentType: 'video/$ext'));
        break;
    }

    return await storageRef.getDownloadURL();
  }

  static Future<void> createNewUser(Users user) async {
    return await firestore
        .collection('user')
        .doc(user.userId!)
        .set(user.toMap());
  }

  static Future<String> getChatroomIdWhenUserHasChatRoomDirect(
      String? currentUserid, String userId) async {
    QuerySnapshot querySnapshot = await firestore.collection('chatrooms').get();

    String chatroomId = '';

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      bool isDirect = document['type'];
      if (isDirect) {
        Map<String, bool> mapParticipants =
            Map<String, bool>.from(document['participants']);
        if (mapParticipants.containsKey(userId) &&
            mapParticipants.containsKey(currentUserid))
          chatroomId = document['chatroomid'];
      }
    }
    return chatroomId;
  }

  static Future<ChatRoom> createDirectChatroom(
      String userId, String newChatroomId) async {
    String chatroomId = await getChatroomIdWhenUserHasChatRoomDirect(
        await APIsAuth.getCurrentUserId(), userId);

    ChatRoom chatroom;

    if (chatroomId.isNotEmpty) {
      DocumentSnapshot docSnap =
          await firestore.collection('chatrooms').doc(chatroomId).get();

      chatroom = ChatRoom.fromMap(docSnap.data() as Map<String, dynamic>);
    } else {
      chatroom = ChatRoom(
        chatroomid: newChatroomId,
        chatroomname: '',
        imageUrl: '',
        participants: ({
          await APIsAuth.getCurrentUserId() ?? '': false,
          userId: false
        }),
        type: true,
        isRequests: ({'from': '', 'to': ''}),
        lastSend: '0',
        admin: '',
      );
      await firestore
          .collection('chatrooms')
          .doc(newChatroomId)
          .set(chatroom.toMap());
    }
    return chatroom;
  }

  static Future<ChatRoom> getChatRoomFromId(String chatRoomId) async {
    ChatRoom chatRoom;

    DocumentSnapshot docSnap =
        await firestore.collection('chatrooms').doc(chatRoomId).get();

    chatRoom = ChatRoom.fromMap(docSnap.data() as Map<String, dynamic>);

    return chatRoom;
  }

  static Future<Users> getUserFormId(String uid) async {
    Users userchat;

    DocumentSnapshot docSnap =
        await firestore.collection('user').doc(uid).get();

    userchat = Users.fromMap(docSnap.data() as Map<String, dynamic>);

    return userchat;
  }

  static Future<void> updateUserFormId(Users userChat) async {
    DocumentReference? documentReference;
    await documentReference!.update(userChat.toMap());
  }

  static getLastWordOfName(String name) {
    List<String> words = name.split(" ");
    return words[words.length - 1];
  }

  static Future<void> deleteChatRoom(String chatroomId) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('chatrooms').doc(chatroomId).get();
    Map<String, bool> participantsMap =
        Map<String, bool>.from(documentSnapshot['participants']);

    participantsMap.update(currentUserId, (value) => false);
    await firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .update({'participants': participantsMap});
    var querySnapshot = await firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .get();
    participantsMap.remove(currentUserId);
    querySnapshot.docs.forEach((element) {
      element.reference.update({'receivers': participantsMap.keys});
    });
  }

  static Future<String> getChatRoomName(ChatRoom chatRoom) async {
    Map<String, bool> participants = chatRoom.participants!;
    List<String> listId = participants.keys.toList();

    listId.removeWhere((element) => element == currentUserId);
    int numOfParticipants = listId.length;
    if (numOfParticipants > 2) {
      listId = listId.sublist(1, 3);
    }
    String name = "";
    for (var i = 0; i <= 1; i++) {
      Users userchat;

      DocumentSnapshot docSnap =
          await firestore.collection('user').doc(listId[i]).get();

      userchat = Users.fromMap(docSnap.data() as Map<String, dynamic>);
      if (i == 0) {
        name = name + getLastWordOfName(userchat.userName!) + ", ";
      } else {
        name = name + getLastWordOfName(userchat.userName!);
      }
    }
    if ((numOfParticipants - 3) <= 0)
      return name;
    else
      return name + " và " + (numOfParticipants - 2).toString() + " người khác";
  }

  static Future<String> getChatroomIdWhenUserHasChatRoomGroup(
      Map<String, bool> participantsId) async {
    QuerySnapshot querySnapshot = await firestore.collection('chatrooms').get();

    String chatroomId = '';

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      bool isDirect = document['type'];
      if (!isDirect) {
        Map<String, bool> mapParticipants =
            Map<String, bool>.from(document['participants']);
        if (mapParticipants.keys.length == participantsId.keys.length &&
            mapParticipants.keys
                .every((key) => participantsId.containsKey(key))) {
          chatroomId = document['chatroomid'];
        }
      }
    }
    return chatroomId;
  }

  static Future<ChatRoom> createGroupChatroom(Map<String, bool> participantsId,
      String chatRoomId, String chatRoomName) async {
    Users userchat;

    DocumentSnapshot docSnap =
        await firestore.collection('user').doc(currentUserId).get();

    userchat = Users.fromMap(docSnap.data() as Map<String, dynamic>);

    participantsId.addAll({currentUserId: true});

    ChatRoom chatroom;

    String chatRoomid =
        await getChatroomIdWhenUserHasChatRoomGroup(participantsId);

    if (chatRoomid.isNotEmpty) {
      DocumentSnapshot docSnap =
          await firestore.collection('chatrooms').doc(chatRoomid).get();

      chatroom = ChatRoom.fromMap(docSnap.data() as Map<String, dynamic>);
    } else {
      chatroom = ChatRoom(
          chatroomid: chatRoomId,
          chatroomname: chatRoomName,
          imageUrl: '',
          participants: participantsId,
          type: false,
          isRequests: ({}),
          lastSend: '0',
          admin: currentUserId);
      await firestore
          .collection('chatrooms')
          .doc(chatRoomId)
          .set(chatroom.toMap());
      await sendMessage(chatroom, userchat.userName! + " đã tạo nhóm",
          TypeSend.notification, null);
    }
    return chatroom;
  }

  static Future<void> leaveTheGroupChat(
      ChatRoom chatRoom, String userId) async {
    Map<String, bool> participants = chatRoom.participants!;
    participants.removeWhere((key, value) => key == userId);
    return await firestore
        .collection('chatrooms')
        .doc(chatRoom.chatroomid)
        .update({'participants': participants});
  }

  static Future<void> sendMessage(ChatRoom chatRoom, String msg, TypeSend type,
      MessageChat? messRep) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('chatrooms').doc(chatRoom.chatroomid).get();
    Map<String, bool> participantsMap =
        Map<String, bool>.from(documentSnapshot['participants']);

    if (chatRoom.type!) {
      String user = participantsMap.keys
          .firstWhere((element) => element != currentUserId)
          .toString();
      QuerySnapshot querySnapshotMessage = await firestore
          .collection('chatrooms')
          .doc(chatRoom.chatroomid)
          .collection('messages')
          .limit(1)
          .get();
      if (querySnapshotMessage.docs.isEmpty) {
        await firestore
            .collection('chatrooms')
            .doc(chatRoom.chatroomid)
            .update({
          'isRequests': {'from': currentUserId, 'to': user}
        });
      }
      if (!await isBlockedByOther(user)) {
        participantsMap.updateAll((key, value) => true);
        await firestore
            .collection('chatrooms')
            .doc(chatRoom.chatroomid)
            .update({'participants': participantsMap});
      } else {
        participantsMap.removeWhere((key, value) => key == user);
      }
    } else {
      participantsMap.updateAll((key, value) => true);
      await firestore
          .collection('chatrooms')
          .doc(chatRoom.chatroomid)
          .update({'participants': participantsMap});
    }
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final messageId = uuid.v8();

    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUserId)
        .get();
    Users user = Users.fromMap(userData.data()!);

    final MessageChat message = MessageChat(
        messageId: messageId,
        fromId: currentUserId,
        msg: msg,
        read: [],
        sent: now,
        userName: user.userName,
        userImage: user.imageUrl,
        type: type,
        receivers: participantsMap.keys.toList(),
        isPin: "",
        messageReply: messRep != null
            ? ({
                'messageId': messRep.messageId,
                'fromId': messRep.fromId,
                'userName': messRep.userName,
                'type': messRep.type!.name,
                'msg': messRep.msg
              })
            : ({}));

    await firestore
        .collection('chatrooms')
        .doc(chatRoom.chatroomid)
        .update({'lastSend': now});
    await firestore
        .collection('chatrooms')
        .doc(chatRoom.chatroomid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap())
        .then((value) {
      participantsMap.keys
          .where((element) => element != currentUserId)
          .toList()
          .forEach((element) async {
        final userChatData = await FirebaseFirestore.instance
            .collection('user')
            .doc(element)
            .get();
        Users userChat = Users.fromMap(userChatData.data()!);
        sendNotification(
            userChat,
            user.userName!,
            chatRoom,
            type == TypeSend.text || type == TypeSend.notification
                ? msg
                : (type == TypeSend.image
                    ? 'Đã gửi một ảnh'
                    : (type == TypeSend.video
                        ? 'Đã gửi một video'
                        : 'Đã gửi một file')));
      });
    });
  }

  static Future<void> sendMediaMessage(
      int type, ChatRoom chatRoom, File mediaFile, MessageChat? messRep) async {
    final mediaName = DateTime.now().millisecondsSinceEpoch;
    var mediaUrl;
    switch (type) {
      case 0:
        mediaUrl = await saveMedia(
            0, mediaName.toString(), mediaFile, 'message_images');
        await sendMessage(chatRoom, mediaUrl, TypeSend.image,
            messRep != null ? messRep : null);
        break;
      case 1:
        mediaUrl = await saveMedia(
            1, mediaName.toString(), mediaFile, 'message_images');
        await sendMessage(chatRoom, mediaUrl, TypeSend.video,
            messRep != null ? messRep : null);
        break;
    }
  }

  static Future<void> updateMessageReadStatus(
      String chatRoomId, String messageId) async {
    // final now = DateTime.now().millisecondsSinceEpoch.toString();

    DocumentSnapshot document = await firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .get();
    List<dynamic> listUserRead = document['read'];
    listUserRead.add(currentUserId);
    firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection("messages")
        .doc(messageId)
        .update({'read': listUserRead});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      String chatRoomId) {
    return firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receivers', arrayContains: currentUserId)
        .snapshots();
  }

  static Future<Map<String, String>> getNameInfo() async {
    Map<String, String> mapName = ({});

    QuerySnapshot chatRoomQuerySnapshot =
        await firestore.collection('chatrooms').get();
    for (QueryDocumentSnapshot room in chatRoomQuerySnapshot.docs) {
      if (room['chatroomname'] != '')
        mapName.addAll({room['chatroomid']: room['chatroomname']});
    }
    QuerySnapshot userQuerySnapshot = await firestore.collection('user').get();
    for (QueryDocumentSnapshot user in userQuerySnapshot.docs) {
      mapName.addAll({user['userId']: user['userName']});
    }
    return mapName;
  }

  static Future<void> acceptRequestsMessage(String chatRoomId) async {
    await firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .update({'isRequests': ({})});
  }

  static Future<List<MessageChat>> getSearchMessage(
      String _enteredWord, String chatRoomId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .get();

    List<MessageChat> listMessage = querySnapshot.docs
        .map((e) => MessageChat.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    List<MessageChat> listSearchMessage = [];
    for (MessageChat message in listMessage) {
      if (TiengViet.parse(message.msg!)
          .toLowerCase()
          .contains(TiengViet.parse(_enteredWord).toLowerCase())) {
        listSearchMessage.add(message);
      }
    }
    return listSearchMessage;
  }

  static Future<void> updateStatus(bool isOnline) async {
    await firestore
        .collection('user')
        .doc(currentUserId)
        .update({'isOnline': isOnline, 'token': token});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getInfoUser(
      String userId) {
    return firestore
        .collection('user')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  static Future<void> blockUser(String idUser) async {
    await firestore.collection('user').doc(currentUserId).update(
      {
        'blockUsers': FieldValue.arrayUnion([idUser]),
      },
    );
    var querySnapshot = await firestore.collection('chatrooms').get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, bool> mapParticipants =
          Map<String, bool>.from(doc['participants']);
      String chatroomId = doc['chatroomid'];
      bool type = doc['type'];
      if (type) if (mapParticipants.containsKey(idUser) &&
          mapParticipants.containsKey(currentUserId)) {
        mapParticipants.update(currentUserId, (value) => false);
        await firestore
            .collection('chatrooms')
            .doc(chatroomId)
            .update({'participants': mapParticipants});
      }
    }
  }

  static Future<bool> isBlockedByOther(String idUser) async {
    DocumentSnapshot document =
        await firestore.collection('user').doc(idUser).get();
    List<dynamic> listBlockUsers = document['blockUsers'];

    if (listBlockUsers.contains(currentUserId)) {
      return true;
    } else
      return false;
  }

  static Future<bool> hasBlockOther(String idUser) async {
    DocumentSnapshot document =
        await firestore.collection('user').doc(currentUserId).get();
    List<dynamic> listBlockUsers = document['blockUsers'];
    if (listBlockUsers.contains(idUser)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> getFirebaseMessageingToken() async {
    await firebaseMessaging.requestPermission();
    firebaseMessaging.getToken().then((t) {
      if (t != null) {
        token = t;
        print('Push token: $t');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static Future<void> sendNotification(
      Users userChat, String username, ChatRoom chatroom, String msg) async {
    try {
      String chatRoomName = "";
      final body;
      if (chatroom.type!) {
        body = {
          "to": userChat.token,
          "notification": {
            "title": username,
            "body": msg,
            "android_channel_id": "chatApp"
          },
        };
      } else {
        chatRoomName = await getChatRoomName(chatroom);
        body = {
          "to": userChat.token,
          "notification": {
            "title": chatroom.chatroomname!.isNotEmpty
                ? chatroom.chatroomname!
                : chatRoomName,
            "body": username + ": " + msg,
            "android_channel_id": "chatApp"
          },
        };
      }
      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAAyIzqsa4:APA91bGuZ6FkmLcZmsYIZtjNamGactWlmyXVRL8yuiwNjk4-Tf7ukUo_TWurGtw2b7pZZBneByzKJv_F8TAzN01hW93bcV88Coi-cRwX8tnm0_pcU7gMHVplwOyZQ3zyw_dhaNCrvetl'
              },
              body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('\nSendNotification: $e');
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String chatRoomId) {
    return firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> pinMessage(
      String messageId, String chatroomId, bool pin) async {
    if (pin) {
      final now = DateTime.now().millisecondsSinceEpoch.toString();
      await firestore
          .collection('chatrooms')
          .doc(chatroomId)
          .collection('messages')
          .doc(messageId)
          .update({'isPin': now});
    } else {
      await firestore
          .collection('chatrooms')
          .doc(chatroomId)
          .collection('messages')
          .doc(messageId)
          .update({'isPin': ""});
    }
  }

  static Future<bool> checkPinMessage(
      String messageId, String chatroomId) async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .doc(messageId)
        .get();
    String isPin = documentSnapshot['isPin'];
    if (isPin.isNotEmpty) {
      return true;
    } else
      return false;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPinMessage(
      String chatroomId) {
    return firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .where('isPin', isNotEqualTo: "")
        .snapshots();
  }

  static Future<void> updateImageUser(
      String userID, File imageFile, String imgID) async {
    final storageRef =
        await fireStorage.ref().child('user_images').child('${userID}.jpg');

    if (imgID != '') {
      await storageRef.delete();
    }

    String imgURL = await saveMedia(0, userID, imageFile, 'user_images');
    return await firestore
        .collection('user')
        .doc(userID)
        .update({'imageUrl': imgURL});
  }

  static Future<String> updateImageChatRoom(
      String chatRoomID, File imageFile, String imgID) async {
    final storageRef = await fireStorage
        .ref()
        .child('chatroom_images')
        .child('${chatRoomID}.jpg');
    final storageRef1 = await fireStorage
        .ref()
        .child('chatroom_images')
        .child('${chatRoomID}.png');
    if (imgID != '') {
      await storageRef
          .delete()
          .onError((error, stackTrace) => storageRef1.delete());
    }
    String imgURL =
        await saveMedia(0, chatRoomID, imageFile, 'chatroom_images');
    await firestore
        .collection('chatrooms')
        .doc(chatRoomID)
        .update({'imageUrl': imgURL});
    return imgURL;
  }

  static Future<void> updateNameChatRoom(
      String chatRomID, String chatRoomName) async {
    return firestore
        .collection('chatrooms')
        .doc(chatRomID)
        .update({'chatroomname': chatRoomName});
  }

  static Future<void> updateUserName(String userName) async {
    return firestore
        .collection('user')
        .doc(currentUserId)
        .update({'userName': userName});
  }
}
