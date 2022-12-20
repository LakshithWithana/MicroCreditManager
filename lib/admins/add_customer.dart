import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/custom_text_form_field.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key}) : super(key: key);

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _formKey = GlobalKey<FormState>();
  String? error = "";
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final nicNumberController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  String? virtualOrActual = "Real";
  final amountController = TextEditingController();
  String? fbPassword = "";
  String? amount = "0";
  var accountUid = const Uuid();
  String? userId = "";
  String? accountId = "";
  String? adminIdFromAdminProfile = "";

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  bool? loading = false;

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatter.format(now);

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);

    /// random pin generator
    String? randomPinGenerator() {
      var rng = Random();
      int randomNumber = rng.nextInt(99999) + 99999;
      return randomNumber.toString();
    }

    /// random user id generator
    String? randomIdGenerator() {
      var rng = Random();
      int randomNumber = rng.nextInt(9999) + 9999;
      return randomNumber.toString();
    }

    /// random account id generator
    String? randomAccountIdGenerator() {
      var rng = Random();
      int randomNumber = rng.nextInt(99999999) + 99999999;
      return randomNumber.toString();
    }

    sendEmail({email, String? randomPassword, String? role}) async {
      String username = 'mcmmailing@gmail.com';
      String password = 'TeSt1234';

      // final smtpServer = gmail(username, password);
      // Use the SmtpServer class to configure an SMTP server:
      final smtpServer =
          SmtpServer('smtp.gmail.com', username: username, password: password);
      // See the named arguments of SmtpServer for further configuration
      // options.

      // Create our message.
      final message = Message()
        ..from = Address(username, 'Micro Credit Manager')
        ..recipients.add(email)
        ..subject = 'New Account Created'
        ..text = 'Your $role profile was created successtully.'
        ..html =
            "<h1>Successfully Created Your $role Profile</h1>\n<p>Your login password is.</p>\n<h3>$randomPassword</h3>\n<p>Please change the password when you log in.</p>";

      try {
        setState(() {
          error = '';
          fbPassword = randomPassword!;
        });
        final sendReport = await send(message, smtpServer);
        print('Message sent: $sendReport');
      } on MailerException catch (e) {
        print('Message not sent.');

        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      print(randomPassword);
      // return randomPassword;
    }

    /// customer id creation
    String? customerIdGenerator(String? adminId, int? accountCount) {
      String? customerId =
          "${adminId!.split('A').first}CST${adminId.split('M').last.split('-').first}-${accountCount!}-${(DateTime.now().millisecondsSinceEpoch).toString().substring(8)}";
      return customerId;
    }

    setSearchParam(String customerID) {
      List<String> customerSearchList = [];
      String temp = "";
      for (int i = 0; i < customerID.length; i++) {
        temp = temp + customerID[i];
        customerSearchList.add(temp);
      }
      return customerSearchList;
    }

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
                              textValue: 'Add Customer',
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
                            // Column(
                            //   children: [
                            //     CustomTextBox(
                            //       textValue: 'Real / Virtual',
                            //       textSize: 4,
                            //       textWeight: FontWeight.normal,
                            //       typeAlign: Alignment.topLeft,
                            //       captionAlign: TextAlign.left,
                            //       textColor: black,
                            //     ),
                            //     SizedBox(height: height * 0.5),
                            //     Container(
                            //       width: width * 90,
                            //       height: height * 6.5,
                            //       decoration: BoxDecoration(
                            //         color: backgroundColor,
                            //         borderRadius:
                            //             BorderRadius.circular(width * 3),
                            //       ),
                            //       child: Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal: 16.0, vertical: 8.0),
                            //         child: DropdownButton<String?>(
                            //           value: virtualOrActual,
                            //           icon: const Icon(
                            //             Icons.keyboard_arrow_down,
                            //             color: mainColor,
                            //           ),
                            //           iconSize: width * 9,
                            //           isExpanded: true,
                            //           elevation: 16,
                            //           style: const TextStyle(color: black),
                            //           underline: Container(),
                            //           onChanged: (String? newValue) {
                            //             setState(() {
                            //               virtualOrActual = newValue!;
                            //             });
                            //           },
                            //           items: <String>[
                            //             'Real',
                            //             'Virtual',
                            //           ].map<DropdownMenuItem<String>>(
                            //               (String value) {
                            //             return DropdownMenuItem<String>(
                            //               value: value,
                            //               child: Text(
                            //                 value,
                            //                 style: TextStyle(
                            //                   fontSize: width * 5,
                            //                 ),
                            //               ),
                            //             );
                            //           }).toList(),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // virtualOrActual == "Virtual"
                            //     ? Column(
                            //         children: [
                            //           SizedBox(height: height * 4),
                            //           Column(
                            //             children: [
                            //               CustomTextFormField(
                            //                 label: 'Deposit amount',
                            //                 // controller: amountController,
                            //                 initialValue: "0",
                            //                 onChanged: (String? value) {
                            //                   value!.isEmpty
                            //                       ? amount = "0"
                            //                       : amount = value;
                            //                 },

                            //                 // validator: (value) => value!.isEmpty
                            //                 //     ? 'Enter a deposit amount'
                            //                 //     : null,
                            //                 inputFormatters: <
                            //                     TextInputFormatter>[
                            //                   FilteringTextInputFormatter
                            //                       .digitsOnly
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         ],
                            //       )
                            //     : const SizedBox(),
                            SizedBox(height: height * 1),
                            CustomTextBox(
                              textValue: error!,
                              textSize: 3.5,
                              textWeight: FontWeight.bold,
                              typeAlign: Alignment.center,
                              captionAlign: TextAlign.left,
                              textColor: accentColor,
                            ),
                            CustomTextBox(
                              textValue:
                                  'Password is "Password", inform your client to change it after login.',
                              textSize: 4.0,
                              textWeight: FontWeight.normal,
                              typeAlign: Alignment.center,
                              captionAlign: TextAlign.left,
                              textColor: black,
                            ),
                            SizedBox(height: height * 8),
                            loading == true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: secondaryColor,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          mainColor),
                                    ),
                                  )
                                : PositiveElevatedButton(
                                    label: 'Create User Profile',
                                    onPressed: () async {
                                      setState(() {
                                        loading = true;
                                        // userId = userDetails!.userId! +
                                        //     randomIdGenerator()!;
                                        accountId = randomAccountIdGenerator();
                                      });
                                      await usersCollection
                                          .where('companyName',
                                              isEqualTo:
                                                  userDetails!.companyName)
                                          .where('isAdmin', isEqualTo: true)
                                          .get()
                                          .then((value) {
                                        setState(() {
                                          adminIdFromAdminProfile =
                                              (value.docs.first.data()
                                                  as dynamic)['userId'];
                                          userId = customerIdGenerator(
                                              (value.docs.first.data()
                                                  as dynamic)['userId'],
                                              (value.docs.first.data()
                                                          as dynamic)[
                                                      'totalCustomers'] +
                                                  1);
                                        });
                                      });

                                      // await userIdsCollection
                                      //     .get()
                                      //     .then((value) {
                                      //   setState(() {
                                      //     userId = customerIdGenerator(
                                      //         adminIdFromAdminProfile,
                                      //         value.size);
                                      //   });
                                      // });
                                      print(userId);
                                      userIdsCollection
                                          .where('id', isEqualTo: userId)
                                          .get()
                                          .then((value) async {
                                        if (value.docs.isEmpty) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            await sendEmail(
                                                email: emailController.text,
                                                randomPassword: "Password",
                                                // randomPinGenerator(),
                                                role: "Customer");

                                            await userRequestsCollection
                                                .doc()
                                                .set({
                                              'email': emailController.text,
                                              'firstName':
                                                  firstNameController.text,
                                              'lastName':
                                                  lastNameController.text,
                                              'nicNumber':
                                                  nicNumberController.text,
                                              'companyName':
                                                  userDetails.companyName,
                                              'password': "Password",
                                              'accountUid': accountId,
                                              'accountType': "Real",
                                              'amount': amount,
                                              'companyTelNo':
                                                  phoneNumberController.text,
                                              'currency': userDetails.currency,
                                              'createdDate': formattedDate,
                                              'userId': userId,
                                              'searchQuery': setSearchParam(
                                                  "${firstNameController.text.toLowerCase()} ${lastNameController.text.toLowerCase()}"),
                                            });
                                            await userIdsCollection.doc().set({
                                              'id': userId,
                                            });
                                            await usersCollection
                                                .where('companyName',
                                                    isEqualTo:
                                                        userDetails.companyName)
                                                .where('isAdmin',
                                                    isEqualTo: true)
                                                .get()
                                                .then((value) {
                                              usersCollection
                                                  .doc(value.docs.first.id)
                                                  .update({
                                                'totalCustomers':
                                                    (value.docs.first.data()
                                                                as dynamic)[
                                                            'totalCustomers'] +
                                                        1,
                                              });
                                            });
                                            print(fbPassword);
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
