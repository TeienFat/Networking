import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/models/address_model.dart';
import 'package:networking/models/user_model.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  UserListBloc() : super(UserListInitial(users: [])) {
    on<LoadUserList>(
      (event, emit) async {
        emit(UserListUploaded(users: await APIsUser.getAllUser()));
      },
    );
    on<AddUser>(_addUser);
    on<DeleteUser>(_deleteUser);
    on<UpdateUserNotification>(_updateUserNotification);
    on<UpdateUserIsShare>(_updateUserIsShare);
    on<UpdateUserNumDayOfAutoDelete>(_updateUserNumDayOfAutoDelete);
    on<UpdateUser>(_updateUser);
  }

  void _addUser(AddUser event, Emitter<UserListState> emit) {
    final newUser = Users(
        userId: event.userId,
        userName: event.userName,
        email: event.email,
        imageUrl: event.imageUrl,
        gender: event.gender,
        birthday: event.birthday,
        hobby: event.hobby,
        phone: event.phone,
        facebook: event.facebook,
        zalo: event.zalo,
        skype: event.skype,
        address: event.address,
        otherInfo: event.otherInfo,
        notification: true,
        createdAt: DateTime.now(),
        updateAt: null,
        deleteAt: null,
        numDayOfAutoDelete: 30,
        isShare: false,
        isOnline: false,
        blockUsers: [],
        token: '');
    state.users.add(newUser);
    APIsUser.createNewUser(newUser);
    emit(UserListUploaded(users: state.users));
  }

  void _deleteUser(DeleteUser event, Emitter<UserListState> emit) {
    for (int i = 0; i < state.users.length; i++) {
      if (event.userId == state.users[i].userId) {
        state.users.remove(state.users[i]);
        break;
      }
    }
    APIsUser.removeUser(event.userId);
    emit(UserListUploaded(users: state.users));
  }

  void _updateUserNotification(
      UpdateUserNotification event, Emitter<UserListState> emit) async {
    for (int i = 0; i < state.users.length; i++) {
      if (event.userId == state.users[i].userId) {
        state.users[i].notification = event.notification;
        state.users[i].updateAt = DateTime.now();
      }
    }
    APIsUser.UpdateUserNotification(
      event.userId,
      event.notification,
    );
    emit(UserListUploaded(users: state.users));
    APIsUsRe.setNotificationForAllUsRe(event.notification);
  }

  void _updateUserNumDayOfAutoDelete(
      UpdateUserNumDayOfAutoDelete event, Emitter<UserListState> emit) async {
    for (int i = 0; i < state.users.length; i++) {
      if (event.userId == state.users[i].userId) {
        state.users[i].numDayOfAutoDelete = event.numDayOfAutoDelete;
        state.users[i].updateAt = DateTime.now();
      }
    }
    APIsUser.UpdateUserNumDayOfAutoDelete(
      event.userId,
      event.numDayOfAutoDelete,
    );
    emit(UserListUploaded(users: state.users));
  }

  void _updateUserIsShare(
      UpdateUserIsShare event, Emitter<UserListState> emit) async {
    for (int i = 0; i < state.users.length; i++) {
      if (event.userId == state.users[i].userId) {
        state.users[i].isShare = event.isShare;
        state.users[i].updateAt = DateTime.now();
      }
    }
    APIsUser.UpdateUserIsShare(event.userId, event.isShare);
    emit(UserListUploaded(users: state.users));
  }

  void _updateUser(UpdateUser event, Emitter<UserListState> emit) {
    for (int i = 0; i < state.users.length; i++) {
      if (event.userId == state.users[i].userId) {
        state.users[i].userName = event.userName;
        state.users[i].email = event.email;
        state.users[i].imageUrl = event.imageUrl;
        state.users[i].gender = event.gender;
        state.users[i].birthday = event.birthday;
        state.users[i].hobby = event.hobby;
        state.users[i].phone = event.phone;
        state.users[i].facebook = event.facebook;
        state.users[i].zalo = event.zalo;
        state.users[i].skype = event.skype;
        state.users[i].address = event.address;
        state.users[i].otherInfo = event.otherInfo;
        state.users[i].updateAt = DateTime.now();
      }
    }
    APIsUser.updateUser(
      event.userId,
      event.userName,
      event.email,
      event.imageUrl,
      event.gender,
      event.birthday,
      event.hobby,
      event.phone,
      event.facebook,
      event.zalo,
      event.skype,
      event.address,
      event.otherInfo,
    );
    emit(UserListUploaded(users: state.users));
  }
}
