import 'package:fitirun/com/fitirun/model/days.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fitirun/com/fitirun/model/user_model.dart';
import 'package:fitirun/com/fitirun/model/warehouse.dart';

class BarChartTwo extends StatefulWidget {
  String _value;
  BarChartTwo(String value){
    this._value=value;
  }
  @override
  State<StatefulWidget> createState() => BarChartTwoState();
}

class BarChartTwoState extends State<BarChartTwo> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;
  int touchedGroupIndex;
  List<double> weeklyData;


  @override
  Widget build(BuildContext context) {
    String value= widget._value;
    weeklyData = getWeeklyData(value);

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: const Color(0xff2c4260),
      ),
      margin: EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BarChart(
                _mainBarData(),
              ),
            ),
          ),
        ],
      ),
    );
  }


  List<double> getWeeklyData(String str) {
    UserModel user = Warehouse().userModel;
    List<double> week = [0,0,0,0,0,0,0];
    var now = new DateTime.now();
    switch (str) {
      case 'Steps Walked':
        if (user.steps.length > 0 && user.steps!= null && user.steps.length > 0) {
          for(int d = 0; d < week.length; d++){
            for (int i = 0; i < user.steps.length; i++) {
              if (user.steps[i].time.isAfter(now.subtract(new Duration(days: 6-d)))) { //to do alter function to work with dd/mm/yyyy
                if (user.steps[i].time.isBefore(now.subtract(new Duration(days: 5-d)))) {
                  week[d] += user.steps[i].steps;
                }
              }
              else
                break;
            }
            return week;
          }
        } else
          return [569,200,320,700,200,212,1000];
        break;
      case 'Meters Run':
        if (user != null && user.statistics!= null && user.statistics.length > 0) {
          for(int d = 0; d < week.length; d++){
            for (int i = 0; i < user.statistics.length; i++) {
              for(int j = 0; j < user.statistics[i].data.length; j++) {
                if (user.statistics[i].data[j].time.isAfter(now.subtract(new Duration(days: 6-d)))) { //to do alter function to work with dd/mm/yyyy
                  if (user.statistics[i].data[j].time.isBefore(now.subtract(new Duration(days: 5-d))) || d==6) {
                    week[d] += user.statistics[i].data[j].distance;
                  }
                } else
                break;
              }
            }
            return week;
          }
        } else
          return [554,343,785,453,1432,124,423];
    }
  }

  double getWeeklyMax() {
    double max = 10;
    for(int i = 0; i < weeklyData.length; i++) {
      if (weeklyData[i]>max)
        max = (weeklyData[i]*1.1);
    }
  }

  BarChartData _mainBarData() {
    return BarChartData(
      maxY: getWeeklyMax(),
      titlesData: _buildAxes(),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _buildAllBars(),
    );
  }

  FlTitlesData _buildAxes() {
    return FlTitlesData(
      show: true,
      // Build X axis.
      bottomTitles: SideTitles(
        showTitles: true,
        getTextStyles: ((value) => TextStyle(
            color: const Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 14)),
        margin: 20,
        getTitles: (double value) {
          switch (value.toInt()) {
            case 0:
              return 'Mn';
            case 1:
              return 'Te';
            case 2:
              return 'Wd';
            case 3:
              return 'Tu';
            case 4:
              return 'Fr';
            case 5:
              return 'St';
            case 6:
              return 'Sn';
            default:
              return '';
          }
        },
      ),
      // Build Y axis.
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: ((value) => TextStyle(
            color: const Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 14)),
        margin: 32,
        reservedSize: 14,
        getTitles: (value) {
          if (value == 0) {
            return '1K';
          } else if (value == 10) {
            return '5K';
          } else if (value == 19) {
            return '10K';
          } else {
            return '';
          }
        },
      ),
    );
  }

  // Function to draw all the bars.
  List<BarChartGroupData> _buildAllBars() {
    return List.generate(
      weeklyData.length, // y1                 // y2
          (index) => _buildBar(index, weeklyData[index]),
    );
  }

  // Function to define how to bar would look like.
  BarChartGroupData _buildBar(int x, double y1) {
    return BarChartGroupData(
      barsSpace: 5,
      x: x,
      barRods: [
        BarChartRodData(
          y: y1,
          colors: [leftBarColor],
          width: width,
        ),
      ],
    );
  }


}