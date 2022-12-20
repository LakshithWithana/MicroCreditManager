import 'package:flutter/material.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/services/auth_services.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

import '../reusable_components/custom_elevated_buttons.dart';
import '../reusable_components/custom_text_form_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final AuthServices _authServices = AuthServices();

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  String? error = "";
  String? currentPassword = "";
  String? newPassword = "";
  String? newPasswordConfirm = "";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: mainColor),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(width * 5.1, 0, width * 5.1, 0.0),
        child: Form(
          key: _formKey,
          child: StreamBuilder<UserDetails>(
              stream: DatabaseServices(uid: user!.uid).userDetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserDetails? userDetails = snapshot.data;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 2),
                        CustomTextBox(
                          textValue: 'Change Password',
                          textSize: 10,
                          textWeight: FontWeight.bold,
                          typeAlign: Alignment.topLeft,
                          captionAlign: TextAlign.left,
                          textColor: black,
                        ),
                        SizedBox(height: height * 2),
                        CustomTextFormField(
                          label: 'Current Password',
                          onChanged: (value) {
                            setState(() {
                              currentPassword = value;
                            });
                          },
                          validator: (value) =>
                              value!.isEmpty ? 'Enter current password' : null,
                        ),
                        SizedBox(height: height * 2),
                        CustomTextFormField(
                          label: 'New Password',
                          onChanged: (value) {
                            setState(() {
                              newPassword = value;
                            });
                          },
                          validator: (value) =>
                              value!.isEmpty ? 'Enter new password' : null,
                        ),
                        SizedBox(height: height * 2),
                        CustomTextFormField(
                          label: 'Confirm New Password',
                          onChanged: (value) {
                            setState(() {
                              newPasswordConfirm = value;
                            });
                          },
                          validator: (value) => value != newPassword
                              ? 'Password missmatched'
                              : null,
                        ),
                        SizedBox(height: height * 4),
                        PositiveElevatedButton(
                          label: isLoading == false ? "Change Password" : "...",
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              _authServices
                                  .changePassword(
                                      currentPassword!, newPassword!, user.uid!)
                                  .then((value) {
                                if (value == true) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  const snackBar = SnackBar(
                                    content: Text("Password changed."),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  const snackBar = SnackBar(
                                    content: Text("Error Occured."),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              });
                            }
                          },
                        ),
                        SizedBox(height: height * 10),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}
