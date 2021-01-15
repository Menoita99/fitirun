import 'dart:async';

import 'package:fitirun/com/fitirun/util/Location/user_location.dart';
import 'package:location/location.dart';

class LocationUtils{
  //keep track of the current location
  UserLocation _currentLocation;
  Location location = Location();

  //countinously emit location updates
  StreamController<UserLocation> _locationController = StreamController<UserLocation>.broadcast();

  Future<UserLocation> getLocation() async {
    try{
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(longitude: userLocation.longitude, latitude: userLocation.latitude);
    }catch(e){
      print("Could not get location: $e");
    }
    return _currentLocation;
  }

  UserLocation getCurrentLocation(){
    return _currentLocation;
  }






}
