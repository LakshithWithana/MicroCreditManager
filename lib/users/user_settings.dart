import 'package:flutter/material.dart';
import 'package:mcm/services/auth_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/colors.dart';
import '../shared/text.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
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
                  Navigator.pushNamed(context, '/customerProfile');
                },
                icon: const Icon(Icons.person),
                label: CustomTextBox(
                  textValue: "Profile",
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
                  _launchTermsURL();
                },
                icon: const Icon(Icons.gavel),
                label: CustomTextBox(
                  textValue: "Terms & Conditions",
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
                  _launchPrivacyURL();
                },
                icon: const Icon(Icons.lock),
                label: CustomTextBox(
                  textValue: "Privacy Policies",
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
                  Navigator.pop(context);
                  await _authServices.signOut();
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

void _launchTermsURL() async {
  const url = 'https://pages.flycricket.io/mcm-0/terms.html';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launch(url, forceWebView: true, webOnlyWindowName: "Terms");
  } else {
    throw 'Could not launch $url';
  }
}

void _launchPrivacyURL() async {
  const url = 'https://pages.flycricket.io/mcm-0/privacy.html';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launch(url, forceWebView: true, webOnlyWindowName: "Terms");
  } else {
    throw 'Could not launch $url';
  }
}
