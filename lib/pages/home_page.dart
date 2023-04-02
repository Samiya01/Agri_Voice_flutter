import 'package:agri_voice/widgets/decorBuble.dart';
import 'package:agri_voice/widgets/decorCircleDrawer.dart';
import 'package:agri_voice/widgets/farmer_animation.dart';
import 'package:agri_voice/widgets/gradient_icon.dart';
import 'package:agri_voice/pages/call_page.dart';
import 'package:agri_voice/pages/sms_page.dart';
import 'package:agri_voice/pages/web_page.dart';
import 'package:agri_voice/values.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../services/speech_recognition_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: minorBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                height: 350,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(70)),
                  // color: mainFg,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [homeGradColor1, homeGradColor2]),
                  boxShadow: [
                    BoxShadow(
                      color: homeGradShadowColor,
                      blurRadius: 20,
                      offset: Offset(0, 1), // Shadow position
                    ),
                  ],
                ),
              ),
              //DRAFT PAtTERNS
              Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.06,
                  left: 50,
                  height: 70,
                  width: 160,
                  child:
                      DecorCircleDrawer(circleRadius: 3, rows: 4, columns: 12)),
              Positioned(
                  top: 100,
                  right: 50,
                  height: 80,
                  width: 170,
                  child:
                      DecorCircleDrawer(circleRadius: 3, rows: 4, columns: 12)),
              Positioned(
                  top: 160,
                  right: 5,
                  height: 160,
                  width: 120,
                  child:
                      DecorCircleDrawer(circleRadius: 3, rows: 12, columns: 9)),
              //BUBBLES
              Positioned(
                top: 50,
                right: 50,
                child: MyDecorBubble(
                    circleRadius: 130, circleColor: decorBubbleColor2),
              ),
              Positioned(
                top: -40,
                right: 200,
                child: MyDecorBubble(
                    circleRadius: 130, circleColor: decorBubbleColor1),
              ),
              //WORDS
              Positioned(
                  top: 100,
                  left: 40,
                  width: 200,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              child: Image.asset(
                                  "assets/images/agriVoiceLogo.png",
                                  height: MediaQuery.of(context).size.width *
                                      0.12)),
                          Text(" AgriVoice",
                              style: GoogleFonts.acme(
                                  fontSize: 30, color: mainTextColor))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Container(
                                width: 160,
                                child: Text(
                                    "\"Giving solution to every voice in doubt\"",
                                    style: GoogleFonts.acme(
                                        fontSize: 18, color: mainTextColor)))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 55,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              width: 150,
                              child: Text(
                                  "Providing solutions on agriculture problems powered by Artificial Intelligence",
                                  style: GoogleFonts.actor(
                                      fontSize: 12, color: mainTextColor)),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              //FARMER
              Positioned(
                  bottom: 1,
                  right: 20,
                child: FarmerAnimation(),
                  // child: Container(
                  //     child: Image.asset("assets/images/farmer2.png",
                  //         height: MediaQuery.of(context).size.height * 0.4))
            )
            ],
          ),
          SizedBox(height: 20,),
          InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CallPage()));
              },
              child: _optionCard(
                  icon: Icons.call,
                  title: "Make a Call\nफोन करें",
                  subTitle:
                      // "Tap here to get solutions fast by submitting your problem through voice",
                  "",
                  color1: callColor1,
                  color2: callColor2)),
          InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SmsPage()));
              },
              child: _optionCard(
                  icon: Icons.sms_outlined,
                  title: "Send a Message\nएक संदेश भेजो",
                  subTitle:
                      // "Tap here to get solutions by typing your problem in a search box",
                  "",
                  color1: smsColor1,
                  color2: smsColor2)),
          InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const WebPage()));
              },
              child: _optionCard(
                  icon: Icons.open_in_browser,
                  title: "Visit website\nबेवसाइट देखना",
                  subTitle:
                      // "Tap here to visit AgriVoice web interface for solutions",
                  "",
                  color1: websiteColor1,
                  color2: websiteColor2)),
          // InkWell(
          //     highlightColor: Colors.transparent,
          //     splashColor: Colors.transparent,
          //     onTap: () {
          //       Navigator.of(context).push(
          //           MaterialPageRoute(builder: (context) => const WebPage()));
          //     },
          //     child: _optionCard(
          //         icon: Icons.camera,
          //         title: "Scan crop\nस्कैन फसल",
          //         subTitle:
          //         // "Tap here to visit AgriVoice web interface for solutions",
          //         "",
          //         color1: scanColor1,
          //         color2: scanColor2)),
        ],
      ),
    );
  }

  Widget _optionCard(
      {required IconData icon,
      required String title,
      required String subTitle,
      required Color color1,
      required Color color2}) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
            // border: Border.all(color: LightColors.mainColor, width: 0.1),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(35),
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)),
            color: cardBg,
            boxShadow: [
              BoxShadow(
                color: color1,
                blurRadius: 3,
                offset: Offset(3, 3), // Shadow position
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // GradientIcon(icon, 50, iconGradient),
                  Container(
                    decoration: BoxDecoration(
                        color: color1, borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        icon,
                        color: color2,
                        size: 40,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: color2,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        // Container(
                        //   width: 160,
                        //   child: Text(
                        //     subTitle,
                        //     style: TextStyle(color: color2, fontSize: 11),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color2,
                size: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
