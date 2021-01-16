import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{



  //collection Reference
  final CollectionReference authDetailsCollection = FirebaseFirestore.instance.collection('AuthDetails');

  Future updateLoginList(String uid, String time) async {
    return await authDetailsCollection.doc("LoginList").update({
      'User id' : uid,
      'Time' : time,
    });
  }

  Future updateLogoutList(String uid, String time) async {
    return await authDetailsCollection.doc("LogoutList").update({
      'User id' : uid,
      'Time' : time,
    });
  }














}