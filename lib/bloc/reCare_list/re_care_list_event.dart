part of 're_care_list_bloc.dart';

@immutable
abstract class ReCareListEvent {}

class LoadReCareList extends ReCareListEvent {}

class AddReCare extends ReCareListEvent {
  final String meId;
  final UserRelationship usRe;
  final Users users;
  final DateTime startTime;
  final DateTime endTime;
  final String title;

  AddReCare(
      {required this.meId,
      required this.usRe,
      required this.users,
      required this.startTime,
      required this.endTime,
      required this.title});
}

class DeleteReCare extends ReCareListEvent {
  final String reCareId;
  final UserRelationship usRe;

  DeleteReCare({required this.reCareId, required this.usRe});
}

class AddContentText extends ReCareListEvent {
  final String reCareId;

  final String contentText;

  AddContentText({required this.reCareId, required this.contentText});
}

class AddContentImage extends ReCareListEvent {
  final String reCareId;

  final String imageUrl;

  AddContentImage({required this.reCareId, required this.imageUrl});
}

class RemoveContentImage extends ReCareListEvent {
  final String reCareId;

  final String imageUrl;

  RemoveContentImage({required this.reCareId, required this.imageUrl});
}

class UpdateIsFinish extends ReCareListEvent {
  final String reCareId;
  final int isFinish;
  UpdateIsFinish({required this.reCareId, required this.isFinish});
}

class UpdateReCare extends ReCareListEvent {
  final String reCareId;
  final UserRelationship usRe;
  final String oldUsReId;
  final Users users;
  final DateTime startTime;
  final DateTime endTime;
  final String title;

  UpdateReCare({
    required this.reCareId,
    required this.usRe,
    required this.oldUsReId,
    required this.users,
    required this.startTime,
    required this.endTime,
    required this.title,
  });
}
