part of 'user_list_bloc.dart';

abstract class UserListState {
  List<Users> users;
  UserListState({required this.users});
}

class UserListInitial extends UserListState {
  UserListInitial({required List<Users> users}) : super(users: users);
}

class UserListUploaded extends UserListState {
  UserListUploaded({required List<Users> users}) : super(users: users);
}
