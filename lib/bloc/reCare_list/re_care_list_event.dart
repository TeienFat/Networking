part of 're_care_list_bloc.dart';

@immutable
abstract class ReCareListEvent {}

class LoadReCareList extends ReCareListEvent {}

class AddReCare extends ReCareListEvent {
  final String meId;
  final String usReId;
  final DateTime startTime;
  final DateTime endTime;
  final String title;

  AddReCare(
      {required this.meId,
      required this.usReId,
      required this.startTime,
      required this.endTime,
      required this.title});
}

class DeleteReCare extends ReCareListEvent {
  final String reCareId;

  DeleteReCare({required this.reCareId});
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
  final String usReId;
  final DateTime startTime;
  final DateTime endTime;
  final String title;

  UpdateReCare(
      {required this.reCareId,
      required this.usReId,
      required this.startTime,
      required this.endTime,
      required this.title});
}
