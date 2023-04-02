import 'package:agri_voice/services/network_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../controllers/imageController.dart';
import '../values.dart';
import '../widgets/chatBox.dart';

class SmsPage extends StatefulWidget {
  const SmsPage({Key? key}) : super(key: key);

  @override
  State<SmsPage> createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
  final _inputController = TextEditingController();
  TextToSpeech tts = TextToSpeech();
  String _outputWords = "";
  bool _speechMode = true;
  bool _hasImages = false;
  bool _showViewImageButton = false;
  List<String> commands = [];
  bool _canGetImages = false;

  String? _finalQuery;

  int _langSwitcher = 0;

  late FlutterTts flutterTts;

  Stream<List<int>>? stream;
  List? _chat;
  ScrollController _chatController = ScrollController();

  initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.awaitSpeakCompletion(true);
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title:  FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(_langSwitcher==0?"Send a message":"एक संदेश भेजो",
                  style: TextStyle(color: smsColor2)),
            ),
            backgroundColor: mainBg,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: smsColor2,
              ),
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [IconButton(onPressed: _toggleSpeechMode, icon: Icon(_speechMode?Icons.volume_up_rounded:Icons.volume_off_rounded,color: smsColor2,), )],
          ),

          body: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
            ),
            child: Stack(
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Flexible(
                    child: SingleChildScrollView(
                      controller: _chatController,
                      physics: BouncingScrollPhysics(),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          reverse: false,
                          padding: EdgeInsets.only(bottom: 130),
                          itemCount: _chat!.length,
                          itemBuilder: (context, index) {
                            return _chat![index];
                          }),
                    ),
                  ),
                ]),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                        color: smsInputBg,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  enableInteractiveSelection: true,
                                  style: const TextStyle(color: smsColor2),
                                  // keyboardType: TextInputType.multiline,
                                  // maxLines: 1,
                                  controller: _inputController,
                                  cursorColor: smsColor2,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: smsColor2, width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: smsColor1, width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onTap: _scrollDown,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: smsColor2,
                                  size: 30,
                                ),
                                onPressed: _sendRequest,
                              )
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
                                      smsLangColor2,
                                      smsLangColor1,
                                    ],
                                  ),
                                  LinearGradient(
                                    colors: [
                                      smsLangColor1,
                                      smsLangColor2,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sendRequest() async {
    _scrollDown();
    await flutterTts.stop();
    var input = _inputController.text.trim();
    if (input.length == 0) {
      return;
    }
    _canGetImages = false;
    addToChat(isFarmer: true, text: input);

    var endText = _langSwitcher == 0 ? surfixTextEnglish : surfixTextHindi;
    _finalQuery = _finalQuery! + '\n\n${input}' + endText!;
    var data = {"query": _finalQuery};
    setState(() {
      _inputController.text = '';
    });

    var result = await NetworkService().dioPostRequest(data: data, endpointUrl: endpointUrl);
    if(!result['error']){
      _outputWords = result['message']
          .split(_langSwitcher == 0 ? '${farmerNameEng}:' : '${farmerNameInd}:')
          .first;
      addToChat(isFarmer: false, text: _outputWords);
      _finalQuery = _finalQuery! + _outputWords;
      _speak(_outputWords);
      if(_langSwitcher == 0 ){
        _canGetImages = true;
        _getCommands();
      }
    }

  }

  Future _speak(String words) async {
    _scrollDown();
    if(!_speechMode){
      return;
    }
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(0.9);
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
      _inputController.text = '';
    });
    initiateChat();
  }

  _changeLanguage(int index) async {
    setState(() {
      _langSwitcher = index;
    });
    await flutterTts.stop();
    initiateQuery();
  }

  initiateChat() {
    setState(() {
      _chat = [
        ChatBox(
          isFarmer: false,
          text: _langSwitcher == 0 ? starterTextEng : StarterTextHindi,
          isCall: false,
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
          isCall: false,
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
  _scrollDown() {
    Future.delayed(Duration(seconds: 1)).then((value) {
      _chatController.animateTo(
        _chatController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  _toggleSpeechMode() async {
    await flutterTts.stop();
    setState(() {
      _speechMode = !_speechMode;
    });
  }
}



