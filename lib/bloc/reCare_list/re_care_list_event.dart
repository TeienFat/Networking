part of 're_care_list_bloc.dart';

@immutable
abstract class ReCareListEvent {}

class LoadReCareList extends ReCareListEvent {}

class AddReCare extends ReCareListEvent {
  // final String meId;
  // final String myReId;
  // final List<Relationship> relationships;

  // AddReCare(
  //     {required this.meId, required this.myReId, required this.relationships});
}

class DeleteReCare extends ReCareListEvent {
  // final String usReId;

  // DeleteReCare({required this.usReId});
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
