import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final barrierWidth;
  final barrierHeight;
  final barrierX;
  final bool isThisBottomBarrier;
  Barrier({this.barrierHeight, this.barrierWidth, this.barrierX, required this.isThisBottomBarrier, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth), isThisBottomBarrier ? 1 : -1),
      child: Container(
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
        decoration: BoxDecoration(
            color: Colors.green, border: Border.all(width: 5, color: Colors.greenAccent), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
