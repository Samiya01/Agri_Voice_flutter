import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class FarmerAnimation extends StatefulWidget {
  const FarmerAnimation({Key? key}) : super(key: key);

  @override
  State<FarmerAnimation> createState() => _FarmerAnimationState();
}

class _FarmerAnimationState extends State<FarmerAnimation> {
  @override
  Widget build(BuildContext context) {
    void _onStateChange(
        String stateMachineName,
        String stateName,
        ) =>print("State machine : ${stateMachineName} \n State name: ${stateName}");

    void _onRiveInit(Artboard artboard) {
      final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1',onStateChange: _onStateChange);
      artboard.addController(controller!);
    }
    return Container(
        height: 350,
        width: 160,
        child: RiveAnimation.asset(
          "assets/rive/farmer.riv",
          fit: BoxFit.fitHeight,
          onInit: _onRiveInit,
        ));
  }
}
