import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MySpeechRecognitionService {

  final Function callBackUpdateInput;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String recognizedText = '';
  bool finalState = false;
  bool done = false;
  bool is_done = true;

  final SpeechToText speech = SpeechToText();

  MySpeechRecognitionService({required this.callBackUpdateInput});

  Future <String> startDictation()async{
    bool is_initialized = await initSpeechState();
    if(is_initialized){
      startListening();
    }else{
      print('not initialized');
      return '';
    }
    print('i dont know whats wrong');
    return '';
  }

  Future<bool> initSpeechState() async {
    // _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
      );
      if (hasSpeech) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Speech recognition failed: ${e.toString()}");
      return false;
    }
  }

  resultListener(SpeechRecognitionResult result) {
    recognizedText = result.recognizedWords;
    finalState = result.finalResult;

    print(result.finalResult);
    print(result.recognizedWords);

    callBackUpdateInput(result.recognizedWords,speech.isListening,result.finalResult, this.is_done);
    // return {
    //   'result': result.finalResult,
    //   'recognized_words': result.recognizedWords
    // };

  }

  void startListening() {
    // Note that `listenFor` is the maximum, not the minimun, on some
    // recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 520),
        pauseFor: Duration(seconds: 20),
        partialResults: true,
        //localeId: _currentLocaleId,
        // onSoundLevelChange: soundLevelListener,
        cancelOnError: false,
        listenMode: ListenMode.dictation);
  }

  void stopListening() {
    speech.stop();
  }

  void cancelListening() {
    speech.cancel();
  }

  void errorListener(SpeechRecognitionError error) {
    print('${error.errorMsg} - ${error.permanent}');
    print('Error message***');
  }

  bool statusListener(String status) {
    print(status);
    status=='done'?is_done=true:is_done=false;
    return status=='done'?true:false;
  }
}
