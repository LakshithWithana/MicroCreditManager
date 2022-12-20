import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/custom_text_form_field.dart';
import 'package:mcm/services/auth_services.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AdminSignUpDetailsArgs {
  final String? companyName;
  final String? governmentRegistered;
  final String? companyRegistrationNo;
  final String? country;
  final String? countryCode;
  final String? currency;
  final String? companyTelNo;
  final int? capitalAmount;

  AdminSignUpDetailsArgs(
      {this.companyName,
      this.governmentRegistered,
      this.companyRegistrationNo,
      this.country,
      this.countryCode,
      this.currency,
      this.companyTelNo,
      this.capitalAmount});
}

class AdminSignUpDetails extends StatefulWidget {
  const AdminSignUpDetails({Key? key}) : super(key: key);

  @override
  _AdminSignUpDetailsState createState() => _AdminSignUpDetailsState();
}

class _AdminSignUpDetailsState extends State<AdminSignUpDetails> {
  final AuthServices _auth = AuthServices();

  final _formKey = GlobalKey<FormState>();
  String? error = "";
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  // final organizationController = TextEditingController();
  final nicNumberController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? adminId = "";

  var accountUid = const Uuid();
  String? accountID = "";

  bool? isLoading = false;
  bool isProgressBarLoading = false;

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  bool downloading = true;
  String downloadingStr = "No data";
  double download = 0.0;
  late File f;

  Future downloadFile({String? url}) async {
    var docUrl = url!;
    try {
      setState(() {
        isProgressBarLoading = true;
      });
      Dio dio = Dio();
      var dir = await getApplicationDocumentsDirectory();
      f = File("${dir.path}/docs/abc.docx");
      String fileName = docUrl.substring(docUrl.lastIndexOf("/") + 1);
      dio.download(docUrl, "${dir.path}/$fileName",
          onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          download = (rec / total) * 100;
          print('$fileName downloaded');
          downloadingStr =
              "Downloading Image : ${(download).toStringAsFixed(0)}";
        });
        setState(() {
          downloading = false;
          downloadingStr = "Completed";
          isProgressBarLoading = false;
        });
      });
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as AdminSignUpDetailsArgs;

    String formattedDate = formatter.format(now);

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    /// random pin generator
    String? randomIdGenerator() {
      var rng = Random();
      int randomNumber = rng.nextInt(9999) + 9999;
      return randomNumber.toString();
    }

    String? adminIdGenerator(String? countryCode, int? accountCount) {
      String? adminId =
          "${countryCode!}ADM${accountCount!}-${(DateTime.now().millisecondsSinceEpoch).toString().substring(8)}";
      return adminId;
    }

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: mainColor),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(width * 5.1, 0, width * 5.1, 0.0),
        child: SingleChildScrollView(
          child: Builder(builder: (context) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: height * 2),
                  CustomTextBox(
                    textValue: 'Admin Details',
                    textSize: 10,
                    textWeight: FontWeight.bold,
                    typeAlign: Alignment.topLeft,
                    captionAlign: TextAlign.left,
                    textColor: mainColor,
                  ),
                  SizedBox(height: height * 2),
                  Column(
                    children: [
                      CustomTextFormField(
                        label: 'Admin First Name',
                        controller: firstNameController,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your first name' : null,
                      ),
                      SizedBox(height: height * 2),
                      Column(
                        children: [
                          CustomTextFormField(
                            label: 'Admin Last Name',
                            controller: lastNameController,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter your last name' : null,
                          ),
                        ],
                      ),
                      // SizedBox(height: height * 2),
                      // Column(
                      //   children: [
                      //     CustomTextFormField(
                      //       label: 'Organization',
                      //       controller: organizationController,
                      //       validator: (value) => value!.isEmpty
                      //           ? 'Enter your Organization name'
                      //           : null,
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: height * 2),
                      Column(
                        children: [
                          CustomTextFormField(
                            label: 'NIC Number',
                            controller: nicNumberController,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter your NIC number' : null,
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
                      Column(
                        children: [
                          CustomTextFormField(
                            label: 'Password',
                            controller: passwordController,
                            validator: (value) =>
                                value!.isEmpty ? 'Enter a password' : null,
                            secure: true,
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
                            label: 'Confirm Password',
                            controller: confirmPasswordController,
                            validator: (value) => value!.isEmpty
                                ? 'Re-enter your password'
                                : null,
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
                      SizedBox(height: height * 8),
                      // PositiveElevatedButton(
                      //     label: 'test',
                      //     onPressed: () {
                      //       print(adminIdGenerator(args.countryCode, 15));
                      //       print((DateTime.now().millisecondsSinceEpoch)
                      //           .toString()
                      //           .substring(8));
                      //     }),
                      isLoading == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: secondaryColor,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(mainColor),
                              ),
                            )
                          : PositiveElevatedButton(
                              label: 'Sign Up',
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                  accountID = accountUid.v1();
                                  // adminId = randomIdGenerator();
                                });
                                await adminIdsCollection.get().then((value) {
                                  setState(() {
                                    adminId = adminIdGenerator(
                                        args.countryCode, value.size);
                                  });
                                });

                                if (_formKey.currentState!.validate()) {
                                  if (passwordController.text ==
                                      confirmPasswordController.text) {
                                    adminIdsCollection
                                        .where('id', isEqualTo: adminId)
                                        .get()
                                        .then((value) async {
                                      print(adminId);
                                      if (value.docs.isEmpty) {
                                        await _auth
                                            .registerWithEmailAndPassword(
                                          userId: adminId,
                                          createdDate: formattedDate,
                                          companyName: args.companyName,
                                          governmentRegistered:
                                              args.governmentRegistered,
                                          companyRegistrationNo:
                                              args.companyRegistrationNo,
                                          country: args.country,
                                          currency: args.currency,
                                          companyTelNo: args.companyTelNo,
                                          capitalAmount: args.capitalAmount,
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          govIdNumber: nicNumberController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          isUser: false,
                                          isAdmin: true,
                                          isSuperAdmin: false,
                                          ownAccounts: [
                                            {
                                              'id': accountID,
                                              'accountType': 'Real',
                                              'amount': args.capitalAmount,
                                            }
                                          ],
                                          accountIds: [accountID],
                                          debt: [],
                                          paidDebt: [],
                                          viewCustomer: true,
                                          viewAgent: true,
                                          deposits: true,
                                          newLoans: true,
                                          expenses: true,
                                          accounts: true,
                                          statistics: true,
                                          downloads: true,
                                        )
                                            .then((value) {
                                          String? err =
                                              value.toString().split("]").last;
                                          setState(() {
                                            error = err;
                                          });
                                        });

                                        await adminIdsCollection.doc().set({
                                          'id': adminId,
                                        });
                                        setState(() {
                                          isLoading = false;
                                        });

                                        await depositsCollection.doc().set({
                                          'companyName': args.companyName,
                                          'userId': adminId,
                                          'customerName': "Initial Deposit",
                                          'amount': args.capitalAmount,
                                          'interestRate': 0.00,
                                          'date': formattedDate,
                                        });

                                        Navigator.pop(context);
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                          error = "Please try again.";
                                        });
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                      error = "Password missmatched";
                                    });
                                  }
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                            ),
                      SizedBox(height: height * 2),
                    ],
                  ),
                  SizedBox(height: height * 2),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
