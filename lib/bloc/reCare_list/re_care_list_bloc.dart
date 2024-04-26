import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:networking/apis/apis_ReCare.dart';
import 'package:networking/models/relationship_care_model.dart';
import 'package:uuid/uuid.dart';

part 're_care_list_event.dart';
part 're_care_list_state.dart';

var uuid = Uuid();

class ReCareListBloc extends Bloc<ReCareListEvent, ReCareListState> {
  ReCareListBloc() : super(ReCareListInitial(reCares: [])) {
    on<LoadReCareList>(
      (event, emit) async {
        emit(ReCareListUploaded(
            reCares: await APIsReCare.getAllMyRelationshipCare()));
      },
    );
    on<AddReCare>(_addReCare);
    on<AddContentText>(_addContentText);
    on<AddContentImage>(_addContentImage);
    on<RemoveContentImage>(_deleteContentImage);
    on<DeleteReCare>(_deleteReCare);
    on<UpdateIsFinish>(_updateIsFinish);
    on<UpdateReCare>(_updateReCare);
  }
  void _addReCare(AddReCare event, Emitter<ReCareListState> emit) {
    final reCareId = uuid.v4();
    final newReCare = RelationshipCare(
        reCareId: reCareId,
        meId: event.meId,
        usReId: event.usReId,
        startTime: event.startTime,
        endTime: event.endTime,
        title: event.title,
        contentText: '',
        contentImage: [],
        isFinish: 2,
        createdAt: DateTime.now(),
        updateAt: null,
        deleteAt: null);
    state.reCares.add(newReCare);
    APIsReCare.createNewReCare(newReCare);
    emit(ReCareListUploaded(reCares: state.reCares));
  }

  void _addContentText(AddContentText event, Emitter<ReCareListState> emit) {
    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares[i].contentText = event.contentText;
      }
    }

    APIsReCare.addContentText(event.reCareId, event.contentText);
    emit(ReCareListUploaded(reCares: state.reCares));
  }

  void _addContentImage(AddContentImage event, Emitter<ReCareListState> emit) {
    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares[i].contentImage!.add(event.imageUrl);
      }
    }

    APIsReCare.addContentImage(event.reCareId, event.imageUrl);
    emit(ReCareListUploaded(reCares: state.reCares));
  }

  void _deleteContentImage(
      RemoveContentImage event, Emitter<ReCareListState> emit) {
    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares[i].contentImage!.remove(event.imageUrl);
      }
    }

    APIsReCare.removeContentImage(event.reCareId, event.imageUrl);
    emit(ReCareListUploaded(reCares: state.reCares));
  }

  void _deleteReCare(DeleteReCare event, Emitter<ReCareListState> emit) {
    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares.remove(state.reCares[i]);
        break;
      }
    }
    APIsReCare.removeReCare(event.reCareId);
    emit(ReCareListUploaded(reCares: state.reCares));
  }

  void _updateIsFinish(UpdateIsFinish event, Emitter<ReCareListState> emit) {
    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares[i].isFinish = event.isFinish;
      }
    }
    APIsReCare.updateIsFinish(event.reCareId, event.isFinish);
    emit(ReCareListUploaded(reCares: state.reCares));
  }

  void _updateReCare(UpdateReCare event, Emitter<ReCareListState> emit) {
    for (int i = 0; i < state.reCares.length; i++) {
      if (event.reCareId == state.reCares[i].reCareId) {
        state.reCares[i].usReId = event.usReId;
        state.reCares[i].title = event.title;
        state.reCares[i].startTime = event.startTime;
        state.reCares[i].endTime = event.endTime;
      }
    }
    APIsReCare.updateReCare(event.reCareId, event.title, event.usReId,
        event.startTime, event.endTime);
    emit(ReCareListUploaded(reCares: state.reCares));
  }
}
