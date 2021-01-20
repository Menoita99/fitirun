import 'dart:async';

import 'package:fitirun/com/fitirun/model/armazem.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/util/services/database.dart';
import 'package:pedometer/pedometer.dart';

class PedometerUtil{

  int steps = 0;

  Map<dynamic,Function(StepCount event)> onStepCountListeners = new Map();
  Map<dynamic,Function(PedestrianStatus event)> onPedestrianStatusChangedListeners = new Map();
  Map<dynamic,Function(dynamic error)> onPedestrianStatusErrorListeners = new Map();
  Map<dynamic,Function(dynamic error)>  onStepCountErrorListeners = new Map();

  bool isAvailable = true;

  PedometerUtil(){
    initPlatformState();
    _registerGlobalStepCountListeners();
  }

  void initPlatformState() {
    Pedometer.pedestrianStatusStream.listen(_handlePedestrianStatusChanged) .onError(_handlePedestrianStatusError);
    Pedometer.stepCountStream.listen(_handleStepCount).onError(_handleStepCountError);
  }

  void _handleStepCount(StepCount event) {
    print("$event");
    steps = event.steps;
    for(Function(StepCount event1) func in onStepCountListeners.values){
      if(func!=null)
        func(event);
    }
  }

  void _handlePedestrianStatusChanged(PedestrianStatus event) {
    print("$event");
    for(Function(PedestrianStatus event1) func in onPedestrianStatusChangedListeners.values){
      if(func!=null)
        func(event);
    }
  }

  void _handlePedestrianStatusError(error) {
    print("$error");
    for(Function(dynamic event1) func in onPedestrianStatusErrorListeners.values){
      if(func!=null)
        func(error);
    }
  }

  void _handleStepCountError(error) {
    print("StepCounterNot available$error");
    isAvailable = false;
    print(error);
    for(Function(dynamic event1) func in onStepCountErrorListeners.values){
      if(func!=null)
        func(error);
    }
  }

  void _registerGlobalStepCountListeners() {
    onStepCountListeners[this] = ((step){
      DateTime t = DateTime.utc(step.timeStamp.year,step.timeStamp.month,step.timeStamp.day);
      StepModel st = StepModel(time: t,steps: step.steps);
      if(Warehouse().userModel.steps.contains(st))
        Warehouse().userModel.steps.remove(st);
      Warehouse().userModel.steps.add(st);
      DatabaseService().addOrUpdateUser(Warehouse().userModel);
    });
  }
}