import 'file:///C:/Users/rui.menoita/StudioProjects/fitirun/lib/com/fitirun/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (user == null) {
      return Scaffold(
        body: Body(),
      );
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/home");
      });
      return Container(child: Center( child: Text("Loading...", style: TextStyle(fontSize: 30),),), color: Colors.white);
    }
  }
}
