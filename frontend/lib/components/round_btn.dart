import 'package:flutter/material.dart';

class RoundBtn extends StatelessWidget{
  final String text;
  final Color bgColor;
  final VoidCallback onPressed;
  final Color textColor;

  const RoundBtn({super.key, required this.text, required this.bgColor, required this.onPressed, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 8,),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }

}