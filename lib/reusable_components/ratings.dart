import 'package:flutter/material.dart';

import '../shared/colors.dart';
import '../shared/text.dart';

class Rating extends StatefulWidget {
  Rating({Key? key, this.totalPoints}) : super(key: key);
  final int? totalPoints;

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int? points = 0;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    if (widget.totalPoints! < 10) {
      return Row(children: [
        CustomTextBox(
          textValue: "0.0",
          textSize: 5.0,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        SizedBox(width: width * 5),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
      ]);
    } else if (widget.totalPoints! < 20) {
      return Row(children: [
        CustomTextBox(
          textValue: "0.5",
          textSize: 5.0,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        SizedBox(width: width * 5),
        Icon(Icons.star_half, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
      ]);
    } else if (widget.totalPoints! < 30) {
      return Row(children: [
        CustomTextBox(
          textValue: "1.0",
          textSize: 5.0,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        SizedBox(width: width * 5),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
      ]);
    } else if (widget.totalPoints! < 40) {
      return Row(children: [
        CustomTextBox(
          textValue: "1.5",
          textSize: 5.0,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        SizedBox(width: width * 5),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star_half, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
      ]);
    } else if (widget.totalPoints! < 50) {
      return Row(children: [
        CustomTextBox(
          textValue: "2.0",
          textSize: 5.0,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        SizedBox(width: width * 5),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
      ]);
    } else if (widget.totalPoints! < 60) {
      return Row(children: [
        CustomTextBox(
          textValue: "2.5",
          textSize: 5.0,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        SizedBox(width: width * 5),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star_half, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
      ]);
    } else if (widget.totalPoints! < 70) {
      return Row(children: [
        CustomTextBox(
          textValue: "3.0",
          textSize: 5.0,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        SizedBox(width: width * 5),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
      ]);
    } else if (widget.totalPoints! < 80) {
      return Row(children: [
        CustomTextBox(
          textValue: "3.5",
          textSize: 5.0,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        SizedBox(width: width * 5),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star_half, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
      ]);
    } else if (widget.totalPoints! < 90) {
      return Row(children: [
        CustomTextBox(
          textValue: "4.0",
          textSize: 5.0,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        SizedBox(width: width * 5),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star_outline, color: Colors.yellow.shade700),
      ]);
    } else if (widget.totalPoints! < 100) {
      return Row(children: [
        CustomTextBox(
          textValue: "4.5",
          textSize: 5.0,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        SizedBox(width: width * 5),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star_half, color: Colors.yellow.shade700),
      ]);
    } else {
      return Row(children: [
        CustomTextBox(
          textValue: "5.0",
          textSize: 5.0,
          textWeight: FontWeight.normal,
          typeAlign: Alignment.topLeft,
          captionAlign: TextAlign.left,
          textColor: black,
        ),
        SizedBox(width: width * 5),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
        Icon(Icons.star, color: Colors.yellow.shade700),
      ]);
    }
  }
}
