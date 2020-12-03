import 'package:fitirun/com/fitirun/screen/health_screen/healthScreen.dart';
import 'package:fitirun/com/fitirun/screen/home_screen/homeScreen.dart';
import 'package:fitirun/com/fitirun/screen/run_screen/runScreen.dart';

getRoutes() {
  return {
    '/health': (context) => HealthScreen(),
    '/': (context) => HomeScreen(),
    '/run': (context) => RunScreen(),
  };
}

//navigation
getNavRoute() {
  return [
    "/",
    "/run",
    "/health",
    "/",
  ];
}