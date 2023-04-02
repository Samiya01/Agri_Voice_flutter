import 'package:flutter/cupertino.dart';

class CallProvider extends ChangeNotifier{
  bool micOn = false;
  bool initiateMic = false;

  void onMicAutoStop(){
    micOn?initiateMic=true:initiateMic=false;
    notifyListeners();
  }

  void stopMic(){
    micOn=false;
    initiateMic=false;
    notifyListeners();
  }

  void resetInitiateMic(){
    initiateMic=false;
    notifyListeners();
  }

}