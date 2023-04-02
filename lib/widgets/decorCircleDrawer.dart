import 'package:agri_voice/widgets/decorCircle.dart';
import 'package:flutter/material.dart';

class DecorCircleDrawer extends StatelessWidget {
  double circleRadius;
  int rows, columns;

  DecorCircleDrawer(
      {Key? key,
      required this.circleRadius,
      required this.rows,
      required this.columns})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: rows*columns,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
        ),
        itemBuilder: (BuildContext context, int index){
          return MyDecorCircle(circleRadius: circleRadius);
        },
      ),
    );
    // return Row(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     ListView.builder(
    //         scrollDirection: Axis.horizontal,
    //         // primary: false,
    //         shrinkWrap: true,
    //         itemCount: rows,
    //         itemBuilder: (context,index){
    //     return Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         ListView.builder(
    //           itemCount:columns,
    //           itemBuilder: (context,index) {
    //             return MyDecorCircle(circleRadius: 4,space: 15,);
    //           }
    //         ),
    //       ],
    //     );
    //     }),
    //   ],
    // );
  }
}
