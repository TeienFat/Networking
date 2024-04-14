import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/models/relationship_care_model.dart';

part 're_care_list_event.dart';
part 're_care_list_state.dart';

class ReCareListBloc extends Bloc<ReCareListEvent, ReCareListState> {
  ReCareListBloc() : super(ReCareListInitial(reCares: [])) {
    on<LoadReCareList>(
      (event, emit) async {
        emit(ReCareListUploaded(
            reCares: await APIsReCare.getAllMyRelationshipCare()));
      },
    );
    // on<AddUsRe>(_addUsRe);
    // on<DeleteUsRe>(_deleteUsRe);
    // on<UpdateUsRe>(_updateUsRe);
  }
  // void _addUsRe(AddUsRe event, Emitter<UsReListState> emit) {
  //   final userId = uuid.v4();
  //   final newUsRe = UserRelationship(
  //       usReId: userId,
  //       meId: event.meId,
  //       myRelationShipId: event.myReId,
  //       special: false,
  //       relationships: event.relationships,
  //       notification: [],
  //       time_of_care: 0,
  //       createdAt: DateTime.now(),
  //       updateAt: null,
  //       deleteAt: null);
  //   state.usRes.add(newUsRe);
  //   APIsUsRe.createNewUsRe(
  //       userId, event.meId, event.myReId, event.relationships);
  //   emit(UsReListUploaded(usRes: state.usRes));
  // }

  // void _deleteUsRe(DeleteUsRe event, Emitter<UsReListState> emit) {
  //   for (int i = 0; i < state.usRes.length; i++) {
  //     if (event.usReId == state.usRes[i].usReId) {
  //       state.usRes.remove(state.usRes[i]);
  //       break;
  //     }
  //   }
  //   APIsUsRe.removeUsRe(event.usReId);
  //   emit(UsReListUploaded(usRes: state.usRes));
  // }

  // void _updateUsRe(UpdateUsRe event, Emitter<UsReListState> emit) {
  //   for (int i = 0; i < state.usRes.length; i++) {
  //     if (event.usReId == state.usRes[i].usReId) {
  //       state.usRes[i].relationships = event.relationships;
  //       state.usRes[i].special = event.special;
  //     }
  //   }
  //   APIsUsRe.updateUsRe(event.usReId, event.special, event.relationships);
  //   emit(UsReListUploaded(usRes: state.usRes));
  // }
}
