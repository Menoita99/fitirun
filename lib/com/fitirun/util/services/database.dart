import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';

class DatabaseService{

  //collection references
  final CollectionReference foodsCollection = FirebaseFirestore.instance.collection('Foods');
  final CollectionReference exerciseCollection = FirebaseFirestore.instance.collection('Exercises');
  final CollectionReference trainCollection = FirebaseFirestore.instance.collection('Trains'); //workouts
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
  //final CollectionReference authDetailsCollection = FirebaseFirestore.instance.collection('AuthDetails');


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
















}