part of 'us_re_list_bloc.dart';

@immutable
abstract class UsReListEvent {}

class LoadUsReList extends UsReListEvent {}

class AddUsRe extends UsReListEvent {
  final String meId;
  final String myReId;
  final List<Relationship> relationships;

  AddUsRe(
      {required this.meId, required this.myReId, required this.relationships});
}

class DeleteUsRe extends UsReListEvent {
  final String usReId;

  DeleteUsRe({required this.usReId});
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
