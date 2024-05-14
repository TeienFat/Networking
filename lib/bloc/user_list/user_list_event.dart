part of 'user_list_bloc.dart';

@immutable
abstract class UserListEvent {}

class LoadUserList extends UserListEvent {}

class AddUser extends UserListEvent {
  final String userId;
  final String userName;
  final String email;
  final String imageUrl;
  final bool gender;
  final DateTime? birthday;
  final String hobby;
  final String phone;
  final Map<String, dynamic> facebook;
  final Map<String, dynamic> zalo;
  final Map<String, dynamic> skype;
  final List<Address> address;
  final Map<String, dynamic> otherInfo;

  AddUser({
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

class DeleteUser extends UserListEvent {
  final String userId;

  DeleteUser({required this.userId});
}

class UpdateUserNotification extends UserListEvent {
  final String userId;
  final bool notification;
  UpdateUserNotification({required this.userId, required this.notification});
}

class UpdateUserIsShare extends UserListEvent {
  final String userId;
  final bool isShare;
  UpdateUserIsShare({required this.userId, required this.isShare});
}

class UpdateUser extends UserListEvent {
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
