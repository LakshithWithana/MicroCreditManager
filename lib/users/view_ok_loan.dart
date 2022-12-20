import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

import '../reusable_components/custom_text_form_field.dart';

class ViewOkLoanArgs {
  final QueryDocumentSnapshot? loan;

  ViewOkLoanArgs({this.loan});
}

class ViewOkLoan extends StatefulWidget {
  const ViewOkLoan({Key? key}) : super(key: key);

  @override
  State<ViewOkLoan> createState() => _ViewOkLoanState();
}

class _ViewOkLoanState extends State<ViewOkLoan> {
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

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  int? year = 0;
  int? month = 0;
  int? day = 0;

  Object? collectingDates = {};

  final dateController = TextEditingController();
  final reasonController = TextEditingController();
  String? startDate = "";
  String? endDate = "";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final args = ModalRoute.of(context)!.settings.arguments as ViewOkLoanArgs;

    final user = Provider.of<mcmUser?>(context);

    final loan = (args.loan!.data() as dynamic);

    String formattedDate = formatter.format(now);

    Map<String, dynamic> collectionHistory = loan['collectingDates'];
    List<MapEntry<String, dynamic>> collectionHistoryList =
        collectionHistory.entries.toList();

    collectionHistoryList.sort((a, b) {
      return a.key.compareTo(b.key);
    });

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
                                    textSize: 4.5,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['currency'] +
                                        " " +
                                        loan['totalCollection']
                                            .toStringAsFixed(2),
                                    textSize: 4.5,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: green!,
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: 'Balance',
                                    textSize: 5.0,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue: loan['currency'] +
                                        " " +
                                        loan['balance'].toStringAsFixed(2),
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
                                textValue: 'Collection',
                                textSize: 7.0,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.topLeft,
                                captionAlign: TextAlign.left,
                                textColor: black,
                              ),
                              SizedBox(height: height * 2),
                              getRowWidget(collectionHistoryList),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 5),
                      PositiveElevatedButton(
                        label: 'Contact Company',
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, setState) {
                                  return BottomSheet(
                                    enableDrag: false,
                                    onClosing: () {
                                      reasonController.clear();
                                    },
                                    builder: (context) {
                                      return Container(
                                        height: height * 65,
                                        color: white,
                                        child: Padding(
                                          padding: EdgeInsets.all(width * 5.1),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                CustomTextBox(
                                                  textValue: 'Contact Company',
                                                  textSize: 7,
                                                  textWeight: FontWeight.bold,
                                                  typeAlign: Alignment.topLeft,
                                                  captionAlign: TextAlign.left,
                                                  textColor: black,
                                                ),
                                                SizedBox(height: height * 3),
                                                CustomTextBox(
                                                  textValue:
                                                      'Send request to get extention time',
                                                  textSize: 5,
                                                  textWeight: FontWeight.normal,
                                                  typeAlign: Alignment.topLeft,
                                                  captionAlign: TextAlign.left,
                                                  textColor: black,
                                                ),
                                                SizedBox(height: height * 2),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CustomTextBox(
                                                      textValue:
                                                          'Starting date:',
                                                      textSize: 5,
                                                      textWeight:
                                                          FontWeight.normal,
                                                      typeAlign:
                                                          Alignment.topLeft,
                                                      captionAlign:
                                                          TextAlign.left,
                                                      textColor: black,
                                                    ),
                                                    SizedBox(
                                                      width: width * 40,
                                                      child: DateTimePicker(
                                                        icon: const Icon(Icons
                                                            .calendar_month),
                                                        initialValue: DateTime
                                                                .now()
                                                            // .subtract(
                                                            //     const Duration(
                                                            //         days: 30))
                                                            .toString(),
                                                        firstDate:
                                                            DateTime(2000),
                                                        lastDate:
                                                            DateTime(2100),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            startDate = val;
                                                          });
                                                        },
                                                        validator: (val) {
                                                          print(val);

                                                          return null;
                                                        },
                                                        onSaved: (val) {
                                                          setState(() {
                                                            startDate = val;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CustomTextBox(
                                                      textValue: 'Ending date:',
                                                      textSize: 5,
                                                      textWeight:
                                                          FontWeight.normal,
                                                      typeAlign:
                                                          Alignment.topLeft,
                                                      captionAlign:
                                                          TextAlign.left,
                                                      textColor: black,
                                                    ),
                                                    SizedBox(
                                                      width: width * 40,
                                                      child: DateTimePicker(
                                                        icon: const Icon(Icons
                                                            .calendar_month),
                                                        initialValue:
                                                            DateTime.now()
                                                                .toString(),
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate:
                                                            DateTime(2100),
                                                        onChanged: (val) {
                                                          print(val);
                                                          setState(() {
                                                            endDate = val;
                                                          });
                                                        },
                                                        validator: (val) {
                                                          return null;
                                                        },
                                                        onSaved: (val) {
                                                          setState(() {
                                                            endDate = val;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                CustomTextFormField(
                                                  label: 'Reason',
                                                  controller: reasonController,
                                                ),
                                                SizedBox(height: height * 5),
                                                PositiveElevatedButton(
                                                  label: 'Send to Company',
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "loanExtentionRequests")
                                                        .add({
                                                      "loanId": args.loan!.id,
                                                      "startingDate": startDate,
                                                      "endingDate": endDate,
                                                      "reason":
                                                          reasonController.text,
                                                      "status": "pending",
                                                      "duration": (DateTime(
                                                                      int.parse(endDate!
                                                                          .split(
                                                                              '-')
                                                                          .first),
                                                                      int.parse(
                                                                          endDate!.split('-')[
                                                                              1]),
                                                                      int.parse(endDate!
                                                                          .split(
                                                                              '-')
                                                                          .last))
                                                                  .difference(DateTime(
                                                                      int.parse(startDate!
                                                                          .split(
                                                                              '-')
                                                                          .first),
                                                                      int.parse(
                                                                          startDate!
                                                                              .split('-')[1]),
                                                                      int.parse(startDate!.split('-').last)))
                                                                  .inHours /
                                                              24)
                                                          .round()
                                                    }).then((value) {
                                                      setState(() {
                                                        startDate = "";
                                                        endDate = "";
                                                        reasonController
                                                            .clear();
                                                      });
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                ),
                                                SizedBox(height: height * 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
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

// Widget getRowWidget(Map<String, dynamic> singleRow) {
//   return Column(
//       children: singleRow.entries.map((entry) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         CustomTextBox(
//           textValue: entry.key,
//           textSize: 4.0,
//           textWeight: FontWeight.normal,
//           typeAlign: Alignment.topLeft,
//           captionAlign: TextAlign.left,
//           textColor: black,
//         ),
//         CustomTextBox(
//           textValue: entry.value == false ? 'Awaiting' : 'Paid',
//           textSize: 4.0,
//           textWeight: FontWeight.normal,
//           typeAlign: Alignment.topLeft,
//           captionAlign: TextAlign.left,
//           textColor: black,
//         ),
//       ],
//     );
//   }).toList());
// }
Widget getRowWidget(List<MapEntry<String, dynamic>> singleRow) {
  return Column(
      children: singleRow
          .map(
            (item) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextBox(
                  textValue: item.key,
                  textSize: 4.0,
                  textWeight: FontWeight.normal,
                  typeAlign: Alignment.topLeft,
                  captionAlign: TextAlign.left,
                  textColor: black,
                ),
                CustomTextBox(
                  textValue: item.value.toString(),
                  textSize: 4.0,
                  textWeight: FontWeight.normal,
                  typeAlign: Alignment.topLeft,
                  captionAlign: TextAlign.left,
                  textColor: black,
                ),
              ],
            ),
          )
          .toList());
}
