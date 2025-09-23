part of 'save_activity_bloc.dart';

@immutable
sealed class SaveActivityEvent {}
class SaveActivityPressed extends SaveActivityEvent {
  final BuildContext context;
  final Map<String, dynamic> trackingData;
  final String categoryId;
  final String title;
  final String description;
  final String runType;
  final String typeOfRun;
  final String feeling;
  final String privateNote;
  final String gear;
  final String visibility;
  final String hiddenDetails;
  final bool isPublish;

  SaveActivityPressed({
    required this.context,
    required this.trackingData,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.runType,
    required this.typeOfRun,
    required this.feeling,
    required this.privateNote,
    required this.gear,
    required this.visibility,
    required this.hiddenDetails,
    required this.isPublish,
  });
}