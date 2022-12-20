import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/custom_text_form_field.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

class ViewUserNotAcceptedLoanArgs {
  final QueryDocumentSnapshot? loan;

  ViewUserNotAcceptedLoanArgs({this.loan});
}

class ViewUserNotAcceptedLoan extends StatefulWidget {
  const ViewUserNotAcceptedLoan({Key? key}) : super(key: key);

  @override
  State<ViewUserNotAcceptedLoan> createState() =>
      _ViewUserNotAcceptedLoanState();
}

class _ViewUserNotAcceptedLoanState extends State<ViewUserNotAcceptedLoan> {
  final _formKey = GlobalKey<FormState>();

  bool? loading = false;
  String? duration = "1 month";
  String? loanType = "Monthly";
  String? error = "";

  final amountController = TextEditingController();
  final userNameController = TextEditingController();
  final interestController = TextEditingController();
  String? interestRate = "";
  double? monthlyInterest = 0;
  double? totalInterest = 0;
  double? monthlyCollection = 0;
  double? totalCollection = 0;
  int? capital = 0;

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  int? year = 0;
  int? month = 0;
  int? day = 0;

  Object? collectingDates = {};

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final args = ModalRoute.of(context)!.settings.arguments
        as ViewUserNotAcceptedLoanArgs;

    final user = Provider.of<mcmUser?>(context);

    final loan = (args.loan!.data() as dynamic);

    String formattedDate = formatter.format(now);

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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CustomTextBox(
                                textValue: 'Details',
                                textSize: 7.0,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.topLeft,
                                captionAlign: TextAlign.left,
                                textColor: black,
                              ),
                              SizedBox(height: height * 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: 'Amount',
                                    textSize: 5.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['currency'] +
                                        " " +
                                        loan['amount'].toString(),
                                    textSize: 6.0,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: 'Company Name',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['companyName'],
                                    textSize: 5.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: 'Loan Requested',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['createdDate'],
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: 'Loan Accepted',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['acceptedDate'],
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: 'Duration',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['duration'],
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: 'Interest Rate',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: "${loan['interestRate']} %",
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: loan['loanType'] == "Monthly"
                                        ? 'Monthly Interest'
                                        : 'Daily Interest',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['currency'] +
                                        " " +
                                        loan['monthlyInterest'].toString(),
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: 'Total Interest',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['currency'] +
                                        " " +
                                        loan['totalInterest'].toString(),
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: loan['loanType'] == "Monthly"
                                        ? 'Monthly Collection'
                                        : 'Daily Collection',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['currency'] +
                                        " " +
                                        loan['monthlyCollection'].toString(),
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: ' ',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['loanType'] == "Monthly"
                                        ? "x ${int.parse((loan['duration'])!.split(' ').first)}"
                                        : "x ${int.parse((loan['duration'])!.split(' ').first) * 30}",
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: secondaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: 'Total',
                                    textSize: 5.0,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['currency'] +
                                        " " +
                                        loan['totalCollection'].toString(),
                                    textSize: 5.0,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: green!,
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 1),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 5),
                      NegativeElevatedButton(
                        label: 'Cancel',
                        onPressed: () async {
                          await loanRequestsCollection
                              .doc(args.loan!.id)
                              .update({
                            'status': "rejected",
                            'rejectedDate': formattedDate,
                          });

                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: height * 10),
                    ],
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

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}
