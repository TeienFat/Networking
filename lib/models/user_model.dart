import 'package:networking/models/address_model.dart';

class Users {
  String? userId;
  String? userName;
  String? email;
  String? imageUrl;
  bool? gender;
  DateTime? birthday;
  String? hobby;
  String? phone;
  Map<String, dynamic>? facebook;
  Map<String, dynamic>? zalo;
  Map<String, dynamic>? skype;
  List<Address>? address;
  Map<String, dynamic>? otherInfo;
  DateTime? createdAt;
  DateTime? updateAt;
  DateTime? deleteAt;
  bool? isOnline;
  List<String>? blockUsers;
  String? token;

  Users({
    required this.userId,
    required this.userName,
    required this.email,
    required this.imageUrl,
    required this.gender,
    required this.birthday,
    required this.hobby,
    required this.phone,
    required this.facebook,
    required this.zalo,
    required this.skype,
    required this.address,
    required this.otherInfo,
    required this.createdAt,
    required this.updateAt,
    required this.deleteAt,
    required this.isOnline,
    required this.blockUsers,
    required this.token,
  });

  Users.fromMap(Map<String, dynamic> map) {
    userId = map['userId'];
    userName = map['userName'];
    email = map['email'];
    imageUrl = map['imageUrl'];
    gender = map['gender'];
    birthday = map['birthday'] != null ? DateTime.parse(map['birthday']) : null;
    hobby = map['hobby'];
    phone = map['phone'];
    facebook = map['facebook'];
    zalo = map['zalo'];
    skype = map['skype'];
    address = map['address'] != null ? Address.decode(map['address']) : null;
    otherInfo = map['otherInfo'];
    createdAt =
        map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null;
    updateAt = map['updateAt'] != null ? DateTime.parse(map['updateAt']) : null;
    deleteAt = map['deleteAt'] != null ? DateTime.parse(map['deleteAt']) : null;
    isOnline = map['isOnline'];
    blockUsers = List<String>.from(map['blockUsers']);
    token = map['token'];
  }
  Map<String, dynamic> toMap() {
    return ({
      "userId": userId,
      "userName": userName,
      "email": email,
      "imageUrl": imageUrl,
      "gender": gender,
      "birthday": birthday != null ? birthday!.toIso8601String() : null,
      "hobby": hobby,
      "phone": phone,
      "facebook": facebook,
      "zalo": zalo,
      "skype": skype,
      "address": Address.encode(address!),
      "otherInfo": otherInfo,
      "createdAt": createdAt != null ? createdAt!.toIso8601String() : null,
      "updateAt": updateAt != null ? updateAt!.toIso8601String() : null,
      "deleteAt": deleteAt != null ? deleteAt!.toIso8601String() : null,
      "isOnline": isOnline,
      "blockUsers": blockUsers,
      "token": token
    });
  }
}
