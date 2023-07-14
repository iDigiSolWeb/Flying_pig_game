import 'package:flutter/material.dart';

class Bird extends StatelessWidget {
  final birdY;
  final double birdWith;
  final double birdHeight;
  Bird({this.birdY, required this.birdHeight, required this.birdWith, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: Image.asset(
        'assets/images/pngwing.com.png',
        height: MediaQuery.of(context).size.height * birdHeight / 2,
        width: MediaQuery.of(context).size.height * 3 / 4 * birdWith / 2,
        fit: BoxFit.fill,
      ),
    );
  }
}
