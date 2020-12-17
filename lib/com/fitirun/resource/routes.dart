import 'package:fitirun/com/fitirun/screen/health_screen/healthScreen.dart';
import 'package:fitirun/com/fitirun/screen/home_screen/homeScreen.dart';
import 'package:fitirun/com/fitirun/screen/login_screen/login_screen.dart';
import 'package:fitirun/com/fitirun/screen/run_screen/runScreen.dart';
import 'package:fitirun/com/fitirun/screen/signup_screen/signup_screen.dart';
import 'package:fitirun/com/fitirun/screen/welcome_screen/welcomeScreen.dart';

getRoutes() {
  return {
    '/': (context) => WelcomeScreen(),
    '/signup': (context) => SignUpScreen(),
    '/login': (context) => LoginScreen(),
    '/health': (context) => HealthScreen(),
    '/home': (context) => HomeScreen(),
    '/run': (context) => RunScreen(),
    '/': (context) => WelcomeScreen(),
    '/login': (context) => LoginScreen(),
    '/register': (context) => SignUpScreen(),
  };
}

//navigation
getNavRoute() {
  return [
    "/home",
    "/run",
    "/health",
    "/home",
  ];
}