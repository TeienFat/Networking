part of 'user_bloc.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {
  final Users? user;
  LoadUser(this.user);
}

class AddUser extends UserEvent {
  final Users user;

  AddUser({required this.user});
}

class DeleteUser extends UserEvent {
  final Users user;

  DeleteUser({required this.user});
}

class UpdateUser extends UserEvent {
  final String userId;
  final String userName;
  final String email;
  final String imageUrl;
  final bool gender;
  final DateTime? birthday;
  final String hobby;
  final String phone;
  final List<Address> address;
  final Map<String, dynamic> otherInfo;
  final Map<String, dynamic> facebook;
  final Map<String, dynamic> zalo;
  final Map<String, dynamic> skype;
  UpdateUser({
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
  });
}
