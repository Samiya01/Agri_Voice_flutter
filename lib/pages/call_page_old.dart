import 'dart:async';

import 'package:agri_voice/providers/call_provider.dart';
import 'package:agri_voice/values.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../services/speech_recognition_service.dart';

class CallPageOld extends StatefulWidget {
  const CallPageOld({Key? key}) : super(key: key);

  @override
  State<CallPageOld> createState() => _CallPageOldState();
}

class _CallPageOldState extends State<CallPageOld> {
  bool _is_loading = false;
  var _input = TextEditingController();
  String _inputWords = "";
  bool _is_listening = false;
  bool _mic_on = false;

  TextToSpeech tts = TextToSpeech();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: mainBg,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('Call', style: TextStyle(color: mainFg)),
          ),
          backgroundColor: mainBg,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: mainDark,
            ),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _inputWords,
                  style: TextStyle(color: mainFg),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    //     color: mainDark,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: mainDark,
                    //         blurRadius: 2,
                    //         offset: Offset(1, 2.5), // Shadow position
                    //       ),
                    //     ],
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       _mic_on
                    //           ? IconButton(
                    //           onPressed: () {
                    //             MySpeechRecognitionService(
                    //                 callBackUpdateInput: _updateInputText)
                    //                 .stopListening();
                    //             setState(() {
                    //               _mic_on = false;
                    //             });
                    //           },
                    //           icon: _is_listening
                    //               ? AvatarGlow(
                    //             endRadius: 30,
                    //             showTwoGlows: true,
                    //             duration: Duration(milliseconds: 500),
                    //             glowColor: mainFg,
                    //             child: Icon(
                    //               Icons.mic,
                    //               size: 35,
                    //               color: mainFg,
                    //             ),
                    //           )
                    //               : Icon(
                    //             Icons.mic,
                    //             size: 35,
                    //             color: mainFg,
                    //           ))
                    //           : IconButton(
                    //
                    //           onPressed: () {
                    //             MySpeechRecognitionService(
                    //                 callBackUpdateInput: _updateInputText)
                    //                 .startDictation();
                    //             setState(() {
                    //               _mic_on = true;
                    //             });
                    //           },
                    //           icon: Icon(
                    //             Icons.mic_off,
                    //             size: 30,
                    //             color: mainFg,
                    //           )),
                    //       Text(
                    //         "speak",
                    //         style: TextStyle(color: mainFg),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      width: 30,
                    ),
                    InkWell(
                        onTap: _speak,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: mainDark,
                            boxShadow: [
                              BoxShadow(
                                color: mainDark,
                                blurRadius: 2,
                                offset: Offset(1, 2.5), // Shadow position
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.speaker,
                                size: 45,
                                color: mainFg,
                              ),
                              Text(
                                "Listen",
                                style: TextStyle(color: mainFg),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child:
                    Consumer<CallProvider>(builder: (context, call, child) {

                      return Container(

                        decoration: BoxDecoration(
                            color: mainDark,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                if (!call.micOn) {
                                  _startListening();
                                }
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                      color: mainBg,
                                      borderRadius: BorderRadius.circular(10.0)),
                                  child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: call.micOn
                                                  ? mainDark
                                                  : mainTextColor),
                                        ),
                                      ))),
                            ),
                            InkWell(
                              onTap: () {
                                if (call.micOn) {
                                  _stopListening();
                                }
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                      color: mainBg,
                                      borderRadius: BorderRadius.circular(10.0)),
                                  child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: call.micOn
                                                  ? mainTextColor
                                                  : mainDark),
                                        ),
                                      ))),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  _startListening() {
    MySpeechRecognitionService(callBackUpdateInput: _updateInputText)
        .startDictation();
  }


  _stopListening() {}

  _sendRequest() {
    print("Sending request");
  }

  _speak() {
    tts.speak(_inputWords);
  }

  void _updateInputText(
      String text, bool listening, bool finalResult, bool is_done) {
    // if (listening == true) {
    //   setState(() {
    //     allow_toggle = true;
    //   });
    // }

    // if (toggle_mic == true) {
    //   if (listening == false) {
    //     setState(() {
    //       allow_toggle = false;
    //     });
    //
    //     finalResult = true;
    //   }
    // }

    if (is_done) {
      setState(() {
        _mic_on = false;
      });
    }
    setState(() {
      // toggle_mic = allow_toggle;
      // mic_on = !finalResult;
      _is_listening = listening;
      _input.text = text;
      _inputWords = text;
    });
  }
}
