import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/models/relationship_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/notification/local_notifications.dart';
import 'package:uuid/uuid.dart';

part 'us_re_list_event.dart';
part 'us_re_list_state.dart';

var uuid = Uuid();

class UsReListBloc extends Bloc<UsReListEvent, UsReListState> {
  UsReListBloc() : super(UsReListInitial(usRes: [])) {
    on<LoadUsReList>(
      (event, emit) async {
        emit(UsReListUploaded(usRes: await APIsUsRe.getAllMyRelationship()));
      },
    );
    on<AddUsRe>(_addUsRe);
    on<DeleteUsRe>(_deleteUsRe);
    on<UpdateTimeOfCareUsRe>(_updateTimeOfCareUsRe);
    on<UpdateRemidNotification>(_updateRemidNotification);
    on<UpdateHowLongRemid>(_updateHowLongRemid);
    on<UpdateScheduleNotification>(_updateScheduleNotification);
    on<UpdateBirthdayNotification>(_updateBirthdayNotification);
    on<UpdateUsRe>(_updateUsRe);
  }
  void _addUsRe(AddUsRe event, Emitter<UsReListState> emit) async {
    final usReId = uuid.v4();
    final id = DateTime.now().microsecondsSinceEpoch / 1000000;
    final newUsRe = UserRelationship(
        usReId: usReId,
        meId: event.meId,
        myRelationShipId: event.myReId,
        special: false,
        relationships: event.relationships,
        notification: {
          'remid': true,
          'schedule': true,
          'birthday': true,
          'id': id.round(),
          'howLong': 1
        },
        time_of_care: 0,
        createdAt: DateTime.now(),
        updateAt: null,
        deleteAt: null);
    state.usRes.add(newUsRe);
    APIsUsRe.createNewUsRe(newUsRe);
    emit(UsReListUploaded(usRes: state.usRes));
    APIsReCare.setNotificationRemind(
        [], newUsRe, usReId, event.myReId, event.userName, event.imageUrl);
    APIsUsRe.setNotificationBirthday(
        newUsRe, event.userName, event.imageUrl, event.birthday);
  }

  void _deleteUsRe(DeleteUsRe event, Emitter<UsReListState> emit) {
    for (int i = 0; i < state.usRes.length; i++) {
      if (event.usReId == state.usRes[i].usReId) {
        LocalNotifications.cancel(state.usRes[i].notification!['id']);
        LocalNotifications.cancel(state.usRes[i].notification!['id'] + 1);
        state.usRes.remove(state.usRes[i]);
        break;
      }
    }
    APIsUsRe.removeUsRe(event.usReId);
    emit(UsReListUploaded(usRes: state.usRes));
  }

  void _updateTimeOfCareUsRe(
      UpdateTimeOfCareUsRe event, Emitter<UsReListState> emit) {
    for (int i = 0; i < state.usRes.length; i++) {
      if (event.usReId == state.usRes[i].usReId) {
        state.usRes[i].time_of_care = event.timeOfCare;
      }
    }
    APIsUsRe.updateTimeOfCareUsRe(event.usReId, event.timeOfCare);
    emit(UsReListUploaded(usRes: state.usRes));
  }

  void _updateRemidNotification(
      UpdateRemidNotification event, Emitter<UsReListState> emit) {
    for (int i = 0; i < state.usRes.length; i++) {
      if (event.usReId == state.usRes[i].usReId) {
        state.usRes[i].notification!['remid'] = event.value;
        if (event.value) {
          APIsReCare.setNotificationRemind(
              null, null, state.usRes[i].usReId!, null, null, null);
        } else {
          LocalNotifications.cancel(state.usRes[i].notification!['id']);
        }
      }
    }
    APIsUsRe.updateRemidNotification(event.usReId, event.value);
    emit(UsReListUploaded(usRes: state.usRes));
  }

  void _updateHowLongRemid(
      UpdateHowLongRemid event, Emitter<UsReListState> emit) {
    for (int i = 0; i < state.usRes.length; i++) {
      if (event.usReId == state.usRes[i].usReId) {
        state.usRes[i].notification!['howLong'] = event.long;
        if (state.usRes[i].notification!['remid']) {
          APIsReCare.setNotificationRemind(
              null, null, event.usReId, null, null, null);
        }
      }
    }
    APIsUsRe.updateHowLongRemid(event.usReId, event.long);
    emit(UsReListUploaded(usRes: state.usRes));
  }

  void _updateScheduleNotification(
      UpdateScheduleNotification event, Emitter<UsReListState> emit) {
    for (int i = 0; i < state.usRes.length; i++) {
      if (event.usRe.usReId == state.usRes[i].usReId) {
        state.usRes[i].notification!['schedule'] = event.value;
      }
    }
    APIsUsRe.updateScheduleNotification(event.usRe.usReId!, event.value);
    emit(UsReListUploaded(usRes: state.usRes));
    APIsReCare.setNotificationSchedule(event.usRe, event.value);
  }

  void _updateBirthdayNotification(
      UpdateBirthdayNotification event, Emitter<UsReListState> emit) {
    for (int i = 0; i < state.usRes.length; i++) {
      if (event.usReId == state.usRes[i].usReId) {
        state.usRes[i].notification!['birthday'] = event.value;
        if (event.value) {
          APIsUsRe.setNotificationBirthday(state.usRes[i], null, null, null);
        } else {
          LocalNotifications.cancel(state.usRes[i].notification!['id'] + 1);
        }
      }
    }
    APIsUsRe.updateBirthdayNotification(event.usReId, event.value);
    emit(UsReListUploaded(usRes: state.usRes));
  }

  void _updateUsRe(UpdateUsRe event, Emitter<UsReListState> emit) {
    for (int i = 0; i < state.usRes.length; i++) {
      if (event.usReId == state.usRes[i].usReId) {
        state.usRes[i].relationships = event.relationships;
        state.usRes[i].special = event.special;
        LocalNotifications.cancel(state.usRes[i].notification!['id'] + 1);
        APIsUsRe.setNotificationBirthday(state.usRes[i], null, null, null);
      }
    }
    APIsUsRe.updateUsRe(event.usReId, event.special, event.relationships);
    emit(UsReListUploaded(usRes: state.usRes));
  }
}
