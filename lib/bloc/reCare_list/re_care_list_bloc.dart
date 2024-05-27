import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/apis/apis_auth.dart';
import 'package:networking/apis/apis_user.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:networking/models/user_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:networking/notification/local_notifications.dart';
import 'package:uuid/uuid.dart';

part 're_care_list_event.dart';
part 're_care_list_state.dart';

var uuid = Uuid();

class ReCareListBloc extends Bloc<ReCareListEvent, ReCareListState> {
  ReCareListBloc() : super(ReCareListInitial(reCares: [])) {
    on<LoadReCareList>(
      (event, emit) async {
        emit(ReCareListUploaded(
            reCares: await APIsReCare.getAllMyRelationshipCare()));
      },
    );
    on<AddReCare>(_addReCare);
    on<AddContentText>(_addContentText);
    on<AddContentImage>(_addContentImage);
    on<RemoveContentImage>(_deleteContentImage);
    on<DeleteReCare>(_deleteReCare);
    on<UpdateIsFinish>(_updateIsFinish);
    on<UpdateReCare>(_updateReCare);
  }
  void _addReCare(AddReCare event, Emitter<ReCareListState> emit) async {
    final newReCare = RelationshipCare(
        reCareId: event.reCareId.toString(),
        meId: event.meId,
        usReId: event.usRe.usReId,
        startTime: event.startTime,
        endTime: event.endTime,
        title: event.title,
        contentText: '',
        contentImage: [],
        isFinish: 2,
        createdAt: DateTime.now(),
        updateAt: null,
        deleteAt: null);
    state.reCares.add(newReCare);
    APIsReCare.createNewReCare(newReCare);
    emit(ReCareListUploaded(reCares: state.reCares));
    final myId = await APIsAuth.getCurrentUserId();
    Users? isMe = await APIsUser.getUserFromId(myId!);
    if (isMe!.notification!) {
      if (event.usRe.notification!['schedule']) {
        List<String> payload = [
          jsonEncode(newReCare.toMap()),
          jsonEncode(event.usRe.toMap())
        ];
        LocalNotifications.showScheduleNotification(
            dateTime: event.startTime,
            id: event.reCareId.round(),
            title: "Chăm sóc nào!",
            body: "\u{1F389}\u{1F37B} " + event.title,
            iconPath: event.users.imageUrl!,
            contentBody: [
              event.users.userName! + ' - ' + event.usRe.relationships![0].name!
            ],
            payload: jsonEncode(payload));
      }
    }
    if (event.usRe.notification!['remid']) {
      APIsReCare.setNotificationRemind(
          state.reCares, null, event.usRe.usReId!, null, null, null);
    }
  }

  void _addContentText(AddContentText event, Emitter<ReCareListState> emit) {
    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares[i].contentText = event.contentText;
      }
    }

    APIsReCare.addContentText(event.reCareId, event.contentText);
    emit(ReCareListUploaded(reCares: state.reCares));
  }

  void _addContentImage(AddContentImage event, Emitter<ReCareListState> emit) {
    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares[i].contentImage!.add(event.imageUrl);
      }
    }

    APIsReCare.addContentImage(event.reCareId, event.imageUrl);
    emit(ReCareListUploaded(reCares: state.reCares));
  }

  void _deleteContentImage(
      RemoveContentImage event, Emitter<ReCareListState> emit) {
    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares[i].contentImage!.remove(event.imageUrl);
      }
    }

    APIsReCare.removeContentImage(event.reCareId, event.imageUrl);
    emit(ReCareListUploaded(reCares: state.reCares));
  }

  void _deleteReCare(DeleteReCare event, Emitter<ReCareListState> emit) {
    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares.remove(state.reCares[i]);
        break;
      }
    }
    int id = double.parse(event.reCareId).round();
    APIsReCare.removeReCare(event.reCareId);
    emit(ReCareListUploaded(reCares: state.reCares));
    LocalNotifications.cancel(id);

    if (event.usRe.notification!['remid']) {
      APIsReCare.setNotificationRemind(
          state.reCares, null, event.usRe.usReId!, null, null, null);
    }
  }

  void _updateIsFinish(UpdateIsFinish event, Emitter<ReCareListState> emit) {
    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares[i].isFinish = event.isFinish;
      }
    }
    APIsReCare.updateIsFinish(event.reCareId, event.isFinish);
    emit(ReCareListUploaded(reCares: state.reCares));
  }

  void _updateReCare(UpdateReCare event, Emitter<ReCareListState> emit) async {
    RelationshipCare? reCarePayload;

    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares[i].usReId = event.usRe.usReId;
        state.reCares[i].title = event.title;
        state.reCares[i].startTime = event.startTime;
        state.reCares[i].endTime = event.endTime;
        reCarePayload = RelationshipCare(
            reCareId: event.reCareId,
            meId: state.reCares[i].meId,
            usReId: event.usRe.usReId,
            startTime: event.startTime,
            endTime: event.endTime,
            title: event.title,
            contentText: '',
            contentImage: [],
            isFinish: 2,
            createdAt: state.reCares[i].createdAt,
            updateAt: DateTime.now(),
            deleteAt: null);
      }
    }

    APIsReCare.updateReCare(event.reCareId, event.title, event.usRe.usReId!,
        event.startTime, event.endTime);
    int id = double.parse(event.reCareId).round();
    LocalNotifications.cancel(id);
    emit(ReCareListUploaded(reCares: state.reCares));
    final myId = await APIsAuth.getCurrentUserId();
    Users? isMe = await APIsUser.getUserFromId(myId!);
    if (isMe!.notification!) {
      if (event.usRe.notification!['schedule']) {
        List<String> payload = [
          jsonEncode(reCarePayload!.toMap()),
          jsonEncode(event.usRe.toMap())
        ];
        LocalNotifications.showScheduleNotification(
            dateTime: event.startTime,
            id: id,
            title: "Chăm sóc nào!",
            body: event.title,
            iconPath: event.users.imageUrl!,
            contentBody: [
              event.users.userName! + ' - ' + event.usRe.relationships![0].name!
            ],
            payload: jsonEncode(payload));
      }
    }
    if (event.usRe.notification!['remid']) {
      if (event.usRe.usReId! == event.usRe.usReId!) {
        APIsReCare.setNotificationRemind(
            state.reCares, null, event.usRe.usReId!, null, null, null);
      } else {
        APIsReCare.setNotificationRemind(
            state.reCares, null, event.usRe.usReId!, null, null, null);
        APIsReCare.setNotificationRemind(
            state.reCares, null, event.oldUsReId, null, null, null);
      }
    }
  }
}
