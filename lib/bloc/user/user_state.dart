part of 'user_bloc.dart';

abstract class UserState {
  final Users? user;
  UserState({required this.user});
}

class UserInitial extends UserState {
  UserInitial({required Users? user}) : super(user: user);
}

class UserUploaded extends UserState {
  UserUploaded({required Users? user}) : super(user: user);
}
