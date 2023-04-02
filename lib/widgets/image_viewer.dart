import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';

class ImageViewer extends StatelessWidget {
  String imageUrl;
  Color textColor;
  Color bgColor;
  String caption;
  int imageIndex;

  ImageViewer(
      {Key? key,
      required this.imageUrl,
      required this.textColor,
      required this.bgColor,
      required this.caption,
      required this.imageIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageFade(
          image: NetworkImage(imageUrl),
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.3,
          syncDuration: const Duration(milliseconds: 150),
          // supports most properties of Image:
          alignment: Alignment.center,
          fit: BoxFit.fitWidth,
          // shown behind everything:
          placeholder: Container(
            color: const Color(0xFFCFCDCA),
            alignment: Alignment.center,
            child: const Icon(Icons.photo, color: Colors.white30, size: 10.0),
          ),
          // shows progress while loading an image:
          loadingBuilder: (context, progress, chunkEvent) =>
              Center(child: CircularProgressIndicator(value: progress),),
          // displayed when an error occurs:
          errorBuilder: (context, error) => Container(
            color: const Color(0xFF6F6D6A),
            alignment: Alignment.center,
            child:
                const Icon(Icons.warning, color: Colors.black26, size: 128.0),
          ),
        ),
        Container(
          color:bgColor,
          width: MediaQuery.of(context).size.width * 0.3,
          child: Center(
            child: AutoSizeText(
              imageIndex.toString()+'. '+caption,
              style: TextStyle(color: textColor),
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
          ),
        )
      ],
    );
  }
}
