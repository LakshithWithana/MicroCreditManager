import 'package:flutter/material.dart';
import 'package:mcm/authentication/log_in.dart';
import 'package:mcm/authentication/sign_up.dart';

class Authentication extends StatefulWidget {
  Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool? showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn!;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn!) {
      return LogIn(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}
