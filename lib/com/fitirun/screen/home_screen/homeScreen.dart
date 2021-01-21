import 'package:fitirun/com/fitirun/model/warehouse.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/resource/size_config.dart';
import 'package:fitirun/com/fitirun/screen/welcome_screen/welcomeScreen.dart';
import 'package:fitirun/com/fitirun/screen/home_screen/widgets/dashboard_screen.dart';
import 'package:fitirun/com/fitirun/util/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int loginStreak = 15;
  int currentWeight = 65;
  final AuthService _auth = AuthService();
  UserModel userModel;


  /*here*/


  @override
  void initState() {
    super.initState();

    Warehouse().addListener((userModel) =>
    {
      if(!mounted)
        setState(() => this.userModel = userModel)
    });
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(
        children: [
          _buildDaysBar(),
          Expanded(child: SingleChildScrollView(child: DashboardScreen())),
        ],
      )),
    );
  }

  Container _buildDaysBar() {
    return Container(
      margin: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * 2,
        bottom: SizeConfig.blockSizeVertical * 2,
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text(
              'Today',
              style: CustomTextStyle.dayTabBarStyleActive,
            ),
          ), /*
          Text(
            '',
            style: CustomTextStyle.dayTabBarStyleInactive,
          ),
          Text(
            '',
            style: CustomTextStyle.dayTabBarStyleInactive,
          ), */
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Text(
              'Chase your goals!',
              style: CustomTextStyle.dayTabBarStyleInactive,
            ),
          )
        ],
      ),
    );
  }
}