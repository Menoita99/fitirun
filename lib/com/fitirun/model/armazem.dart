import 'package:fitirun/com/fitirun/model/user_model.dart';

class Warehouse{

  static final Warehouse _warehouse = Warehouse._internal();

  UserModel userModel = UserModel();
  List<Function(UserModel userModel)> listeners = List();

  factory Warehouse(){
    return _warehouse;
  }

  Warehouse._internal();

  void clearUserModel() {
    userModel = null;
  }

  void setUserModel(UserModel userModel){
    this.userModel = userModel;
    listeners.forEach((element) {
      element(userModel);
    });
  }

  void addListener(Function(UserModel userModel) onEvent){
    listeners.add(onEvent);
  }
}
