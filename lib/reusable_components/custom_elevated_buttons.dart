import 'package:flutter/material.dart';
import 'package:mcm/shared/colors.dart';

/// Positive custom elevated button
class PositiveElevatedButton extends StatelessWidget {
  const PositiveElevatedButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  //define properties
  final String? label;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size; // getting screen size
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        width: screensize.width * 0.9,
        height: screensize.height * 0.07,
        child: Center(
          child: Text(
            label!,
            style: TextStyle(
              fontSize: screensize.width * 0.06,
              fontWeight: FontWeight.bold,
              color: white,
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: mainColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: mainColor, width: 3.0),
          borderRadius:
              BorderRadius.all(Radius.circular(screensize.width * 0.02)),
        ),
      ),
    );
  }
}

/// Positive half custom elevated button
class PositiveHalfElevatedButton extends StatelessWidget {
  const PositiveHalfElevatedButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  //define properties
  final String? label;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size; // getting screen size
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        width: screensize.width * 0.2,
        height: screensize.height * 0.04,
        child: Center(
          child: Text(
            label!,
            style: TextStyle(
              fontSize: screensize.width * 0.04,
              fontWeight: FontWeight.normal,
              color: white,
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: mainColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: mainColor, width: 1.0),
          borderRadius:
              BorderRadius.all(Radius.circular(screensize.width * 0.01)),
        ),
      ),
    );
  }
}

/// Negative custom elevated button
class NegativeElevatedButton extends StatelessWidget {
  const NegativeElevatedButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  //define properties
  final String? label;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size; // getting screen size
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        width: screensize.width * 0.9,
        height: screensize.height * 0.07,
        child: Center(
          child: Text(
            label!,
            style: TextStyle(
              fontSize: screensize.width * 0.06,
              color: mainColor,
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: mainColor, width: 3.0),
          borderRadius:
              BorderRadius.all(Radius.circular(screensize.width * 0.03)),
        ),
      ),
    );
  }
}

/// Negative half custom elevated button
class NegativeHalfElevatedButton extends StatelessWidget {
  const NegativeHalfElevatedButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  //define properties
  final String? label;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size; // getting screen size
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        width: screensize.width * 0.2,
        height: screensize.height * 0.04,
        child: Center(
          child: Text(
            label!,
            style: TextStyle(
              fontSize: screensize.width * 0.04,
              color: mainColor,
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: mainColor, width: 1.0),
          borderRadius:
              BorderRadius.all(Radius.circular(screensize.width * 0.01)),
        ),
      ),
    );
  }
}

/// Special custom elevated button
class SpecialElevatedButton extends StatelessWidget {
  const SpecialElevatedButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  //define properties
  final String? label;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size; // getting screen size
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        width: screensize.width * 0.9,
        height: screensize.height * 0.07,
        child: Center(
          child: Text(
            label!,
            style: TextStyle(
              fontSize: screensize.width * 0.06,
              color: white,
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: linkColor,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(screensize.width * 0.01)),
        ),
      ),
    );
  }
}
