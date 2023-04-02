import 'package:flutter/material.dart';

const Color mainBg = Color.fromARGB(255, 250, 250, 248);
const Color mainTextColor = Color.fromARGB(255, 246, 246, 240);
const Color minorBg = Color.fromARGB(255, 224, 222, 210);
const Color mainFg = Color.fromARGB(255, 178, 116, 31);
const Color mainDark = Color.fromARGB(255, 33, 29, 16);

const Color cardBg = Color.fromARGB(255, 243, 243, 236);

const Color iconColor1 = Color.fromARGB(255, 222, 203, 179);
const Color iconColor2 = Color.fromARGB(255, 178, 116, 31);

const Color homeGradColor1 = Color.fromARGB(255, 243, 188, 109);
const Color homeGradColor2 = Color.fromARGB(255, 248, 171, 20);
const Color homeGradShadowColor = Color.fromARGB(168, 157, 71, 24);
// const Color homeGradShadowColor = Color.fromARGB(168, 199, 67, 26);

const Color decorCircleColor = Color.fromARGB(255, 243, 184, 97);
const Color decorBubbleColor1 = Color.fromARGB(31, 255, 255, 255);
const Color decorBubbleColor2 = Color.fromARGB(37, 255, 255, 255);

//call colors
const Color callResponseBg = Color.fromARGB(124, 250, 230, 191);
const Color callColor1 = Color.fromARGB(255, 250, 230, 191);
const Color callColor2 = Color.fromARGB(168, 136, 57, 14);
const Color callStartColor = Color.fromARGB(255, 80, 105, 84);
const Color callStopColor = Color.fromARGB(168, 147, 23, 23);
const Color micColor = Color.fromARGB(226, 255, 255, 255);
const Color callLangColor1 = Color.fromARGB(255, 208, 146, 24);
const Color callLangColor2 = Color.fromARGB(168, 136, 57, 14);

//message colors
const Color smsInputBg = Color.fromARGB(255, 234, 234, 248);
const Color smsResponseBg = Color.fromARGB(145, 213, 212, 250);
const Color smsColor1 = Color.fromARGB(255, 213, 212, 250);
const Color smsColor2 = Color.fromARGB(168, 59, 18, 129);
const Color smsLangColor1 = Color.fromARGB(168, 123, 88, 162);
const Color smsLangColor2 = Color.fromARGB(168, 33, 1, 54);

//website colors
const Color websiteColor1 = Color.fromARGB(255, 214, 248, 164);
const Color websiteColor2 = Color.fromARGB(168, 8, 108, 13);

//scan colors
const Color scanColor1 = Color.fromARGB(255, 164, 248, 235);
const Color scanColor2 = Color.fromARGB(168, 5, 100, 82);

//chat feedback colors
const Color feedbackColor = Color.fromARGB(168, 101, 100, 100);
const Color feedbackLikedColor = Color.fromARGB(168, 9, 136, 9);
const Color feedbackDislikedColor = Color.fromARGB(168, 159, 20, 20);

