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

class UpdateReCare extends ReCareListEvent {
  // final String usReId;
  // final bool special;
  // final List<Relationship> relationships;

  // UpdateReCare(
  //     {required this.usReId,
  //     required this.special,
  //     required this.relationships});
}
