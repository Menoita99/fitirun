import 'dart:ui';

import 'package:faker/faker.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class WorkoutModel {
  String image;
  String title;
  List<String> description;
  int time;

  WorkoutModel(this.image, this.title, this.description, this.time); //min

  WorkoutModel.fakeModel() {
    Faker faker = new Faker();
    image = _urls.elementAt(faker.randomGenerator.integer(_urls.length));
    title = faker.lorem.words(4).join(" ").capitalize();
    time = faker.randomGenerator.integer(100) + 1;
    description = faker.lorem.sentences(faker.randomGenerator.integer(5) + 1);
  }
}




class ExerciceModel extends WorkoutModel {
  String bodyPart;
  int series;
  List<int> repetitions;

  ExerciceModel(this.bodyPart, this.series, this.repetitions, String image, String title, List<String> description, int time)
      : super(image, title, description, time);

  ExerciceModel.fakeModel() : super.fakeModel() {
    Faker faker = new Faker();
    bodyPart = faker.lorem.words(1).join(" ").capitalize();
    series = 3;
    List<int> repetitions = [
      faker.randomGenerator.integer(5) + 10,
      faker.randomGenerator.integer(5) + 10,
      faker.randomGenerator.integer(5) + 10
    ];
  }
}




class TrainModel extends WorkoutModel {
  List<ExerciceModel> train = [];
  int difficulty;

  TrainModel(this.train, String image, String title, List<String> description,int time,this.difficulty) : super(image, title, description, time);

  TrainModel.fakeModel() : super.fakeModel() {
    difficulty = Faker().randomGenerator.integer(3);
    int random = Faker().randomGenerator.integer(5)+3;
    for(int i = 0 ; i <random ; i++)
      train.add(ExerciceModel.fakeModel());
  }

  static Color getDifficultyColor(int diff){
    switch(diff) {
      case 0: {
        return pastel_green;
      }
      break;
      case 1: {
        return pastel_orange;
      }
      break;
      case 2: {
        return pastel_red;
      }
      default: {
        throw("Received wrong number as difficulty $diff");
      }
    }
  }

  static String getDifficultyPhrase(int diff){
    switch(diff) {
      case 0: {
        return "easy";
      }
      break;
      case 1: {
        return "medium";
      }
      break;
      case 2: {
        return "hard";
      }
      default: {
        throw("Received wrong number as difficulty $diff");
      }
    }
  }
}


WorkoutModel getRandomWorkOut(){
  switch(Faker().randomGenerator.integer(3,min: 0)) {
    case 0: {
      return WorkoutModel.fakeModel();
    }
    break;
    case 1: {
      return ExerciceModel.fakeModel();
    }
    break;
    case 2: {
      return TrainModel.fakeModel();
    }
    default: {
      print("WTF");
      return null;
    }
  }
}



List<String> _urls = [
  'https://cimg3.ibsrv.net/cimg/www.fitday.com/693x350_85-1/199/home-199199.jpg',
  'https://www.wellandgood.com/wp-content/uploads/2019/02/GettyImages-core-gradyreese.jpg',
  'https://www.mensjournal.com/wp-content/uploads/2018/05/gettyimages-500808087.jpg?quality=86&strip=all',
  'https://images.unsplash.com/photo-1558017487-06bf9f82613a?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=405&q=80',
  'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=334&q=80',
  'https://images.everydayhealth.com/images/heart-health/hypertension/exercise-hypertension-722x406.jpg',
  'https://www.quickanddirtytips.com/sites/default/files/styles/insert_large/public/images/13606/performingtabatasets.png?itok=BS2Dt9-7',
];
