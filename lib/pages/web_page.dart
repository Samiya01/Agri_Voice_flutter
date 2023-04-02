import 'package:agri_voice/values.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  const WebPage({Key? key}) : super(key: key);

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    var _key = UniqueKey();
    late WebViewController _controller;
    return SafeArea(
      child: Scaffold(
        backgroundColor: minorBg,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'Web interface',
              style:TextStyle(color: websiteColor2)
            ),
          ),
          backgroundColor: mainBg,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: websiteColor2,
            ),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [],
        ),
        body: Column(
          children: [
            Expanded(
              child: WebView(
                  key: _key,
                  navigationDelegate:
                      (NavigationRequest request) {
                    //Any other url works
                    return NavigationDecision.navigate;
                  },
                  onWebViewCreated:
                      (WebViewController webViewController) {
                    _controller = webViewController;
                    _controller.runJavascript(
                        "window.scrollTo({bottom: 0, behavior: 'smooth'});");
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl:
                  agriVoiceUrl),
            ),
          ],
        ),
      ),
    );
  }
}
