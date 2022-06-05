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

class ViewAcceptedLoanArgs {
  final QueryDocumentSnapshot? loan;

  ViewAcceptedLoanArgs({this.loan});
}

class ViewAcceptedLoan extends StatefulWidget {
  ViewAcceptedLoan({Key? key}) : super(key: key);

  @override
  State<ViewAcceptedLoan> createState() => _ViewAcceptedLoanState();
}

class _ViewAcceptedLoanState extends State<ViewAcceptedLoan> {
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
  double? capital = 0;
  double? totalLoans = 0.00;

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

    final args =
        ModalRoute.of(context)!.settings.arguments as ViewAcceptedLoanArgs;

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
                              loan['createdDate'] != ""
                                  ? Column(
                                      children: [
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
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomTextBox(
                                          textValue: 'Loan Sent',
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
                                    textValue:
                                        loan['interestRate'].toString() + " %",
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
                                        ? "x " +
                                            (int.parse((loan['duration'])!
                                                    .split(' ')
                                                    .first))
                                                .toString()
                                        : "x " +
                                            (int.parse((loan['duration'])!
                                                        .split(' ')
                                                        .first) *
                                                    30)
                                                .toString(),
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
                      PositiveElevatedButton(
                        label: 'Accept Offer',
                        onPressed: () async {
                          setState(() {
                            year = int.parse(formattedDate.split('-').first);
                            month = int.parse(formattedDate.split('-')[1]);
                            day = int.parse(formattedDate.split('-').last);

                            if (loan['loanType'] == "Monthly")
                              // ignore: curly_braces_in_flow_control_structures
                              collectingDates = {
                                for (var i = 0;
                                    i <
                                        (int.parse(
                                            loan['duration'].split(' ').first));
                                    i++)
                                  formatter.format(DateTime(
                                      year!, month! + i + 1, day!)): false,
                              };

                            if (loan['loanType'] == "Daily")
                              // ignore: curly_braces_in_flow_control_structures
                              collectingDates = {
                                for (var i = 0;
                                    i <
                                        (int.parse(loan['duration']
                                                .split(' ')
                                                .first)) *
                                            30;
                                    i++)
                                  formatter.format(DateTime(
                                      year!, month!, day! + i + 1)): false,
                              };
                          });
                          await loanRequestsCollection
                              .doc(args.loan!.id)
                              .update({
                            'status': "okayed",
                            'okDate': formattedDate,
                            'collectingDates': collectingDates,
                            'extraChange': 0.00,
                            'notPaidDates': [],
                            'searchQuery': userDetails!.userId!.split("-").last,
                          });
                          await usersCollection
                              .where('companyName',
                                  isEqualTo: userDetails.companyName)
                              .where('isAdmin', isEqualTo: true)
                              .get()
                              .then((snapshot) {
                            setState(() {
                              capital = (((snapshot.docs.first.data()
                                          as dynamic)['capitalAmount'])
                                      .toDouble() -
                                  (loan['amount']));
                              totalLoans = ((snapshot.docs.first.data()
                                      as dynamic)['totalLoans']) +
                                  loan['amount'];
                            });
                            usersCollection.doc(snapshot.docs.first.id).update({
                              'capitalAmount': capital,
                              'totalLoans': totalLoans,
                            });
                          });
                          // await transactionsCollection.doc().set({
                          //   'type':'loan',
                          //   'userId': loan['user'],
                          //   'loanId' : args.loan!.id,
                          //   'userName': loan['userName'],
                          //   'companyName': loan['companyName'],
                          //   'amount': loan['amount'],
                          //   'date' : formattedDate,
                          //   'dueAmount' :
                          // });
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 200,
                                  color: backgroundColor,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        CustomTextBox(
                                          textValue:
                                              "You have added the loan successfuly into your account.",
                                          textSize: 4.0,
                                          textWeight: FontWeight.normal,
                                          typeAlign: Alignment.topLeft,
                                          captionAlign: TextAlign.left,
                                          textColor: black,
                                        ),
                                        PositiveHalfElevatedButton(
                                          label: "OK",
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: height * 3),
                      NegativeElevatedButton(
                        label: 'Decline',
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
