import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'save_activity_event.dart';
part 'save_activity_state.dart';

class SaveActivityBloc extends Bloc<SaveActivityEvent, SaveActivityState> {
  SaveActivityBloc() : super(SaveActivityInitial()) {
    on<SaveActivityEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
