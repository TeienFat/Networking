import 'package:bloc/bloc.dart';
import 'package:networking/models/address_model.dart';
import 'package:networking/models/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial(user: null)) {
    on<LoadUser>(
      (event, emit) async {
        emit(UserUploaded(user: event.user));
      },
    );
    // on<AddUser>(_addUser);
    // on<DeleteUser>(_deleteUser);
    on<UpdateUser>(_updateUser);
  }

  // void _addUser(AddUser event, Emitter<UserListState> emit) {
  //   state.users.add(event.user);
  //   emit(UserListUploaded(users: state.users));
  // }

  // void _deleteUser(DeleteUser event, Emitter<UserListState> emit) {
  //   state.users.remove(event.user);
  //   emit(UserListUploaded(users: state.users));
  // }

  void _updateUser(UpdateUser event, Emitter<UserState> emit) {
    state.user!.userName = event.userName;
    state.user!.email = event.email;
    state.user!.imageUrl = event.imageUrl;
    state.user!.gender = event.gender;
    state.user!.birthday = event.birthday;
    state.user!.hobby = event.hobby;
    state.user!.phone = event.phone;
    state.user!.facebook = event.facebook;
    state.user!.zalo = event.zalo;
    state.user!.skype = event.skype;
    state.user!.address = event.address;
    state.user!.otherInfo = event.otherInfo;
    state.user!.updateAt = DateTime.now();

    emit(UserUploaded(user: state.user));
  }
}
