import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/resource/size_config.dart';
import 'package:fitirun/com/fitirun/resource/heading_widget.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/model/warehouse.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical * 90,
      child: Column(
        children: [
          _buildDashboardCards()
        ],
      ),
    );
  }


  Widget _buildDashboardCards() {

    UserModel user = Warehouse().userModel;

    num runtrg = 2500;//get goals from user
    num stptrg = 4000;//get goals from user
    num runach = getMetric(user, 'running');
    num stpach = getMetric(user, 'steps');

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: CustomColors.kBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Column(
          children: [
            HeadingWidget(text1: 'ACTIVITY', text2: 'Show All',),
            _buildCard(
                color1: CustomColors.kLightPinkColor,
                color2: CustomColors.kCyanColor,
                color3: CustomColors.kYellowColor,
                color4: CustomColors.kPurpleColor,
                metricAchieved: runach.toString(),
                metricTarget: runtrg.toString(),
                value: runach/runtrg,
                iconPath: 'assets/icons/running.png',
                metricType: 'Running',),
            _buildCard(
                color1: CustomColors.kCyanColor,
                color2: CustomColors.kYellowColor,
                color3: CustomColors.kPurpleColor,
                color4: CustomColors.kLightPinkColor,
                metricAchieved: stpach.toString(),
                metricTarget: stptrg.toString(),
                value: stpach/stptrg,
                iconPath: 'assets/icons/footprints.png',
                metricType: 'Steps',),
          ],
        ),
      ),
    );
  }

  num getMetric(UserModel user, String s) {
    int sum = 0;
    var now = new DateTime.now();
    switch (s) {
      case 'running':
        if (user.steps.length > 0) {
          for (int i; i < user.steps.length; i++) {
            if (user.steps[i].time.day == now.day)
              sum += user.steps[i].steps;
            else
              break;
          }
          return sum;
        } else
          return 1000;
        break;
      case 'steps':
        if (user.statistics.length > 0) {
          // for(int i; i < user.statistics.length; i++) {
          //   if (user.statistics[i].time.day==now.day)
          //     sum+=user.statistics[i];
          //   else
          //     break;
          // }
          return sum;
        } else
          return 1000;
        break;
    }
  }

  Container _buildCard(
      {Color color1,
        Color color2,
        Color color3,
        Color color4,
        String metricType,
        String metricAchieved,
        String metricTarget,
        double value,
        String iconPath}) {
    return Container(
      height: SizeConfig.blockSizeVertical * 30,
      width: SizeConfig.blockSizeHorizontal * 85,
      margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1),
      decoration: BoxDecoration(
          color: CustomColors.kPrimaryColor,
          borderRadius: BorderRadius.circular(20.0)),
      child: Stack(
        children: [

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: SizeConfig.blockSizeVertical * 10, // 12% of screen
              width:
              SizeConfig.blockSizeHorizontal * 10, // 23% of width of screen
              decoration: BoxDecoration(
                  color: color3,
                  borderRadius: BorderRadius.only(
                      topRight:
                      Radius.circular(SizeConfig.blockSizeVertical * 5),
                      bottomRight:
                      Radius.circular(SizeConfig.blockSizeVertical * 5))),
            ),
          ),
          Positioned(
            top: SizeConfig.blockSizeVertical * 3,
            left: SizeConfig.blockSizeHorizontal * 6,
            child: Container(
              child: Row(
                children: [
                  Image.asset(
                    iconPath,
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeVertical * 1,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metricType,
                        style: TextStyle(color: CustomColors.kLightColor),
                      ),
                      Text(
                        metricAchieved,
                        style: CustomTextStyle.metricTextStyle,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: SizeConfig.blockSizeVertical * 5,
            left: SizeConfig.blockSizeHorizontal * 6,
            child: Container(
              child: Row(
                children: [
                  Text(
                    metricTarget.toString(),
                    style: CustomTextStyle.metricTextStyle,
                  ),
                  Text(
                    ' m',
                    style: TextStyle(color: CustomColors.kLightColor),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: SizeConfig.blockSizeVertical * 1, // 12% of screen
              width:
              SizeConfig.blockSizeHorizontal * 75, // 23% of width of screen
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: LinearProgressIndicator(
                    value: value,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    backgroundColor: CustomColors.kLightColor.withOpacity(0.2)),
              ),
            ),
          )
        ],
      ),
    );
  }

}