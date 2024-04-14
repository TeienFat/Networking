part of 're_care_list_bloc.dart';

abstract class ReCareListState {
  List<RelationshipCare> reCares;
  ReCareListState({required this.reCares});
}

class ReCareListInitial extends ReCareListState {
  ReCareListInitial({required List<RelationshipCare> reCares})
      : super(reCares: reCares);
}

class ReCareListUploaded extends ReCareListState {
  ReCareListUploaded({required List<RelationshipCare> reCares})
      : super(reCares: reCares);
}
