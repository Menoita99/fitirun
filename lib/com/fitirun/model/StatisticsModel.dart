import 'package:faker/faker.dart';
import 'package:fitirun/com/fitirun/model/runModel.dart';

class StatisticsModel{

  List<RunData> data = new List();

  WorkoutData model;

  StatisticsModel(this.model);

  StatisticsModel.fakeModel(){
    model = WorkoutData.fakeModel();
    for(int i = 0; i < 10; i++){
      data.add(RunData.fakeModel());
    }
  }

  StatisticsModel.fromMap(Map doc){
    //data = (doc['data'] as List<dynamic>).map((e) => RunData.fromMap(e)).toList();
  }

  void add(RunData rdata){
    if(data == null)
      data = List();
    data.add(rdata);
  }

  StatisticsModel clone() {
    StatisticsModel clone = StatisticsModel(model);
    clone.data.addAll(data);
    return clone;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> dataAux = List();
    data.forEach((element) {
      print(element);
      dataAux.add(element.toJson());});
    return {
      'model': model == null ? [] :  model.toJson(),
      'data' : dataAux,
    };
  }

}

class RunData {

   DateTime time;
   int steps;
   double distance;
   double  speed;
   double calories;

  RunData({this.time , this.steps, this.distance, this.speed, this.calories});
  RunData.fakeModel(){
    RunData(calories: Faker().randomGenerator.decimal() * 100,
    distance: Faker().randomGenerator.decimal() * 1000,
    speed: Faker().randomGenerator.decimal() * 50,
    steps: Faker().randomGenerator.integer(5) + 3,
    time: DateTime.now());

  }

  @override
  String toString() {
    return "time:"+time.toString()+" steps:"+steps.toString()+" distance:"+distance.toString()+" speed:"+speed.toString()+" calories:"+calories.toString();
  }


  Map<String, dynamic> toJson() {
    return {
      'time' : time.toString(),
      'steps' : steps.toString(),
      'distance' : distance.toString(),
      'speed' : speed.toString(),
      'calories' : calories.toString()
    };
  }

}

class WorkoutData{

  RunModel model;
  DateTime time;

  WorkoutData(this.time , this.model);

  WorkoutData.fakeModel(){
    time = DateTime.now();
    model = RunModel.fakeModel();
  }

  Map<String, dynamic> toJson() {

    return {
      'run model' : model.toJson(),
      'time' : time.toString()
    };
  }

}