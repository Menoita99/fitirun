import 'package:fitirun/com/fitirun/model/runModel.dart';
import 'package:fitirun/com/fitirun/util/timer.dart';

class RunManager{

  CustomTimer totalTimer;
  CustomTimer exerciseTimer;
  RunModel model;
  int speed = 0;
  bool isActive = false;

  int exerciseIndex = 0;


  Function onExerciseDone;
  Function onExerciseStart;
  Function onExerciseTick;

  Function onTotalStart;
  Function onTotalDone;
  Function onTotalTick;


  void start(){
    if(model == null || model.exercises.isEmpty) throw("Workout null or workout exercises are empty");
    isActive = true;

    totalTimer = CustomTimer(startAt: 0,onFinish:onExerciseDone,onTick: onExerciseTick);
    exerciseTimer = CustomTimer(startAt: model.exercises[0].duration * 1000,stopAt: 0,onFinish:() => exerciseDone(),onTick: onExerciseTick);

    if(onTotalStart!=null)
      onTotalStart();
    totalTimer.start();

    if(onExerciseDone!=null)
      onExerciseDone();
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
}