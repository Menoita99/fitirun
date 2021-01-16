import 'package:firebase_core/firebase_core.dart';
import 'package:fitirun/com/fitirun/resource/routes.dart';
import 'package:fitirun/com/fitirun/util/services/auth.dart';
import 'package:fitirun/com/fitirun/util/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreamProvider<UserModel>.value(
    value: AuthService().user,
    child: MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Nunito',
      ),
       initialRoute: '/',
       routes: getRoutes(),
    ),
  ));
}