const String prefixTextHindi = "निम्नलिखित एआई-बॉट और एक किसान के बीच बातचीत है। एआई-बॉट का उद्देश्य किसानों को कृषि विषयों के बारे में सलाह देने में मदद करना है। उपयोग की जाने वाली भाषा केवल हिंदी है।\nयदि किसान किसी अन्य विषय के बारे में बात करता है जो कृषि या भूगोल या कृषि विज्ञान से संबंधित नहीं है, तो एआई-बॉट एक संदेश के साथ प्रतिक्रिया करता है।: '${errorMessageHindi}'\n\n${farmerNameInd}: नमस्ते\n\n${aiNameInd}: नमस्ते, मैं आज आपकी सहायता कैसे करूं?\n\n${farmerNameInd}: ";
const String prefixTextEnglish = "The following is a conversation between an ${aiNameEng} and a ${farmerNameEng}. The purpose of the ${aiNameEng} is to help to provide advice to ${farmerNameEng}s about agriculture topics.\nThe language used is english only\nIf the ${farmerNameEng} talks about any other topic that is not related to agriculture or geography or agriculture science, the ${aiNameEng} responds with a message: '${errorMessageEng}'\n\n ${farmerNameEng}: Hello\n\n${aiNameEng}: Hello, how can I help you today?\n\n${farmerNameEng}:";
const String starterTextEng = "Hello there 👋. How may I help you today?";
const String StarterTextHindi = "नमस्ते. आज मैं आपकी कैसे मदद कर सकता हूँ?";
const String aiNameEng = "AI-bot";
const String aiNameInd = "एआई-बॉट";
const String farmerNameEng = "Farmer";
const String farmerNameInd = "किसान";
const String surfixTextEnglish = "\n\n${aiNameEng}: ";
const String surfixTextHindi = "\n\n${aiNameInd}: ";
const String errorMessageHindi = "क्षमा करें। मैं केवल कृषि समस्याओं में मदद कर सकता हूं";
const String errorMessageEng = "Sorry. I can only help with agriculture problems";

//ENDPOINT URL
const String endpointUrl = 'https://calm-forest-14149.herokuapp.com/query';
// const String agriVoiceUrl = 'https://calm-forest-14149.herokuapp.com/';
const String agriVoiceUrl = 'https://agrivoice.online/';

//IMAGE VALUES
const String endpointUrlImage = 'https://calm-forest-14149.herokuapp.com/image';
const String imagePrefixExample = "These are tasks given to a classifier that determines weather a statement describes a process that can be used to generate commands for image generator or not. If it can, it will provide commands for the image generator.\n\nTask 1.\nStatement:\nThere are many types of beans, including black beans, kidney beans, lima beans, navy beans, and pinto beans.\nCommands for image generator:\n*image for black beans\n*image for kidney beans\n* image for lime beans\n* image for navy beans\n* images for pinto beans\n\n\nTask 2.\nStatement:\nWhat would you like to know about agriculture?\nCommands for image generator:\n<no commands>\n\n\nTask 3.\nStatement:\nThere are multiple ways to plant corn, including using a drill, planting in hills, or using a no-till method.\nCommands for image generator:\n*Planting maize plant by using drill\n*planting maize plant in hills\n*Planting maize plant using no-till method\n\n\nTask 4.\nStatement:\nWhat would you like me to help you today?\nCommands for image generator:\n<no commands>\n\n\nTask 5.\nStatement:\nSorry, I can only help with agricultural problems\nCommands for image generator:\n<no commands>\n\n\nTask 6.\nStatement:\nIf your sunflower plants are infected, you will need to remove the affected leaves and stems. You may also need to treat the plants with a fungicide.\nCommands for image generator:\n* Removing infected leaves and stems from sunflower plant\n*Treating sunflower plant with a fungicide.\n\n\nTask 7.\nStatement:\nSorry, I can only help with agricultural problems\nCommands for image generator:\n<no commands>\n\n\nTask 8:\nStatement:\nYou must be able to locate the best place to plant your rose flower first before beginning digging.\nCommands for image generator:\n*Finding the best place to plant a rose flower\n*Digging a hole for the rose flower\n\n\nTask 9.\nStatement:\nMy name is Ai-bot. I can help farmers with agriculture problems\nCommands for image generator:\n<no commands>\n\n\nTask 10.\nStatement:\nIs there anything specific you would like me to help you with?\nCommands for image generator:\n<no commands>\n\n\nTask 11.\nStatement:\nIs there anything specific you would like me to ask about?\nCommands for image generator:\n<no commands>\n\n\nTask 12.\nStatement:\n";
const String imageNoCommand = "<no commands>";
const String imageSurfix = "\nCommands for image generator:\n";
const String imageRequireEng = "Do you want image description?";
const String imageRequireHindi = "क्या आप छवि विवरण चाहते हैं?";

