import 'package:flutter/material.dart';

class CenteredMessage extends StatelessWidget {
  const CenteredMessage({
    super.key,
    required this.message,
    this.color = Colors.black,
    this.fontSize = 16,
  });

  final String message;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: fontSize),
        ),
      ),
    );
  }
}
