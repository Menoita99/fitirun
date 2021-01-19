import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitirun/com/fitirun/model/StatisticsModel.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';

class UserModel{
  String uid;
  String name;
  String email;
  int age;
  List<TrainModel> favWorkouts = List();
  List<FoodModel> favFoods = List();
  Map<DateTime, int> steps = Map();
  List<StatisticsModel> statistics = List();

  UserModel({this.uid, this.email});

  UserModel.fromDoc(DocumentSnapshot doc){
    favFoods = List();
    uid = doc.data()['uid'];
    age = doc.data()['age'];
    email = doc.data()['email'];
    name = doc.data()['name'];
    var auxFoods = doc.data()['fav foods'] as List;
    auxFoods.forEach((e) => favFoods.add(FoodModel.fromMap(e)));
    var auxWorkouts = doc.data()['fav workouts'] as List;
    auxWorkouts.forEach((e) => favWorkouts.add(TrainModel.fromMap(e)));
    var auxStatistics = doc.data()['statistics'] as List;
    auxStatistics.forEach((e) => statistics.add(StatisticsModel.fromMap(e)));
  }

  UserModel.fromUser(User user){
    uid = user.uid;
    email = user.email;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> foodAux = List();
    List<Map<String, dynamic>> workoutAux = List();
    List<Map<String, dynamic>> statisticsAux = List();
    favWorkouts.forEach((element) {
      if(element != null) {
        workoutAux.add(element.toJson());
      }
    });
    favFoods.forEach((element) {
      if(element != null){
        foodAux.add(element.toJson())
      ;}});
    statistics.forEach((element) {statisticsAux.add(element.toJson());});

    return {
      'uid' : uid,
      'email' : email,
      'fav workouts' : workoutAux,
      'fav foods' : foodAux,
      'statistics' : statisticsAux,
      'name' : name,
      'age' : age,
    };
  }

}