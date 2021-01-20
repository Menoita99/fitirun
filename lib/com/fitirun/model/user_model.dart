import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitirun/com/fitirun/model/statisticsModel.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';

class StepModel{
  DateTime time;
  int steps;

  StepModel({this.time, this.steps});

  StepModel.fromDoc(DocumentSnapshot doc){
    time = doc.data()['time'];
    steps = doc.data()['steps'];
  }

  StepModel.fromMap(DocumentSnapshot doc){
    time = doc['time'];
    steps = doc['steps'];
  }

  Map<String, dynamic> toJson() {
    return {
      'time' : time,
      'steps' : steps,
    };
  }

  @override
  bool operator == (Object other) {
    if(other is StepModel) {
      return this.time == other.time;
    }
    return false;
  }
}


class UserModel{
  String uid;
  String name;
  String email;
  String age;
  String weight;
  String height;
  List<TrainModel> favWorkouts = List();
  List<FoodModel> favFoods = List();
  List<StepModel> steps = List();
  List<StatisticsModel> statistics = List();

  UserModel({this.uid, this.email});

  UserModel.fromDoc(DocumentSnapshot doc){
    favFoods = List();
    uid = doc.data()['uid'];
    age = doc.data()['age'];
    email = doc.data()['email'];
    name = doc.data()['name'];
    weight = doc.data()['weight'];
    height = doc.data()['height'];
    var auxFoods = doc.data()['fav foods'] as List;
    if(auxFoods != null)
      auxFoods.forEach((e) => favFoods.add(FoodModel.fromMap(e)));

    var auxWorkouts = doc.data()['fav workouts'] as List;
    if(auxWorkouts != null)
      auxWorkouts.forEach((e) => favWorkouts.add(TrainModel.fromMap(e)));

    var auxStatistics = doc.data()['statistics'] as List;
    if(auxStatistics != null)
      auxStatistics.forEach((e) => statistics.add(StatisticsModel.fromMap(e)));

    var auxSteps = doc.data()['steps'] as List;
    if(auxSteps != null)
      auxSteps.forEach((e) => steps.add(StepModel.fromMap(e)));
  }

  UserModel.fromUser(User user){
    uid = user.uid;
    email = user.email;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> foodAux = List();
    List<Map<String, dynamic>> workoutAux = List();
    List<Map<String, dynamic>> statisticsAux = List();
    List<Map<String, dynamic>> stepsAux = List();

    favWorkouts.forEach((element) {
      if(element != null) {
        workoutAux.add(element.toJson());
      }
    });

    favFoods.forEach((element) {
      if(element != null){
        foodAux.add(element.toJson())
      ;}});

    statistics.forEach((element) {
      if(element != null) {
        statisticsAux.add(element.toJson());
      }
    });

    steps.forEach((element) {
      if(element != null) {
        stepsAux.add(element.toJson());
      }
    });

    return {
      'uid' : uid,
      'email' : email,
      'fav workouts' : workoutAux,
      'fav foods' : foodAux,
      'statistics' : statisticsAux,
      'name' : name,
      'age' : age,
      'steps' : steps,
      'height' : height,
      'weight' : weight
    };
  }

}
