import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:fitirun/com/fitirun/resource/size_config.dart';
import 'package:fitirun/com/fitirun/resource/heading_widget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical * 90,
      child: Column(
        children: [
          _buildDaysBar(),
          _buildDashboardCards()
        ],
      ),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Today',
            style: CustomTextStyle.dayTabBarStyleActive,
          ),
          Text(
            'Week',
            style: CustomTextStyle.dayTabBarStyleInactive,
          ),
          Text(
            'Month',
            style: CustomTextStyle.dayTabBarStyleInactive,
          ),
          Text(
            'Year',
            style: CustomTextStyle.dayTabBarStyleInactive,
          )
        ],
      ),
    );
  }

  Widget _buildDashboardCards() {
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
            HeadingWidget(text1: 'ACTIVITY', text2: 'Show All'),
            _buildCard(
                color1: CustomColors.kLightPinkColor,
                color2: CustomColors.kCyanColor,
                color3: CustomColors.kYellowColor,
                color4: CustomColors.kPurpleColor,
                value: 0.6,
                iconPath: 'assets/icons/running.png',
                metricType: 'Running',
                metricAchieved: '2500',
                metricTarget: '4000'),
            _buildCard(
                color1: CustomColors.kCyanColor,
                color2: CustomColors.kYellowColor,
                color3: CustomColors.kPurpleColor,
                color4: CustomColors.kLightPinkColor,
                value: 0.8,
                iconPath: 'assets/icons/footprints.png',
                metricType: 'Steps',
                metricAchieved: '3500',
                metricTarget: '4500')
          ],
        ),
      ),
    );
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
                    metricTarget,
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