import 'package:fitirun/com/fitirun/screen/health_screen/healthScreen.dart';
import 'package:fitirun/com/fitirun/screen/home_screen/homeScreen.dart';

getRoutes() {
  return {
    '/health': (context) => HealthScreen(),
    '/': (context) => HomeScreen(),
  };
}

//navigation
getNavRoute() {
  return [
    "/",
    "/",
    "/health",
    "/",
  ];
}