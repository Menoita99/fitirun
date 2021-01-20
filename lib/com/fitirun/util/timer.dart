import 'dart:async';

class CustomTimer{
  
  int tick ;
  Timer timer;
  Function onTick;
  Function onFinish;
  int stopAt;
  int startAt; //if < 0 has no limit
  int currentTick;
  bool direction;
  bool isActive=false;// id true is ascending else id descending


  CustomTimer({this.startAt,  this.onTick,this.onFinish, this.stopAt = -1, this.tick = 1000}){
    currentTick = startAt;
    if(startAt<0)
      throw('Start condition can\'t be minor then 0');


    direction = stopAt > startAt || stopAt<0;
    stopAt = direction ? stopAt : 0;
    print("Start $startAt, stop $stopAt, direction $direction");
  }

  void start(){
    isActive = true;

    timer = Timer.periodic(Duration(milliseconds: tick), (timer) {
      currentTick = direction ? currentTick + tick : currentTick - tick;
      if((currentTick >= stopAt && direction && stopAt > 0) || (currentTick <= stopAt && !direction)) {
        if(onFinish!=null)
          onFinish();
        stop();
      }

      if(onTick!= null) {
        onTick(currentTick);
      }
    });
  }

  void stop() {
    isActive=false;
    if(timer != null && timer.isActive)
      timer.cancel();
  }

  String getFormattedCurrentTime(){
    int  time = (currentTick~/1000).toInt();
    String mins = (time~/60).toInt() < 10 ? '0'+(time~/60).toInt().toString() : (time~/60).toInt().toString();
    String second = (time%60).toInt() < 10 ? '0'+(time%60).toString() : (time%60).toString();
    return "$mins:$second";
  }
}