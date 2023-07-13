import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final double? size;
  const Barrier({this.size, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
          color: Colors.green, border: Border.all(width: 10, color: Colors.greenAccent), borderRadius: BorderRadius.circular(20)),
    );
  }
}
