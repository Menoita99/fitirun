import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';

class DatabaseService{

  //collection references
  final CollectionReference foodsCollection = FirebaseFirestore.instance.collection('Foods');
  final CollectionReference exerciseCollection = FirebaseFirestore.instance.collection('Exercises');
  final CollectionReference trainCollection = FirebaseFirestore.instance.collection('Trains'); //workouts
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
  //final CollectionReference authDetailsCollection = FirebaseFirestore.instance.collection('AuthDetails');


  //get UserModel from Firebase
  Future<UserModel> getUserModel(UserModel user) async{
    return await DatabaseService().usersCollection.doc(user.uid).get().then((value){
      print("getUserModel db");
      print(value);
      return UserModel.fromDoc(value);
    }
    );
  }

  //add/update user
  Future<void> addOrUpdateUser(UserModel userModel) async {
    print("Aqui $userModel");
    return usersCollection.doc(userModel.uid).set(
        userModel.toJson(), SetOptions(merge: true),
    ).then((_) => print("User added/updated"));
  }

  //add food
  Future<void> addFood(FoodModel foodModel) async {
    return foodsCollection.add(
      foodModel.toJson()
    )
        .then((value) => print("Food Added: $value"))
        .catchError((error) => print("Failed to add food: $error"));
  }

  //add Exercise
  Future<String> addExercise(ExerciceModel workoutModel) async {

      return exerciseCollection.add(
        workoutModel.toJson()
      )
          .then((value)  => value.id)
          .catchError((error) => print("Failed to add food: $error"));
  }

  //add Train
  Future<void> addTrain(TrainModel workoutModel) {
      return trainCollection.add(
        workoutModel.toJson()
      )
          .then((value) => print("Train Added: $value"))
          .catchError((error) => print("Failed to add Train: $error"));
  }

  //get Food Stream
  Stream<QuerySnapshot> get foods {
    return foodsCollection.snapshots();
  }

  //get Train Stream
  Stream<QuerySnapshot> get workouts {
    return trainCollection.snapshots();
  }
  
  Future<List<FoodModel>> searchFood(String title) async {
    print("Title: " + title);
    List<FoodModel> foodList = List();
    Future f = foodsCollection.snapshots().listen((snapshot)  {
      for(int i = 0; i< snapshot.docs.length; i++){
        if(snapshot.docs[i].data()['Title'].toString().contains(title)){
          print(snapshot.docs[i].data()['Image url'].toString());
          foodList.add(FoodModel.fromDoc(snapshot.docs[i]));
        }
      }
    }).asFuture();

    print("Food list size: " + foodList.length.toString());
    return Future.wait([f]).then((_) => foodList );
  }















}