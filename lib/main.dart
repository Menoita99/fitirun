import 'package:firebase_core/firebase_core.dart';
import 'package:fitirun/com/fitirun/resource/routes.dart';
import 'package:fitirun/com/fitirun/screen/health_screen/healthScreen.dart';
import 'package:fitirun/com/fitirun/screen/home_screen/homeScreen.dart';
import 'package:fitirun/com/fitirun/screen/run_screen/runManager.dart';
import 'package:fitirun/com/fitirun/util/services/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'com/fitirun/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'com/fitirun/resource/constants.dart';
import 'com/fitirun/screen/profile_screen/profileScreen.dart';
import 'com/fitirun/screen/run_screen/runScreen.dart';
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


class AppScreen extends StatefulWidget {

  const AppScreen({Key key,}) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {

  int _selectedIndex = 0;
  Color actualColor;
  RunManager manager = GetIt.I<RunManager>();

  final List<Widget> _widgetOptions = [
    HomeScreen(),
    RunScreen(),
    HealthScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    manager.stop();
    super.dispose();
  }



  void _onItemTapped(int index) {
    setState(() {  _selectedIndex = index; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 500),
                tabBackgroundColor: actualColor == null ? navColors.elementAt(_selectedIndex) :  actualColor,
                tabs: [
                  GButton(
                    iconColor: blackText,
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    iconColor: blackText,
                    icon: Icons.directions_run,
                    text: 'Run',
                  ),
                  GButton(
                    iconColor: blackText,
                    icon: Icons.fitness_center,
                    text: 'Fitness',
                  ),
                  GButton(
                    iconColor: blackText,
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange:_onItemTapped),
          ),
        ),
      ),
      /*
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),*/
    );
  }
}