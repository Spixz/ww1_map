import 'package:flutter/material.dart';

class DragCorner extends StatelessWidget {
  const DragCorner({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Colors.black;

    return Align(
      alignment: Alignment.bottomRight,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            width: 10,
            height: 27,
            child: Container(color: color),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            width: 27,
            height: 10,
            child: Container(color: color),
          ),
        ],
      ),
    );
  }
}
