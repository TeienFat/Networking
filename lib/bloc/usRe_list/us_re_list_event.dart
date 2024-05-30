part of 'us_re_list_bloc.dart';

@immutable
abstract class UsReListEvent {}

class LoadUsReList extends UsReListEvent {}

class AddUsRe extends UsReListEvent {
  final String meId;
  final String myReId;
  final String userName;
  final String imageUrl;
  final DateTime? birthday;
  final List<Relationship> relationships;

  AddUsRe(
      {required this.meId,
      required this.myReId,
      required this.userName,
      required this.imageUrl,
      required this.birthday,
      required this.relationships});
}

class DeleteUsRe extends UsReListEvent {
  final String usReId;

  DeleteUsRe({required this.usReId});
}

class RemoveUsRe extends UsReListEvent {
  final String usReId;
  final DateTime? deleteAt;
  RemoveUsRe({required this.usReId, required this.deleteAt});
}

class UpdateTimeOfCareUsRe extends UsReListEvent {
  final String usReId;
  final int timeOfCare;

  UpdateTimeOfCareUsRe({required this.usReId, required this.timeOfCare});
}

class UpdateRemidNotification extends UsReListEvent {
  final String usReId;
  final bool value;

  UpdateRemidNotification({required this.usReId, required this.value});
}

class UpdateHowLongRemid extends UsReListEvent {
  final String usReId;
  final int long;

  UpdateHowLongRemid({required this.usReId, required this.long});
}

class UpdateScheduleNotification extends UsReListEvent {
  final UserRelationship usRe;
  final bool value;

  UpdateScheduleNotification({required this.usRe, required this.value});
}

class UpdateBirthdayNotification extends UsReListEvent {
  final String usReId;
  final bool value;

  UpdateBirthdayNotification({required this.usReId, required this.value});
}

class UpdateUsRe extends UsReListEvent {
  final String usReId;
  final bool special;
  final List<Relationship> relationships;

  UpdateUsRe(
      {required this.usReId,
      required this.special,
      required this.relationships});
}
