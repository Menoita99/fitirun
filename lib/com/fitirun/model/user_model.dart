import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  UserModel({this.uid, this.email});

  UserModel.fromDoc(DocumentSnapshot doc){
    uid = doc.data()['uid'];
    age = doc.data()['age'];
    email = doc.data()['email'];
    name = doc.data()['name'];
    var auxFoods = doc.data()['fav foods'] as List;
    favFoods = auxFoods.map((e) {FoodModel.fromMap(e);}).toList();
    var auxWorkouts = doc.data()['fav workouts'] as List;
    favWorkouts = auxWorkouts.map((e) => TrainModel.fromMap(e)).toList();
  }

  UserModel.fromUser(User user){
    uid = user.uid;
    email = user.email;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> foodAux = List();
    List<Map<String, dynamic>> workoutAux = List();
    favWorkouts.forEach((element) {workoutAux.add(element.toJson());});
    favFoods.forEach((element) {foodAux.add(element.toJson());});
    return {
      'uid' : uid,
      'email' : email,
      'fav workouts' : workoutAux,
      'fav foods' : foodAux,
      'name' : name,
      'age' : age,
    };
  }

}