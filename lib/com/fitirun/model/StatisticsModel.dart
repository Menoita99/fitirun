import 'package:fitirun/com/fitirun/model/workoutModel.dart';

class StatisticsModel{

  Map<WorkoutData,RunData> data = new Map();

  WorkoutData model;//ignore this attribute when putting in firebase

  StatisticsModel(this.model);

  void add(RunData rdata){
    data[model] = rdata;
  }

}

class RunData {

  final DateTime time;
  final int steps;
  final int distance;
  final int speed;
  final int calories;

  const RunData({this.time , this.steps, this.distance, this.speed, this.calories});
}

class WorkoutData{

  final WorkoutModel model;
  final DateTime time;

  const WorkoutData({this.time , this.model});
}