part of 'us_re_list_bloc.dart';

abstract class UsReListState {
  List<UserRelationship> usRes;
  UsReListState({required this.usRes});
}

class UsReListInitial extends UsReListState {
  UsReListInitial({required List<UserRelationship> usRes})
      : super(usRes: usRes);
}

class UsReListUploaded extends UsReListState {
  UsReListUploaded({required List<UserRelationship> usRes})
      : super(usRes: usRes);
}
