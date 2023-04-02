import 'dart:async';

import 'package:agri_voice/providers/call_provider.dart';
import 'package:agri_voice/values.dart';
import 'package:agri_voice/widgets/chatBox.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dio/dio.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../controllers/imageController.dart';
import '../services/network_service.dart';
import '../services/speech_recognition_service.dart';

import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mic_stream/mic_stream.dart';

class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  String _inputWords = "";
  String _outputWords = "";
  bool _speechMode = true;
  List<String> commands = [];
  bool _canGetImages = false;

  String? _finalQuery;

  int _langSwitcher = 0;
  bool _listening = false;
  bool _listeningFinished = false;

  late FlutterTts flutterTts;

  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;
  Stream<List<int>>? stream;
  List? _chat;
  ScrollController _chatController = ScrollController();

  void _startListening() async {
    _scrollDown;
    await flutterTts.stop();
    MicStream.shouldRequestPermission(true);

    stream = await MicStream.microphone(
        audioSource: AudioSource.DEFAULT,
        sampleRate: 20000,
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AudioFormat.ENCODING_PCM_16BIT);

    RecognitionConfig _getConfig() => RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.command_and_search,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 20000,
        languageCode: _langSwitcher == 0 ? 'en-IN' : 'hi-IN');

    _audioStream = BehaviorSubject();
    _audioStreamSubscription = stream!.listen((event) {
      _audioStream!.add(event);
    });

    setState(() {
      _listening = true;
    });
    final serviceAccount = ServiceAccount.fromString((await rootBundle
        .loadString('assets/google_cloud/google_cloud_credentials.json')));
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        _audioStream!);

    var responseText = '';

    responseStream.listen((data) {
      final currentText =
          data.results.map((e) => e.alternatives.first.transcript).join('\n');
      if (data.results.first.isFinal) {
        responseText += ' ' + currentText;
        setState(() {
          _inputWords = responseText;
          _listeningFinished = true;
        });
      } else {
        setState(() {
          _inputWords = responseText + '\n' + currentText;
          _listeningFinished = true;
        });
      }
    }, onDone: () {
      setState(() {
        _listening = false;
      });
    });
  }

  void _stopListening() async {
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();

    await flutterTts.stop();
    setState(() {
      _listening = false;
    });
  }

  initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(0.9);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTts();
    initiateQuery();
    initiateChat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _stopListening();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
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
              child: Text(_langSwitcher==0?'Call':'बुलाना', style: TextStyle(color: callColor2)),
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
            actions: [IconButton(onPressed: _toggleSpeechMode, icon: Icon(_speechMode?Icons.volume_up_rounded:Icons.volume_off_rounded,color: callColor2,), )],
            elevation: 1,
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    color: minorBg, borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _inputWords.length == 0
                          ? Container()
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 5, bottom: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _inputWords,
                                          style: TextStyle(color: callColor2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DottedLine(
                                  dashColor: callColor1,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              _listening ? _stopListening() : _startListening();
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: _listening
                                        ? callStopColor
                                        : callStartColor,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Center(
                                    child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                                  child: Icon(
                                      _listening ? Icons.mic : Icons.mic_off,
                                      size: 30,
                                      color: micColor),
                                ))),
                          ),
                          InkWell(
                            onTap: () {
                              if (_listening) {
                                _stopListening();
                              }
                              _sendRequest();
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: mainBg,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Center(
                                    child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                                  child: Icon(Icons.send,
                                      size: 30,
                                      color: callColor2),
                                ))),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SlideSwitcher(
                            children: [
                              Text(
                                'ENGLISH',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: _langSwitcher == 0
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.grey),
                              ),
                              Text(
                                'हिन्दी',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: _langSwitcher == 1
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.grey),
                              ),
                            ],
                            onSelect: (int index) => _changeLanguage(index),
                            containerColor: Colors.transparent,
                            containerBorder: Border.all(color: mainBg),
                            slidersGradients: const [
                              LinearGradient(
                                colors: [
                                  callLangColor2,
                                  callLangColor1,
                                ],
                              ),
                              LinearGradient(
                                colors: [
                                  callLangColor1,
                                  callLangColor2,
                                ],
                              ),
                            ],
                            indents: 3,
                            containerHeight: 45,
                            containerWight: 220,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            elevation: 0,
          ),
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: _chatController,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _chat!.length,
                            itemBuilder: (context, index) {
                              return _chat![index];
                            }),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendRequest() async {
    _scrollDown();
    await flutterTts.stop();
    _inputWords = _inputWords.trim();
    if (_inputWords.length == 0) {
      return;
    }
    _canGetImages = false;
    addToChat(isFarmer: true, text: _inputWords);

    var endText = _langSwitcher == 0 ? surfixTextEnglish : surfixTextHindi;
    _finalQuery = _finalQuery! + '${_inputWords}' + endText!;
    var data = {"query": _finalQuery,"language":_langSwitcher};
    setState(() {
      _inputWords = '';
    });

    var result = await NetworkService().dioPostRequest(data: data, endpointUrl: endpointUrl);
    if(!result['error']){
      _outputWords = result['message']
          .split(_langSwitcher == 0 ? '${farmerNameEng}:' : '${farmerNameInd}:')
          .first;
      addToChat(isFarmer: false, text: _outputWords);
      _finalQuery = _finalQuery! + _outputWords;
      _speak(_outputWords);
      if(_langSwitcher == 0){
        _canGetImages = true;
        _getCommands();
      }
    }
  }

  _toggleSpeechMode() async {
    await flutterTts.stop();
    setState(() {
      _speechMode = !_speechMode;
    });
  }

  Future _speak(String words) async {
    _scrollDown();
    if(!_speechMode){
      return;
    }
    await flutterTts.setLanguage(_langSwitcher == 0 ? 'en-US' : 'hi-IN');

    if (words != null) {
      if (words!.isNotEmpty) {
        await flutterTts.speak(words);
      }
    }
  }

  void initiateQuery() {
    _finalQuery = _langSwitcher == 0 ? prefixTextEnglish : prefixTextHindi;
    setState(() {
      _inputWords = '';
    });
    initiateChat();
  }

  _changeLanguage(int index) async {
    setState(() {
      _langSwitcher = index;
    });
    _stopListening();
    await flutterTts.stop();
    initiateQuery();
  }

  initiateChat() {
    setState(() {
      _chat = [
        ChatBox(
          isFarmer: false,
          text: _langSwitcher == 0 ? starterTextEng : StarterTextHindi,
          isCall: true,
          isEnglish: _langSwitcher == 0,
        ),
      ];
    });
  }

  addToChat({required bool isFarmer, required String text, List<String> imageUrls =const [], List<String> imageCaptions =const [], bool showLoading = false, VoidCallback? generateImages = null}) {
    _scrollDown;
    setState(() {
      _chat!.add(
        ChatBox(
          isFarmer: isFarmer,
          text: text,
          isCall: true,
          showFeedback: !isFarmer,
          isEnglish: _langSwitcher == 0,
          imageUrls: imageUrls,
          generateImages: generateImages,
          isLoadingImages: showLoading,
          imageCaptions: imageCaptions,
        ),
      );
    });
  }

  _scrollDown() {
    Future.delayed(Duration(seconds: 1)).then((value) {
      _chatController.animateTo(
        _chatController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  _getCommands() async{
    var results = await ImageController().getCommands(statement: _outputWords);
    if(results['hasCommands']){
      commands=results['commands'] as List<String>;
      commands.removeAt(0);
      print(commands);
      setState(() {
        _canGetImages?_chat!.removeAt(_chat!.length-1):null;
      });
      addToChat(isFarmer: false, text: _outputWords,generateImages: generateImages);
    }
  }

  generateImages() async {
    print('*** GENERATING IMAGES ***');
    if(!_canGetImages){
      return;
    }
    setState(() {
      _chat!.removeAt(_chat!.length-1);
    });
    addToChat(isFarmer: false, text: _outputWords,showLoading: true);
    _scrollDown();
    List<String> imageUrl = [];

    for(var command in commands){
      imageUrl.add(await ImageController().getImageUrl(command: command));
      if(imageUrl.length==commands.length){
        setState(() {
          _chat!.removeAt(_chat!.length-1);
        });
        addToChat(isFarmer: false, text: _outputWords,imageUrls: imageUrl,imageCaptions: commands);
        _scrollDown();
      }
    }
    // commands.map((command)async{
    //   print('Command is :'+command);
    //   imageUrl.add(await ImageController().getCommands(statement: command).then((value) {
    //     print(value);
    //     if(imageUrl.length==commands.length){
    //       setState(() {
    //         _chat!.removeAt(_chat!.length-1);
    //       });
    //     }
    //   }));
    // });

  }
}


