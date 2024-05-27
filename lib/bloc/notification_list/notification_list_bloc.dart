import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:networking/apis/apis_notification.dart';
import 'package:networking/models/notification_model.dart';

part 'notification_list_event.dart';
part 'notification_list_state.dart';

class NotificationListBloc
    extends Bloc<NotificationListEvent, NotificationListState> {
  NotificationListBloc() : super(NotificationListInitial(notifications: [])) {
    on<LoadNotificationList>((event, emit) async {
      emit(NotificationListUploaded(
          notifications: await APIsNotification.getAllMyNotification()));
    });
    on<AddNotification>(_addNotification);
    on<UpdateNotiStatus>(_updateStatus);
    on<DeleteNotification>(_deleteNotification);
  }

  void _addNotification(
      AddNotification event, Emitter<NotificationListState> emit) async {
    final newNoti = Notifications(
        notiId: event.notiId,
        userId: event.userId,
        title: event.title,
        body: event.body,
        contentBody: event.contentBody,
        usReImage: event.usReImage,
        payload: event.payload,
        status: -1,
        period: event.period);
    state.notifications.add(newNoti);
    APIsNotification.createNewNotification(newNoti);
    emit(NotificationListUploaded(notifications: state.notifications));
  }

  void _updateStatus(
      UpdateNotiStatus event, Emitter<NotificationListState> emit) {
    for (int i = 0; i < state.notifications.length; i++) {
      if (event.notiId == state.notifications[i].notiId) {
        state.notifications[i].status = event.status;
      }
    }
    APIsNotification.updateStatus(event.notiId, event.status);
    emit(NotificationListUploaded(notifications: state.notifications));
  }

  void _deleteNotification(
      DeleteNotification event, Emitter<NotificationListState> emit) {
    for (int i = 0; i < state.notifications.length; i++) {
      if (event.notiId == state.notifications[i].notiId) {
        state.notifications.remove(state.notifications[i]);
        break;
      }
    }
    APIsNotification.removeNotification(event.notiId);
    emit(NotificationListUploaded(notifications: state.notifications));
  }
}
