import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  final String textValue;
  final Alignment typeAlign;
  final double textSize;
  final FontWeight textWeight;
  final TextAlign captionAlign;
  final Color textColor;

  CustomTextBox({
    required this.textValue,
    required this.textSize,
    required this.textWeight,
    required this.typeAlign,
    required this.captionAlign,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    return Align(
      alignment: typeAlign,
      child: Text(
        textValue,
        textAlign: captionAlign,
        style: TextStyle(
          fontWeight: textWeight,
          fontSize: textSize * screenSize / 100,
          color: textColor,
        ),
      ),
    );
  }
}
