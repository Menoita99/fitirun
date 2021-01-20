import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitirun/com/fitirun/model/armazem.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/util/services/database.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create UserModel based on Firebase user
  UserModel _userFromFirebaseUser(User user){
    UserModel userModel = user != null ? UserModel(uid: user.uid, email: user.email) : null;
    if(user != null)
      DatabaseService().getUserModelFromUid(user.uid).then((value)  {
        print(UserModel.fromDoc(value).toJson());
        print("Fetch");
        //print(value.toJson());
        Warehouse().setUserModel(UserModel.fromDoc(value));});
    //print("Autenticado $userModel");
    return userModel;
  }

  //auth change user stream
  Stream<UserModel> get user{
    return _auth.authStateChanges()
        //.map((User user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  //sign in anonymous
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;

      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future loginWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e);
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e);
      return null;
    }
  }

  //sign out
  Future signOut() {
    try{
      Warehouse().clearUserModel();
      return _auth.signOut();
    }catch(e){
      print(e);
      return null;
    }
  }

}