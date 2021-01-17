import 'dart:async';

import 'package:flutter/foundation.dart';

class CustomTimer{
  
  int tick ;
  Timer timer;
  Function onTick;
  int stopAt;
  int startAt; //if < 0 has no limit
  int currentTick;
  bool direction;// id true is ascending else id descending

  CustomTimer({this.startAt, this.stopAt = -1, this.onTick, this.tick = 1000}){
    currentTick = startAt;
    if(startAt<0)
      throw('Start condition can\'t be minor then 0');

    direction = stopAt > startAt || stopAt<0;
    stopAt = direction ? stopAt : 0;

    timer = Timer.periodic(Duration(milliseconds: tick), (timer) {
      currentTick = direction ? currentTick + tick : currentTick - tick;

      if((currentTick >= stopAt && direction && stopAt > 0) || (currentTick <= stopAt && !direction))
        stop();

      if(onTick!= null)
        onTick.call();
    });
  }

  void stop() {
    timer.cancel();
  }

  String getFormattedCurrentTime(){
    int  time = (currentTick~/1000).toInt();
    String mins = (time~/60).toInt() < 10 ? '0'+(time~/60).toInt().toString() : (time~/60).toInt().toString();
    String second = (time%60).toInt() < 10 ? '0'+(time%60).toString() : (time%60).toString();
    return "$mins:$second";
  }
}