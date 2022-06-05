import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/custom_text_form_field.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';

class PasswordReset extends StatefulWidget {
  PasswordReset({Key? key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  String error = '';

  _passwordReset() async {
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      setState(() {
        error = "Email successfully sent";
      });
    } catch (e) {
      print(e);
      setState(() {
        error = "Email sending failed!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: accentColor, //change your color here
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.fromLTRB(width * 5.1, height * 1.42, width * 5.1, 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 2),
              CustomTextBox(
                textValue: 'Forgot password?',
                textSize: 10,
                textWeight: FontWeight.bold,
                typeAlign: Alignment.topLeft,
                captionAlign: TextAlign.left,
                textColor: mainFontColor,
              ),
              SizedBox(height: height * 2),
              CustomTextBox(
                textValue:
                    'Enter you Email address, we will send you a link to reset your password.',
                textSize: 6,
                textWeight: FontWeight.normal,
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
                    validator: EmailValidator(errorText: 'Enter your email'),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(" "),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 2),
              CustomTextBox(
                textValue: error,
                textSize: 3,
                textWeight: FontWeight.normal,
                typeAlign: Alignment.center,
                captionAlign: TextAlign.left,
                textColor:
                    error == "Email successfully sent" ? green! : accentColor,
              ),
              SizedBox(height: height * 35),
              PositiveElevatedButton(
                label: 'Send me the link',
                onPressed: () {
                  _passwordReset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
