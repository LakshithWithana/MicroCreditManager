import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/custom_text_form_field.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/auth_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/web_view_page.dart';

class LogIn extends StatefulWidget {
  LogIn({Key? key, this.toggleView}) : super(key: key);
  final Function? toggleView;

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  String? error = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool? loading = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    if (loading == false) {
      return Scaffold(
        backgroundColor: white,
        body: Padding(
          padding:
              EdgeInsets.fromLTRB(width * 5.1, height * 12, width * 5.1, 0.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: height * 2),
                  CustomTextBox(
                    textValue: 'Log in',
                    textSize: 10,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topLeft,
                    captionAlign: TextAlign.left,
                    textColor: mainFontColor,
                  ),
                  SizedBox(height: height * 2),
                  Column(
                    children: [
                      CustomTextFormField(
                        label: 'Email',
                        controller: emailController,
                        validator:
                            EmailValidator(errorText: 'Enter a valid Email'),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp(" "),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 2),
                  Column(
                    children: [
                      CustomTextFormField(
                        label: 'Password',
                        controller: passwordController,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter the password' : null,
                        secure: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp(" "),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: height * 1),
                  CustomTextBox(
                    textValue: error!,
                    textSize: 3.5,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.center,
                    captionAlign: TextAlign.left,
                    textColor: red,
                  ),
                  SizedBox(height: height * 5),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/passwordReset');
                    },
                    child: CustomTextBox(
                      textValue: 'Forgot my password!',
                      textSize: 4,
                      textWeight: FontWeight.normal,
                      typeAlign: Alignment.topLeft,
                      captionAlign: TextAlign.center,
                      textColor: accentColor,
                    ),
                  ),
                  SizedBox(height: height * 2),
                  PositiveElevatedButton(
                    label: 'Log in',
                    onPressed: () async {
                      // Navigator.pushNamed(context, '/needyHome');
                      if (_formKey.currentState!.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);

                        if (result == null) {
                          setState(() {
                            error = 'Can Not Log-in With Those Credentials';
                            loading = false;
                          });
                        }
                      } else {
                        setState(() {
                          error = 'Can Not Log-in With Those Credentials';
                          loading = false;
                        });
                      }
                    },
                  ),
                  SizedBox(height: height * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextBox(
                        textValue: "Don't have an account? Try",
                        textSize: 4,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.center,
                        captionAlign: TextAlign.center,
                        textColor: mainFontColor,
                      ),
                      TextButton(
                        onPressed: () {
                          widget.toggleView!();
                        },
                        child: CustomTextBox(
                          textValue: 'Sign Up',
                          textSize: 4,
                          textWeight: FontWeight.normal,
                          typeAlign: Alignment.topLeft,
                          captionAlign: TextAlign.center,
                          textColor: accentColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('By joining, I agree to '),
                      TextButton(
                        onPressed: () {
                          _launchTermsURL();
                        },
                        child: Text('Terms of Use'),
                      ),
                    ],
                  ),
                  SizedBox(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(' & '),
                      TextButton(
                        onPressed: () {
                          _launchPrivacyURL();
                        },
                        child: Text('Privacy Policy'),
                      ),
                      Text('.'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else
      return Loading();
  }
}

void _launchTermsURL() async {
  const url = 'https://pages.flycricket.io/mcm-0/terms.html';
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true, webOnlyWindowName: "Terms");
  } else {
    throw 'Could not launch $url';
  }
}

void _launchPrivacyURL() async {
  const url = 'https://pages.flycricket.io/mcm-0/privacy.html';
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true, webOnlyWindowName: "Terms");
  } else {
    throw 'Could not launch $url';
  }
}
