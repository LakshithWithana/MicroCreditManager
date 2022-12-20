import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/custom_checkbox.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/custom_text_form_field.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

import '../services/revenuecat.dart';

class AddAgent extends StatefulWidget {
  const AddAgent({Key? key}) : super(key: key);

  @override
  State<AddAgent> createState() => _AddAgentState();
}

class _AddAgentState extends State<AddAgent> {
  final _formKey = GlobalKey<FormState>();
  String? error = "";
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final nicNumberController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  String? agentId = "";
  String? fbPassword = "";

  bool? viewCustomer = false;
  bool? viewAgent = false;
  bool? deposits = false;
  bool? newLoans = false;
  bool? expenses = false;
  bool? accounts = false;
  bool? statistics = false;
  bool? downloads = false;

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  bool? loading = false;
  String? randomPin = "";

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatter.format(now);

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);

    final entitlement = Provider.of<RevenuecatProvider>(context).entitlement;

    /// random pin generator
    String? randomPinGenerator() {
      var rng = Random();
      int randomNumber = rng.nextInt(99999) + 99999;
      return randomNumber.toString();
    }

    /// agent id creation
    String? agentIdGenerator(String? adminId, int? accountCount) {
      String? agentId =
          "${adminId!.split('A').first}AGT${adminId.split('M').last.split('-').first}-${accountCount!}-${(DateTime.now().millisecondsSinceEpoch).toString().substring(8)}";
      return agentId;
    }

    // sendEmail({email, String? randomPassword, String? role}) async {
    //   String username = 'mcmmailing@gmail.com';
    //   String password = 'TeSt1234';

    //   // final smtpServer = gmail(username, password);
    //   // Use the SmtpServer class to configure an SMTP server:
    //   final smtpServer =
    //       SmtpServer('smtp.gmail.com', username: username, password: password);
    //   // See the named arguments of SmtpServer for further configuration
    //   // options.

    //   // Create our message.
    //   final message = Message()
    //     ..from = Address(username, 'Micro Credit Manager')
    //     ..recipients.add(email)
    //     ..subject = 'New Account Created'
    //     ..text = 'Your $role profile was created successtully.'
    //     ..html =
    //         "<h1>Successfully Created Your $role Profile</h1>\n<p>Your login password is.</p>\n<h3>$randomPassword</h3>\n<p>Please change the password when you log in.</p>";

    //   try {
    //     setState(() {
    //       error = '';
    //       fbPassword = randomPassword!;
    //     });
    //     final sendReport = await send(message, smtpServer);
    //     print('Message sent: $sendReport');
    //   } on MailerException catch (e) {
    //     print('Message not sent.');

    //     for (var p in e.problems) {
    //       print('Problem: ${p.code}: ${p.msg}');
    //     }
    //   }
    //   print(randomPassword);
    // }

    return StreamBuilder<UserDetails>(
        stream: DatabaseServices(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;

            return Scaffold(
              backgroundColor: white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: mainColor),
                elevation: 0.0,
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(width * 5.1, 0, width * 5.1, 0.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: height * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextBox(
                              textValue: 'Add Agent',
                              textSize: 10,
                              textWeight: FontWeight.bold,
                              typeAlign: Alignment.topLeft,
                              captionAlign: TextAlign.left,
                              textColor: black,
                            ),
                          ],
                        ),
                        SizedBox(height: height * 2),
                        Column(
                          children: [
                            CustomTextFormField(
                              label: 'First Name',
                              controller: firstNameController,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter first name' : null,
                            ),
                            SizedBox(height: height * 2),
                            Column(
                              children: [
                                CustomTextFormField(
                                  label: 'Last Name',
                                  controller: lastNameController,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter last name' : null,
                                ),
                              ],
                            ),
                            SizedBox(height: height * 2),
                            Column(
                              children: [
                                CustomTextFormField(
                                  label: 'Government ID/Passport',
                                  controller: nicNumberController,
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter ID/Passport number'
                                      : null,
                                ),
                              ],
                            ),
                            SizedBox(height: height * 2),
                            Column(
                              children: [
                                CustomTextFormField(
                                  label: 'Phone number',
                                  controller: phoneNumberController,
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter phone number'
                                      : null,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height * 2),
                            Column(
                              children: [
                                CustomTextFormField(
                                  label: 'Email',
                                  controller: emailController,
                                  validator: EmailValidator(
                                      errorText: 'Enter a valid Email'),
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
                              textValue: 'Agent Powers',
                              textSize: 6,
                              textWeight: FontWeight.bold,
                              typeAlign: Alignment.topLeft,
                              captionAlign: TextAlign.left,
                              textColor: mainColor,
                            ),
                            SizedBox(height: height * 2),
                            CustomCheckBox(
                              textField: 'Add Customers',
                              initValue: viewCustomer,
                              onChanged: (value) {
                                setState(() {
                                  viewCustomer = value;
                                });
                              },
                            ),
                            CustomCheckBox(
                              textField: 'View Deposits',
                              initValue: deposits,
                              onChanged: (value) {
                                setState(() {
                                  deposits = value;
                                });
                              },
                            ),
                            CustomCheckBox(
                              textField: 'Accept Loans',
                              initValue: newLoans,
                              onChanged: (value) {
                                setState(() {
                                  newLoans = value;
                                });
                              },
                            ),
                            CustomCheckBox(
                              textField: 'View Expenses',
                              initValue: expenses,
                              onChanged: (value) {
                                setState(() {
                                  expenses = value;
                                });
                              },
                            ),
                            CustomCheckBox(
                              textField: 'View Accounts',
                              initValue: accounts,
                              onChanged: (value) {
                                setState(() {
                                  accounts = value;
                                });
                              },
                            ),
                            CustomCheckBox(
                              textField: 'View Statistics',
                              initValue: statistics,
                              onChanged: (value) {
                                setState(() {
                                  statistics = value;
                                });
                              },
                            ),
                            CustomCheckBox(
                              textField: 'Downloads',
                              initValue: downloads,
                              onChanged: (value) {
                                setState(() {
                                  downloads = value;
                                });
                              },
                            ),
                            SizedBox(height: height * 1),
                            CustomTextBox(
                              textValue: error!,
                              textSize: 3.5,
                              textWeight: FontWeight.bold,
                              typeAlign: Alignment.center,
                              captionAlign: TextAlign.left,
                              textColor: accentColor,
                            ),
                            SizedBox(height: height * 8),
                            // PositiveElevatedButton(
                            //   label: "test",
                            //   onPressed: () {
                            //     print(agentIdGenerator(userDetails!.userId, 7));
                            //   },
                            // ),
                            loading == true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: secondaryColor,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          mainColor),
                                    ),
                                  )
                                : PositiveElevatedButton(
                                    label: 'Create Agent Profile',
                                    onPressed: entitlement ==
                                                Entitlement.free &&
                                            userDetails!.totalAgents! >= 1
                                        ? () async {
                                            setState(() {
                                              loading = true;
                                              // randomPin = randomPinGenerator();
                                              agentId = agentIdGenerator(
                                                  userDetails.userId,
                                                  userDetails.totalAgents! + 1);
                                            });
                                            // await agentIdsCollection
                                            //     .get()
                                            //     .then((value) {
                                            //   setState(() {
                                            //     agentId = agentIdGenerator(
                                            //         userDetails!.userId, value.size);
                                            //   });
                                            // });
                                            agentIdsCollection
                                                .where('id', isEqualTo: agentId)
                                                .get()
                                                .then((value) async {
                                              if (value.docs.isEmpty) {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  // await sendEmail(
                                                  //     email:
                                                  //         emailController.text,
                                                  //     randomPassword:
                                                  //         randomPinGenerator(),
                                                  //     role: "Agent");

                                                  await agentRequestsCollection
                                                      .doc()
                                                      .set({
                                                    'userId': agentId,
                                                    'email':
                                                        emailController.text,
                                                    'firstName':
                                                        firstNameController
                                                            .text,
                                                    'lastName':
                                                        lastNameController.text,
                                                    'nicNumber':
                                                        nicNumberController
                                                            .text,
                                                    'companyName':
                                                        userDetails.companyName,
                                                    'password': fbPassword,
                                                    'companyTelNo':
                                                        phoneNumberController
                                                            .text,
                                                    'currency':
                                                        userDetails.currency,
                                                    // 'createdDate': formattedDate,
                                                    'viewAgent': false,
                                                    'viewCustomer':
                                                        viewCustomer,
                                                    'deposits': deposits,
                                                    'newLoans': newLoans,
                                                    'expenses': expenses,
                                                    'accounts': accounts,
                                                    'statistics': statistics,
                                                    'downloads': downloads,
                                                  });

                                                  await agentIdsCollection
                                                      .doc()
                                                      .set({
                                                    'id': agentId,
                                                  });
                                                  usersCollection
                                                      .doc(user.uid)
                                                      .update({
                                                    'totalAgents': userDetails
                                                            .totalAgents! +
                                                        1,
                                                  });

                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  Navigator.pop(context);
                                                } else {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  loading = false;
                                                  error = "Please try again.";
                                                });
                                              }
                                            });
                                          }
                                        : () {
                                            showAlertDialog(context);
                                          },
                                  ),
                            SizedBox(height: height * 2),
                          ],
                        ),
                        SizedBox(height: height * 2),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Ok"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Maximum Agent Count Reached"),
    content: const Text(
        "To add more Agents into your business buy the Subscription plan."),
    actions: [
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
