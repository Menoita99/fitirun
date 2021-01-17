
import 'package:faker/faker.dart';
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

  RunModel(this.title,this.exercises){
    for (var i=0; i<exercises.length; i++)
      totalDuration += exercises[i].duration;
  }

  RunModel.fakeModel(){
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

  String getFormatedDuration(){
    String mins = (duration~/60).toInt() < 10 ? '0'+(duration~/60).toInt().toString() : (duration~/60).toInt().toString();
    String second = (duration%60).toInt() < 10 ? '0'+(duration%60).toString() : (duration%60).toString();
    return "$mins:$second";
  }
}