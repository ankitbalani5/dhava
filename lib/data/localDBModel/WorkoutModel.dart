import 'package:hive/hive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'WorkoutModel.g.dart'; // ✅ Correct

@HiveType(typeId: 0)
class WorkoutModel extends HiveObject {
  @HiveField(0)
  List<LatLng> path;

  @HiveField(1)
  double totalDistance;

  @HiveField(2)
  double averageSpeed;

  @HiveField(3)
  DateTime startTime;

  @HiveField(4)
  DateTime endTime;

  WorkoutModel({
    required this.path,
    required this.totalDistance,
    required this.averageSpeed,
    required this.startTime,
    required this.endTime,
  });
}
