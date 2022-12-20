import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mcm/shared/colors.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: const Center(
        child: SpinKitCircle(
          color: mainColor,
          size: 50.0,
        ),
      ),
    );
  }
}
