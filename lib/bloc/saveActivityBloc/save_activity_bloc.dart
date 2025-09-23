import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coherent_endurance/models/saveActivityModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../repository/api.dart';

part 'save_activity_event.dart';
part 'save_activity_state.dart';

class SaveActivityBloc extends Bloc<SaveActivityEvent, SaveActivityState> {
  SaveActivityBloc() : super(SaveActivityInitial()) {
    on<SaveActivityPressed>(_saveActivity);
  }
  Future<void> _saveActivity(
      SaveActivityPressed event, Emitter<SaveActivityState> emit) async {
    emit(SaveActivityLoading());
    try {
      final response = await Api.saveActivityApi({
        "category_id": event.categoryId,
        "title": event.title,
        "description": event.description,
        "distance": event.trackingData["distance"],
        "pace": event.trackingData["avgPace"],
        "moving_time": event.trackingData["time"],
        "city": "Demo City",
        "state": "Demo State",
        "country": "Demo Country",
        "address": "Demo Address",
        "elavation_gain": event.trackingData["elevationGain"],
        "max_elavation": event.trackingData["maxElevation"],
        "steps": event.trackingData["steps"],
        "fastest_split": event.trackingData["fastestSplit"],
        "path": event.trackingData["path"],
        "run_type": event.runType,
        "type_of_run": event.typeOfRun,
        "feeling": event.feeling,
        "private_note": event.privateNote,
        "gear": event.gear,
        "visibility": event.visibility,
        "hidden_details": event.hiddenDetails,
        "mute_activity": event.isPublish,
        "type": "activity",
        "avg_elapsed_pace": event.trackingData["avgPace"],
        "elapsed_time": event.trackingData["time"],
        "max_speed": event.trackingData["maxSpeed"] ?? 0,
        "mapImage": event.trackingData["mapImage"],
      }, event.context);

      final result = SaveActivityModel.fromJson(response);

      if (result.statusCode == 200) {
        emit(SaveActivitySuccess(result));
      } else {
        emit(SaveActivityError(result.message.toString()));
      }
    } catch (e) {
      emit(SaveActivityError(e.toString()));
    }
  }
  // Future<void> _saveActivity(SaveActivityEvent event, Emitter<SaveActivityState> emit) async {
  //   emit(SaveActivityLoading());
  //
  //   try{
  //
  //     var body = {
  //       'user_id': event.userId,
  //     };
  //     final headers = {
  //       'Content-Type': 'application/json'
  //     };
  //     final response = await Api.saveActivityApi({
  //       "category_id": categoryId,
  //       "title": titleController.text,
  //       "description": descriptionController.text,
  //       "distance": widget.trackingData["distance"],
  //       "pace": widget.trackingData["avgPace"],
  //       "moving_time": widget.trackingData["time"],
  //       "city": "Demo City",
  //       "state": "Demo State",
  //       "country": "Demo Country",
  //       "address": "Demo Address",
  //       "elavation_gain": widget.trackingData["elevationGain"],
  //       "max_elavation": widget.trackingData["maxElevation"],
  //       "steps": widget.trackingData["steps"],
  //       "fastest_split": widget.trackingData["fastestSplit"],
  //       "path": widget.trackingData["path"],
  //       "run_type": selectedRunType,
  //       "type_of_run": selectedTypeOfRun,
  //       "feeling": selectedFeeling,
  //       "private_note": privateNoteController.text,
  //       "gear": selectedGear,
  //       "visibility": selectedVisibility,
  //       "hidden_details": selectedHiddenDetails,
  //       "mute_activity": isPublish,
  //       "type": "activity",
  //       "avg_elapsed_pace": widget.trackingData["avgPace"],
  //       "elapsed_time": widget.trackingData["time"],
  //       "max_speed": widget.trackingData["maxSpeed"] ?? 0,
  //       "mapImage": widget.trackingData["mapImage"],
  //     }, context);
  //     final result = SaveActivityModel.fromJson(response);
  //     if (kDebugMode) {
  //       print('_getProfile:::$result');
  //     }
  //     if(result.statusCode == 200){
  //       emit(SaveActivitySuccess(result));
  //     }else{
  //       emit(SaveActivityError(result.message.toString()));
  //     }
  //   }on SocketException{
  //     emit(SaveActivityError('Please check your internet connection'));
  //   }catch(e, stacktrace){
  //     if (kDebugMode) {
  //       print(stacktrace);
  //     }
  //     emit(SaveActivityError(e.toString()));
  //   }
  // }
}
