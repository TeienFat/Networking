import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:networking/apis/apis_user_relationship.dart';
import 'package:networking/models/relationship_model.dart';
import 'package:networking/models/user_relationship_model.dart';
import 'package:uuid/uuid.dart';

part 'us_re_list_event.dart';
part 'us_re_list_state.dart';

var uuid = Uuid();

class UsReListBloc extends Bloc<UsReListEvent, UsReListState> {
  UsReListBloc() : super(UsReListInitial(usRes: [])) {
    on<LoadUsReList>(
      (event, emit) async {
        emit(UsReListUploaded(usRes: await APIsUsRe.getAllMyRelationship()));
      },
    );
    on<AddUsRe>(_addUsRe);
    on<DeleteUsRe>(_deleteUsRe);
    on<UpdateUsRe>(_updateUsRe);
  }
  void _addUsRe(AddUsRe event, Emitter<UsReListState> emit) {
    final newUsRe = UserRelationship(
        usReId: uuid.v4(),
        meId: event.meId,
        myRelationShipId: event.myReId,
        special: false,
        relationships: event.relationships,
        notification: [],
        time_of_care: 0,
        createdAt: DateTime.now(),
        updateAt: null,
        deleteAt: null);
    state.usRes.add(newUsRe);
    APIsUsRe.createNewUsRe(event.meId, event.myReId, event.relationships);
    emit(UsReListUploaded(usRes: state.usRes));
  }

  void _deleteUsRe(DeleteUsRe event, Emitter<UsReListState> emit) {
    for (int i = 0; i < state.usRes.length; i++) {
      if (event.usReId == state.usRes[i].usReId) {
        state.usRes.remove(state.usRes[i]);
        break;
      }
    }
    APIsUsRe.removeUsRe(event.usReId);
    emit(UsReListUploaded(usRes: state.usRes));
  }

  void _updateUsRe(UpdateUsRe event, Emitter<UsReListState> emit) {
    for (int i = 0; i < state.usRes.length; i++) {
      if (event.usReId == state.usRes[i].usReId) {
        state.usRes[i].relationships = event.relationships;
        state.usRes[i].special = event.special;
      }
    }
    APIsUsRe.updateUsRe(event.usReId, event.special, event.relationships);
    emit(UsReListUploaded(usRes: state.usRes));
  }
}
