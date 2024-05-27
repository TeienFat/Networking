part of 'notification_list_bloc.dart';

@immutable
abstract class NotificationListEvent {}

class LoadNotificationList extends NotificationListEvent {}

class AddNotification extends NotificationListEvent {
  final String notiId;
  final String userId;
  final String title;
  final String body;
  final String contentBody;
  final String usReImage;
  final String payload;
  final DateTime period;
  AddNotification({
    required this.notiId,
    required this.userId,
    required this.title,
    required this.body,
    required this.contentBody,
    required this.usReImage,
    required this.payload,
    required this.period,
  });
}

class UpdateNotiStatus extends NotificationListEvent {
  final String notiId;
  final int status;

  UpdateNotiStatus({
    required this.notiId,
    required this.status,
  });
}

class DeleteNotification extends NotificationListEvent {
  final String notiId;

  DeleteNotification({
    required this.notiId,
  });
}
