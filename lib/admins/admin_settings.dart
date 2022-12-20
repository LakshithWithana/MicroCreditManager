import 'package:flutter/material.dart';
import 'package:mcm/services/auth_services.dart';

import '../shared/colors.dart';
import '../shared/text.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  final AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: mainColor),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(width * 5.1, 0, width * 5.1, 0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 2),
              CustomTextBox(
                textValue: 'Settings',
                textSize: 10,
                textWeight: FontWeight.bold,
                typeAlign: Alignment.topLeft,
                captionAlign: TextAlign.left,
                textColor: black,
              ),
              SizedBox(height: height * 2),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/viewProfile');
                },
                icon: const Icon(Icons.person_outlined),
                label: CustomTextBox(
                  textValue: "My Profile",
                  textSize: 5,
                  textWeight: FontWeight.normal,
                  typeAlign: Alignment.topLeft,
                  captionAlign: TextAlign.left,
                  textColor: black,
                ),
              ),
              SizedBox(height: height * 1),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/changePassword');
                },
                icon: const Icon(Icons.password),
                label: CustomTextBox(
                  textValue: "Change Password",
                  textSize: 5,
                  textWeight: FontWeight.normal,
                  typeAlign: Alignment.topLeft,
                  captionAlign: TextAlign.left,
                  textColor: black,
                ),
              ),
              SizedBox(height: height * 1),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/subscription');
                },
                icon: const Icon(Icons.subscriptions),
                label: CustomTextBox(
                  textValue: "Subscription",
                  textSize: 5,
                  textWeight: FontWeight.normal,
                  typeAlign: Alignment.topLeft,
                  captionAlign: TextAlign.left,
                  textColor: black,
                ),
              ),
              SizedBox(height: height * 40),
              TextButton.icon(
                onPressed: () async {
                  await _authServices.signOut();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout),
                label: CustomTextBox(
                  textValue: "Log out",
                  textSize: 5,
                  textWeight: FontWeight.normal,
                  typeAlign: Alignment.topLeft,
                  captionAlign: TextAlign.left,
                  textColor: black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
