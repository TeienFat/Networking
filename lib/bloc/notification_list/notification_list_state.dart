part of 'notification_list_bloc.dart';

abstract class NotificationListState {
  List<Notifications> notifications;
  NotificationListState({required this.notifications});
}

class NotificationListInitial extends NotificationListState {
  NotificationListInitial({required List<Notifications> notifications})
      : super(notifications: notifications);
}

class NotificationListUploaded extends NotificationListState {
  NotificationListUploaded({required List<Notifications> notifications})
      : super(notifications: notifications);
}
