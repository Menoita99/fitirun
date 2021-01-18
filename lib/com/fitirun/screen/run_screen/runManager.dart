import 'package:fitirun/com/fitirun/model/StatisticsModel.dart';
import 'package:fitirun/com/fitirun/model/runModel.dart';
import 'package:fitirun/com/fitirun/util/timer.dart';
import 'package:location/location.dart';

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


  void start(){
    //TODO statistics
    if(model == null || model.exercises.isEmpty) throw("Workout null or workout exercises are empty");
    isActive = true;

    totalTimer = CustomTimer(startAt: 0,onFinish:onTotalDone,onTick: onTotalTick);
    exerciseTimer = CustomTimer(startAt: model.exercises[0].duration * 1000, stopAt: 0,onFinish:() => exerciseDone(),onTick: onExerciseTick);

    if(onTotalStart!=null)
      onTotalStart();
    totalTimer.start();

    if(onExerciseStart!=null)
      onExerciseStart();
    exerciseTimer.start();
  }

  bool hasModel(){
    return model!= null;
}

  void stop(){
    if(exerciseTimer != null)
      exerciseTimer.stop();

    if(totalTimer != null)
      totalTimer.stop();
  }


  void restart(){
    stop();
    totalTimer = null;
    exerciseTimer = null;
    model = null;
    isActive = false;
    exerciseIndex = 0;
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


  int totalSteps(){
    return 0;
  }

  int totalDistance(){
    return 0;
  }

  int totalCalories(){
    return 0;
  }

  void updateStats(LocationData position){

  }

  void saveStats(){

  }
}