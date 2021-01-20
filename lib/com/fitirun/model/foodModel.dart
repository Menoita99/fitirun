
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class FoodModel{
  String image;
  int rank;
  String title;
  String description;
  int preparationTime; //min
  int numberOfPeople;
  int calories;
  int protein;
  int carbohydrates;
  List<String> recipe;

  FoodModel(this.image, this.rank, this.title, this.preparationTime,  this.numberOfPeople, this.calories, this.recipe);
  FoodModel.fromDoc(DocumentSnapshot doc){
    calories = doc.data()['Calories'];
    carbohydrates = doc.data()['Carbohydrates'];
    protein = doc.data()['Protein'];
    numberOfPeople = doc.data()['Number of people'];
    preparationTime = doc.data()['Preparation Time'];
    title = doc.data()['Title'];
    rank = doc.data()['Rank'];
    image = doc.data()['Image url'];
    recipe = (doc.data()['Recipe'] as List<dynamic>).map((e) => e.toString()).toList();
    description = doc.data()['Description'];
  }

  FoodModel.fromMap(Map doc){
    numberOfPeople = doc['Number of people'];
    image = doc['Image url'];
    rank = doc['rank'];
    preparationTime = doc['Preparation Time'];
    calories = doc['Calories'];
    carbohydrates = doc['Carbohydrates'];
    title = doc['Title'];
    protein = doc['Protein'];
    recipe = (doc['Recipe'] as List<dynamic>).map((e) => e.toString()).toList();
    description = doc['Description'];
  }

  FoodModel.fakeFood(){
    Faker faker = new Faker();
    image = _urls.elementAt(faker.randomGenerator.integer(_urls.length));
    rank = faker.randomGenerator.integer(5);
    title = faker.lorem.words(4).join(" ").capitalize();
    preparationTime = faker.randomGenerator.integer(100)+1;
    numberOfPeople = faker.randomGenerator.integer(4)+1;
    calories = faker.randomGenerator.integer(1000)+1;
    protein = faker.randomGenerator.integer(100)+1;
    carbohydrates = faker.randomGenerator.integer(300)+1;
    recipe = faker.lorem.sentences(7);
    description = faker.lorem.sentence();
  }


  CachedNetworkImage getCachedIamge(String url){
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }


  List<String> _urls = [
    'https://media.istockphoto.com/photos/shopping-bag-full-of-fresh-vegetables-and-fruits-picture-id1128687123?k=6&m=1128687123&s=612x612&w=0&h=PGSt75Y0gXRgKAQBLy55zEP_kvkv4EJmf5xzF0Lzvz4=',
    'https://www.foodiesfeed.com/wp-content/uploads/2019/06/top-view-for-box-of-2-burgers-home-made.jpg',
    'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=700%2C636',
    'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.unsplash.com/photo-1498837167922-ddd27525d352?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjEyMDd9',
    'https://post.healthline.com/wp-content/uploads/2020/09/healthy-eating-ingredients-1200x628-facebook-1200x628.jpg',
    'https://eatforum.org/content/uploads/2018/05/table_with_food_top_view_900x700.jpg'
  ];

  Map<String, dynamic> toJson() {
    return {
      'Image url' : image,
      'Rank' : rank,
      'Title' : title,
      'Preparation Time' : preparationTime,
      'Number of people' : numberOfPeople,
      'Calories' : calories,
      'Protein' : protein,
      'Carbohydrates' : carbohydrates,
      'Recipe' : recipe,
      'Description' : description
  };
  }

  @override
  bool operator ==(Object other) {
    if(other is FoodModel) {
      return this.title == other.title;
    }
    return false;
  }
}
