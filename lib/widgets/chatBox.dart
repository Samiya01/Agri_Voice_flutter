import 'package:agri_voice/controllers/imageController.dart';
import 'package:agri_voice/values.dart';
import 'package:agri_voice/widgets/image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_fade/image_fade.dart';
import 'package:lottie/lottie.dart';

class ChatBox extends StatefulWidget {
  bool isFarmer;
  String text;
  bool isCall;
  bool showFeedback;
  bool isEnglish;
  VoidCallback? generateImages;
  List<String> imageUrls;
  List<String> imageCaptions;
  bool isLoadingImages;

  ChatBox(
      {Key? key,
      required this.isFarmer,
      required this.text,
      required this.isCall,
      required this.isEnglish,
      this.showFeedback = false,
      this.imageUrls = const [],
      this.imageCaptions = const [],
      this.isLoadingImages = false,
      this.generateImages = null})
      : super(key: key);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  bool? isLiked;
  bool showImageGenerator = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double chatBorderRadius = 15;
    String text = widget.isEnglish ? "Was this helpful?" : "क्या ये सहायक था?";
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            widget.isFarmer ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: widget.isFarmer
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.isFarmer
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Image.asset(
                        "assets/images/agriVoiceLogo.png",
                        height: 30,
                        width: 30,
                      ),
                    ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                          widget.isFarmer ? 0 : chatBorderRadius),
                      topLeft: Radius.circular(
                          widget.isFarmer ? chatBorderRadius : 0),
                      bottomRight: Radius.circular(chatBorderRadius),
                      bottomLeft: Radius.circular(chatBorderRadius)),
                  color: widget.isFarmer
                      ? widget.isCall
                          ? callColor2
                          : smsColor2
                      : widget.isCall
                          ? callResponseBg
                          : smsResponseBg,
                ),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.55),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SelectableText(
                    widget.text.trim(),
                    style: TextStyle(
                        color: widget.isFarmer
                            ? mainBg
                            : widget.isCall
                                ? callColor2
                                : smsColor2),
                  ),
                ),
              ),
              widget.generateImages == null || widget.isFarmer
                  ? Container()
                  : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: InkWell(
                          onTap: widget.generateImages,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius:BorderRadius.circular(5),
                                    border:Border.all(color: feedbackColor)
                              ),
                              // child: Text(
                              //   'view\nimage\ndescription',
                              //   style: TextStyle(color: feedbackColor,fontSize: 15),
                              //   textAlign: TextAlign.center,
                              // ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Icon(FontAwesomeIcons.image, color: feedbackColor,),
                                ),
                                Text('View Solution\nImages',style: TextStyle(color: feedbackColor,fontSize: 12,),textAlign: TextAlign.center,)
                              ],
                            ),
                            ),
                        ),
                      ),
                    ],
                  )
              // IconButton(
              //         onPressed: widget.generateImages,
              //         icon: Icon(
              //           FontAwesomeIcons.images,
              //           color: feedbackColor,
              //         ))
            ],
          ),
          widget.showFeedback
              ? Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        text,
                        style: TextStyle(fontSize: 10, color: feedbackColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: _like,
                          child: isLiked == true
                              ? Icon(
                                  FontAwesomeIcons.solidFaceSmileBeam,
                                  color: feedbackLikedColor,
                                  size: 30,
                                )
                              : Icon(
                                  FontAwesomeIcons.faceSmile,
                                  color: feedbackColor,
                                  size: 30,
                                )),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: _disLike,
                        child: isLiked == false
                            ? Icon(
                                FontAwesomeIcons.solidFaceFrownOpen,
                                color: feedbackDislikedColor,
                                size: 30,
                              )
                            : Icon(
                                FontAwesomeIcons.faceFrown,
                                color: feedbackColor,
                                size: 30,
                              ),
                      )
                    ],
                  ),
                )
              : Container(),
          widget.imageUrls.length == 0 || widget.isFarmer
              ? Container()
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.imageUrls.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.9),
                  itemBuilder: (BuildContext context, int index) {
                    return ImageViewer(
                        imageUrl: widget.imageUrls[index],
                        textColor: widget.isCall ? callColor2 : smsColor2,
                        bgColor: widget.isCall ? callResponseBg : smsResponseBg,
                        caption: widget.imageCaptions[index],
                        imageIndex: index + 1);
                  },
                ),
          widget.isLoadingImages && !widget.isFarmer
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'This might take a minute. Please wait...',
                            style: TextStyle(
                                color: widget.isCall ? callColor2 : smsColor2),
                          ),
                        ],
                      ),
                      Lottie.asset('assets/lottie/loadingImage.json',
                          width: MediaQuery.of(context).size.width * 0.3)
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  _like() {
    setState(() {
      isLiked = true;
    });
  }

  _disLike() {
    setState(() {
      isLiked = false;
    });
  }
}
