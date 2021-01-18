import 'package:fitirun/com/fitirun/model/runModel.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';

class StatisticsModel{

  Map<WorkoutData,List<RunData>> data = new Map();

  WorkoutData model;//ignore this attribute when putting in firebase

  StatisticsModel(this.model);

  void add(RunData rdata){
    if(data[model] == null)
      data[model] = List();
    data[model].add(rdata);
  }

  StatisticsModel clone() {
    StatisticsModel clone = StatisticsModel(model);
    clone.data.addAll(data);
    return clone;
  }

}

class RunData {

  final DateTime time;
  final int steps;
  final double distance;
  final double  speed;
  final double calories;

  const RunData({this.time , this.steps, this.distance, this.speed, this.calories});

  @override
  String toString() {
    return "time:"+time.toString()+" steps:"+steps.toString()+" distance:"+distance.toString()+" speed:"+speed.toString()+" calories:"+calories.toString();
  }
}

class WorkoutData{

  final RunModel model;
  final DateTime time;

  const WorkoutData(this.time , this.model);
}