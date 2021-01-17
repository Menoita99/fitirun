import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitirun/com/fitirun/model/foodModel.dart';

class DatabaseService{

  //collection references
  final CollectionReference foodsCollection = FirebaseFirestore.instance.collection('Foods');
  final CollectionReference workoutsCollection = FirebaseFirestore.instance.collection('Workouts');
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
  //final CollectionReference authDetailsCollection = FirebaseFirestore.instance.collection('AuthDetails');


  //add workout
  Future<void> addFood(FoodModel foodModel) async {
    return foodsCollection.add({
      'Image url' : foodModel.image,
      'Rank' : foodModel.rank,
      'Title' : foodModel.title,
      'Preparation Time' : foodModel.preparationTime,
      'Number of people' : foodModel.numberOfPeople,
      'Calories' : foodModel.calories,
      'Protein' : foodModel.protein,
      'Carbohydrates' : foodModel.carbohydrates,
      'Recipe' : foodModel.recipe
    })
        .then((value) => print("Food Added: $value"))
        .catchError((error) => print("Failed to add food: $error"));
  }



  //get ____ Stream
  /*Stream<QuerySnapshot> get test {
    return authDetailsCollection.snapshots();
  } */













}