import 'package:fitirun/com/fitirun/model/StatisticsModel.dart';
import 'package:fitirun/com/fitirun/model/runModel.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/util/PedometerUtil.dart';
import 'package:fitirun/com/fitirun/util/timer.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'dart:math';

import 'package:pedometer/pedometer.dart';

class RunManager{

  CustomTimer totalTimer;
  CustomTimer exerciseTimer;
  RunModel model;
  int speed = 0;
  bool isActive = false;

  int exerciseIndex = 0;

  StatisticsModel statistics;

  Function onExerciseDone;
  Function onExerciseStart;
  Function onExerciseTick;

  Function onTotalStart;
  Function onTotalDone;
  Function onTotalTick;

  PedometerUtil pedometer = GetIt.I<PedometerUtil>();

  LocationData _lastPosition;

  int totalSteps = 0;
  int _lastFetchTotalSteps = 0;
  int initSteps = 0;

  int totalDistance = 0;
  double totalCalories = 0;

  static double weight = 55.0; // kg
  static double height = 160.0; // cm

  WorkoutData workOutKey;

  void start(){

    if(model == null || model.exercises.isEmpty) throw("Workout null or workout exercises are empty");
    isActive = true;

    workOutKey = WorkoutData(DateTime.now(),model);
    statistics = new StatisticsModel(workOutKey);

    totalTimer = CustomTimer(startAt: 0,onFinish:onTotalDone,onTick: onTotalTick);
    exerciseTimer = CustomTimer(startAt: model.exercises[0].duration * 1000, stopAt: 0,onFinish:() => exerciseDone(),onTick: onExerciseTick);

    if(onTotalStart!=null)
      onTotalStart();
    totalTimer.start();

    if(onExerciseStart!=null)
      onExerciseStart();
    exerciseTimer.start();

    totalSteps = 0;
    initSteps = pedometer.steps;
    pedometer.onStepCountListeners[this] = ((StepCount event) => {
      if(isActive)
        totalSteps += event.steps - initSteps - totalSteps
    });
  }

  bool hasModel(){
    return model!= null;
}

  void stop(){
    print("Called stop");
    if(exerciseTimer != null)
      exerciseTimer.stop();

    if(totalTimer != null)
      totalTimer.stop();

    pedometer.onStepCountListeners.remove(this);
  }


  void restart(){
    stop();
    totalTimer = null;
    exerciseTimer = null;
    model = null;
    isActive = false;
    exerciseIndex = 0;
    totalSteps = 0;
    initSteps = 0;
    _lastFetchTotalSteps = 0;
    totalDistance = 0;
    totalCalories = 0;
    workOutKey = null;
  }


  void exerciseDone(){
    if(onExerciseDone!=null)
      onExerciseDone(exerciseIndex);

    exerciseIndex++;
    if(exerciseIndex < model.exercises.length) {
      exerciseTimer = CustomTimer(
          startAt: model.exercises[exerciseIndex].duration * 1000,
          stopAt: 0,
          onFinish: () => exerciseDone(),
          onTick: onExerciseTick);
      exerciseTimer.start();
    }else{
      totalTimer.stop();
    }
  }

  bool isWorkoutFinish(){
    return exerciseIndex >= model.exercises.length;
  }

  double completePercentage(){
    return (totalTimer.currentTick/1000) / model.totalDuration;
  }

  String timeLeft() {
    int  time = model.totalDuration - (totalTimer.currentTick~/1000).toInt();
    String mins = (time~/60).toInt() < 10 ? '0'+(time~/60).toInt().toString() : (time~/60).toInt().toString();
    String second = (time%60).toInt() < 10 ? '0'+(time%60).toString() : (time%60).toString();
    return "$mins:$second";
  }

  int getExerciseIndex(ExerciseRunModel e) {
    for(int i = 0; i<model.exercises.length;i++ ){
      if(e == model.exercises[i])
        return i;
    }
    return -1;
  }


  void updateStats(LocationData position){
    if(_lastPosition!= null && isActive){
      double distance =  calculateDistance(_lastPosition,position);
      double calories = calculateCalories(position.speed);
      RunData data = RunData(
        calories: calories,
        distance: distance,
        speed: distance == 0 ? 0 : position.speed * 3.6, //m/s => km/h
        steps: totalSteps - _lastFetchTotalSteps,
        time: DateTime.now(),
      );
      totalDistance += distance.toInt();
      totalCalories += calories;
      statistics.add(data);
      print(data);
    }
    _lastFetchTotalSteps = totalSteps;
    _lastPosition = position;
  }

  void saveStats(){
      statistics.clone();
  }

  calculateDistance(LocationData lastPosition, LocationData position) {
    LatLng coord1 = LatLng(lastPosition.latitude,lastPosition.longitude);
    LatLng coord2 = LatLng(position.latitude,position.longitude);
    return Distance().as(LengthUnit.Meter,coord1,coord2).abs();
  }

  double calculateCalories(double speed) {
   // return ((0.26*speed+1.6) * weight * height) /1000 / 60;
    return 0.0005 * weight * speed + 0.0035;
  }

  List<double> getDistanceData() {
    List<double> output = List();
    double sum = 0;
    output.add(0);
    if(statistics != null && statistics.data != null) {
      for (RunData d in statistics.data) {
        sum += d.distance;
        output.add(sum);
      }
    }
    return output;
  }


  List<double> getCaloriesData() {
    List<double> output = List();
    double sum = 0;
    output.add(0);
    if(statistics != null && statistics.data != null) {
      for (RunData d in statistics.data) {
        sum += d.calories;
        output.add(sum);
      }
    }
    return output;
  }


  List<double> getSpeedData() {
    List<double> output = List();
    if(statistics != null && statistics.data != null)
      for (RunData d in statistics.data)
        output.add(d.speed);
    return output;
  }
}