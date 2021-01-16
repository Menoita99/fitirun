import 'package:fitirun/com/fitirun/costum_widget/navigationBar.dart';
import 'package:fitirun/com/fitirun/model/workoutModel.dart';
import 'package:fitirun/com/fitirun/resource/constants.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class RunScreen extends StatefulWidget {

  @override
  _RunScreenState createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }

  Widget getBody() {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  indicatorColor: blackText,
                  tabs: [
                    Tab(icon: Text("Map",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: blackText,
                      ),
                    )),
                    Tab(icon: Text("Manager",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: blackText,
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              mapView(),
              managerView(context),
            ],
          ),
        ),
      )
    );
  }



  Widget mapView() {
    return Stack(
      children: [
        Container(
          color: Colors.grey[100],
          child: Center(
            child: Text("Imagine a map here :)"),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top:10,right: 10),
                child: timerBox("10:23",70),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:15,bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getManagerTimer(),
                  getSpeed()
                ],
              ),
            )
          ],
        )
      ],
    );
  }



  Widget getSpeed() {
    return Padding(
      padding: const EdgeInsets.only(right:10),
      child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.all(
                  Radius.circular(200),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "12",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " km/h",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
    );
  }



  Widget timerBox(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          )
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }


  getManagerTimer() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: pastel_green,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),

      ),
      child: Center(
        child: Text(
          "00:20",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ),
    );
  }



  Widget managerView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TrainModel train =  TrainModel.fakeModel();
    return Container(
      color: Colors.grey[200],
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:40),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: RadialProgress(
                    width: size.width * 0.36,
                    height: size.width * 0.36,
                    progress: 0.6,
                  ),
                ),
              ),
              Padding(
                padding:const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_football),
                    SizedBox(width: 10),
                    Text("3265 steps")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department_outlined),
                    SizedBox(width: 10),
                    Text("862 kca")
                  ],
                ),
              ),
            ],
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.55,
            maxChildSize: 1,
            builder: (context, controller) {
              return SingleChildScrollView(
                controller: controller,
                child: Container(
                  height: size.height*0.805,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft:  Radius.circular(50))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(children: train.train.map((e) => getTrainItem(context,e,false)).toList()),
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }




  Widget getTrainItem(BuildContext context, ExerciceModel exercise, bool bool) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 20,bottom: 10,right: 20),
      child: Container(
        height: 50,
        width: size.width-10,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            )
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    exercise.title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    exercise.bodyPart,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
















class RadialProgress extends StatefulWidget {
  final double height, width, progress;

  const RadialProgress({Key key, this.height, this.width, this.progress}) : super(key: key);

  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress> {



  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
        progress:  widget.progress,
      ),
      child: Container(
        height: widget.height,
        width:  widget.width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "1731",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: dark_blue,
                  ),
                ),
                TextSpan(text: "\n"),
                TextSpan(
                  text: "m left",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color:dark_blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;

  _RadialPainter({this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = dark_blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(-relativeProgress),
      false,
      paint,
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

