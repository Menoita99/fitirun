
import 'package:cached_network_image/cached_network_image.dart';
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
  int preparationTime;
  int numberOfPeople;
  int calories;
  List<String> recipe;

  FoodModel(this.image, this.rank, this.title, this.preparationTime,  this.numberOfPeople, this.calories, this.recipe);

  FoodModel.fakeFood(){
     Faker faker = new Faker();
    image = _urls.elementAt(faker.randomGenerator.integer(_urls.length));
    rank = faker.randomGenerator.integer(5);
    title = faker.lorem.words(5).join(" ").capitalize();
    preparationTime = faker.randomGenerator.integer(100)+1;
    numberOfPeople = faker.randomGenerator.integer(4)+1;
    calories = faker.randomGenerator.integer(1000)+1;
    recipe = faker.lorem.sentences(2);
  }


  CachedNetworkImage getCachedIamge(String url){
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => new CircularProgressIndicator(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
    );
  }


  List<String> _urls = [
    'https://media.istockphoto.com/photos/shopping-bag-full-of-fresh-vegetables-and-fruits-picture-id1128687123?k=6&m=1128687123&s=612x612&w=0&h=PGSt75Y0gXRgKAQBLy55zEP_kvkv4EJmf5xzF0Lzvz4=',
    'https://www.foodiesfeed.com/wp-content/uploads/2019/06/top-view-for-box-of-2-burgers-home-made.jpg',
    'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=700%2C636',
    'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.unsplash.com/photo-1498837167922-ddd27525d352?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjEyMDd9',
    'https://images.unsplash.com/photo-1498837167922-ddd27525d352?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjEyMDd9',
  ];
}
