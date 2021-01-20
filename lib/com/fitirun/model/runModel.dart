
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
class RunModel{
  String title;
  String shortDescription;
  int totalDuration = 0;
  List<ExerciseRunModel> exercises= List();
  int difficulty;

  RunModel(this.title,this.exercises){
    for (var i=0; i<exercises.length; i++)
      totalDuration += exercises[i].duration;
  }

  RunModel.fakeModel(){
    difficulty = Faker().randomGenerator.integer(3);
    int random = Faker().randomGenerator.integer(5)+3;
    for(int i = 0 ; i <random ; i++)
      exercises.add(ExerciseRunModel.fakeModel());
    shortDescription = faker.lorem.sentence();
    title = faker.lorem.words(4).join(" ").capitalize();
    for (var i=0; i< exercises.length; i++)
      totalDuration += exercises[i].duration;
  }

  String getFormatedDuration(){
    String mins = (totalDuration~/60).toInt() < 10 ? '0'+(totalDuration~/60).toInt().toString() : (totalDuration~/60).toInt().toString();
    String second = (totalDuration%60).toInt() < 10 ? '0'+(totalDuration%60).toString() : (totalDuration%60).toString();
    return "$mins:$second";
  }

  RunModel.fromMap(Map doc){
    if(doc != null) {
      title = doc['title'];
      shortDescription = doc['short description'];
      totalDuration = doc['total duration'];
      //exercises = (doc['exercises'] as List<dynamic>).map((e) => e.toString()).toList();
      difficulty = doc['Difficulty'];
    }
  }

  RunModel.fromDoc(DocumentSnapshot doc){
    title = doc['title'];
    shortDescription = doc.data()['short description'];
    totalDuration = doc.data()['total duration'];
    exercises = (doc.data()['exercises'] as List<dynamic>).map((e) => ExerciseRunModel.fromMap(e)).toList();

    difficulty = doc.data()['Difficulty'];
  }


  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> auxExercises = List();
    exercises.forEach((element) {auxExercises.add(element.toJson());});
    //print(exercises);
    return {
      'title': title,
      'Difficulty': difficulty,
      'short description': shortDescription,
      'exercises': auxExercises,
      'total duration': totalDuration,
    };
  }


}

class ExerciseRunModel{
  int duration;
  String title;
  String description;

  ExerciseRunModel(this.duration,this.title,this.description);

  ExerciseRunModel.fakeModel(){
    Faker faker = new Faker();
    duration = faker.randomGenerator.integer(200) + 30;
    title = faker.lorem.words(4).join(" ").capitalize();
    description = faker.lorem.sentences(faker.randomGenerator.integer(5) + 1).join(".\n");
  }

  ExerciseRunModel.fromMap(Map doc){
    duration = int.parse(doc['duration']);
    title = doc['title'];
    description = doc['description'];
  }

  String getFormatedDuration(){
    String mins = (duration~/60).toInt() < 10 ? '0'+(duration~/60).toInt().toString() : (duration~/60).toInt().toString();
    String second = (duration%60).toInt() < 10 ? '0'+(duration%60).toString() : (duration%60).toString();
    return "$mins:$second";
  }


  Map<String, dynamic> toJson() {
    return {
      'duration' : duration.toString(),
      'title' : title,
      'description' : description,
    };
  }
}

Color getDifficultyColor(int diff) {
  switch (diff) {
    case 0:
      {
        return pastel_green;
      }
      break;
    case 1:
      {
        return pastel_orange;
      }
      break;
    case 2:
      {
        return pastel_red;
      }
    default:
      {
        throw("Received wrong number as difficulty $diff");
      }
  }
}
