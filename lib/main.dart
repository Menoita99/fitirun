import 'package:firebase_core/firebase_core.dart';
import 'package:fitirun/com/fitirun/resource/routes.dart';
import 'package:fitirun/com/fitirun/screen/run_screen/runManager.dart';
import 'package:fitirun/com/fitirun/util/services/auth.dart';
import 'package:get_it/get_it.dart';
import 'com/fitirun/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'com/fitirun/util/PedometerUtil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<PedometerUtil>(PedometerUtil());
  GetIt.I.registerSingleton<RunManager>(RunManager());
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [StreamProvider<UserModel>.value(value: AuthService().user)],
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
