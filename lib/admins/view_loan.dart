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

import '../reusable_components/text_input_formatters.dart';

class ViewLoanArgs {
  final QueryDocumentSnapshot? loan;

  ViewLoanArgs({this.loan});
}

class ViewLoan extends StatefulWidget {
  ViewLoan({Key? key}) : super(key: key);

  @override
  State<ViewLoan> createState() => _ViewLoanState();
}

class _ViewLoanState extends State<ViewLoan> {
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final args = ModalRoute.of(context)!.settings.arguments as ViewLoanArgs;

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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: height * 2),
                        CustomTextBox(
                          textValue: 'New Loan',
                          textSize: 10,
                          textWeight: FontWeight.bold,
                          typeAlign: Alignment.topLeft,
                          captionAlign: TextAlign.left,
                          textColor: black,
                        ),
                        SizedBox(height: height * 2),
                        CustomTextFormField(
                          initialValue: loan['userName'],
                          label: 'Customer',
                          controller: userNameController,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter name' : null,
                        ),
                        SizedBox(height: height * 2),
                        CustomTextFormField(
                          initialValue: loan['amount'].toString(),
                          label: 'Amount (${userDetails!.currency})',
                          controller: amountController,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter amount' : null,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        SizedBox(height: height * 2),
                        Column(
                          children: [
                            CustomTextBox(
                              textValue: 'Duration',
                              textSize: 4,
                              textWeight: FontWeight.normal,
                              typeAlign: Alignment.topLeft,
                              captionAlign: TextAlign.left,
                              textColor: black,
                            ),
                            SizedBox(height: height * 0.5),
                            Container(
                              width: width * 90,
                              height: height * 6.5,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(width * 3),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: DropdownButton<String?>(
                                  value: duration != "1 month"
                                      ? duration
                                      : loan['duration'],
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: mainColor,
                                  ),
                                  iconSize: width * 9,
                                  isExpanded: true,
                                  elevation: 16,
                                  style: const TextStyle(color: black),
                                  underline: Container(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      duration = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    '1 month',
                                    '2 month',
                                    '3 month',
                                    '6 month',
                                    '12 month',
                                    '24 month',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontSize: width * 5,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 2),
                        SizedBox(height: height * 2),
                        Column(
                          children: [
                            CustomTextBox(
                              textValue: 'Loan Type',
                              textSize: 4,
                              textWeight: FontWeight.normal,
                              typeAlign: Alignment.topLeft,
                              captionAlign: TextAlign.left,
                              textColor: black,
                            ),
                            SizedBox(height: height * 0.5),
                            Container(
                              width: width * 90,
                              height: height * 6.5,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(width * 3),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: DropdownButton<String?>(
                                  value: loanType != 'Monthly'
                                      ? loanType
                                      : loan['loanType'],
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: mainColor,
                                  ),
                                  iconSize: width * 9,
                                  isExpanded: true,
                                  elevation: 16,
                                  style: const TextStyle(color: black),
                                  underline: Container(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      loanType = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'Daily',
                                    'Monthly',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontSize: width * 5,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 3),
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
                                  textSize: 5.0,
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
                                      textValue: 'Duration',
                                      textSize: 4.0,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    CustomTextBox(
                                      textValue: duration != "1 month"
                                          ? duration
                                          : loan['duration'],
                                      textSize: 4.0,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 1),
                                Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                    child: CustomTextFormField(
                                      initialValue: "0",
                                      label: 'Interest (0.00 - 400.00)%',
                                      // controller: interestController,
                                      onChanged: (String? value) {
                                        setState(() {
                                          interestRate = value;
                                          if (loan['loanType'] == "Monthly") {
                                            interestRate!.isEmpty
                                                ? monthlyInterest =
                                                    roundDouble(0, 2)
                                                : duration != "1 month"
                                                    ? monthlyInterest = roundDouble(
                                                        (loan['amount'] *
                                                            double.parse(
                                                                interestRate!) *
                                                            0.01 /
                                                            (int.parse(duration!
                                                                .split(' ')
                                                                .first))),
                                                        2)
                                                    : monthlyInterest = roundDouble(
                                                        (loan['amount'] *
                                                            double.parse(
                                                                interestRate!) *
                                                            0.01 /
                                                            (int.parse((loan[
                                                                    'duration'])!
                                                                .split(' ')
                                                                .first))),
                                                        2);

                                            interestRate!.isEmpty
                                                ? totalInterest =
                                                    roundDouble(0, 2)
                                                : duration! != "1 month"
                                                    ? totalInterest = roundDouble(
                                                        (loan['amount'] *
                                                            double.parse(
                                                                interestRate!) *
                                                            0.01),
                                                        2)
                                                    : totalInterest = roundDouble(
                                                        (loan['amount'] *
                                                            double.parse(
                                                                interestRate!) *
                                                            0.01),
                                                        2);

                                            interestRate!.isEmpty
                                                ? monthlyCollection =
                                                    roundDouble(0, 2)
                                                : duration != "1 month"
                                                    ? monthlyCollection = roundDouble(
                                                        (loan['amount'] *
                                                            (double.parse(
                                                                    interestRate!) +
                                                                100) *
                                                            0.01 /
                                                            (int.parse(duration!
                                                                .split(' ')
                                                                .first))),
                                                        2)
                                                    : monthlyCollection = roundDouble(
                                                        (loan['amount'] *
                                                            (double.parse(
                                                                    interestRate!) +
                                                                100) *
                                                            0.01 /
                                                            (int.parse((loan[
                                                                    'duration'])!
                                                                .split(' ')
                                                                .first))),
                                                        2);

                                            interestRate!.isEmpty
                                                ? totalCollection =
                                                    roundDouble(0, 2)
                                                : duration != "1 month"
                                                    ? totalCollection = roundDouble(
                                                        (loan['amount'] *
                                                            (double.parse(
                                                                    interestRate!) +
                                                                100) *
                                                            0.01),
                                                        2)
                                                    : totalCollection = roundDouble(
                                                        (loan['amount'] *
                                                            (double.parse(
                                                                    interestRate!) +
                                                                100) *
                                                            0.01),
                                                        2);
                                          } else {
                                            interestRate!.isEmpty
                                                ? monthlyInterest =
                                                    roundDouble(0, 2)
                                                : duration != "1 month"
                                                    ? monthlyInterest = roundDouble(
                                                        (loan['amount'] *
                                                            double.parse(
                                                                interestRate!) *
                                                            0.01 /
                                                            ((int.parse(duration!
                                                                    .split(' ')
                                                                    .first)) *
                                                                30)),
                                                        2)
                                                    : monthlyInterest = roundDouble(
                                                        (loan['amount'] *
                                                            double.parse(
                                                                interestRate!) *
                                                            0.01 /
                                                            ((int.parse((loan[
                                                                        'duration'])!
                                                                    .split(' ')
                                                                    .first)) *
                                                                30)),
                                                        2);

                                            interestRate!.isEmpty
                                                ? totalInterest =
                                                    roundDouble(0, 2)
                                                : duration! != "1 month"
                                                    ? totalInterest = roundDouble(
                                                        (loan['amount'] *
                                                            double.parse(
                                                                interestRate!) *
                                                            0.01),
                                                        2)
                                                    : totalInterest = roundDouble(
                                                        (loan['amount'] *
                                                            double.parse(
                                                                interestRate!) *
                                                            0.01),
                                                        2);

                                            interestRate!.isEmpty
                                                ? monthlyCollection =
                                                    roundDouble(0, 2)
                                                : duration != "1 month"
                                                    ? monthlyCollection = roundDouble(
                                                        (loan['amount'] *
                                                            (double.parse(
                                                                    interestRate!) +
                                                                100) *
                                                            0.01 /
                                                            ((int.parse(duration!
                                                                    .split(' ')
                                                                    .first)) *
                                                                30)),
                                                        2)
                                                    : monthlyCollection = roundDouble(
                                                        (loan['amount'] *
                                                            (double.parse(
                                                                    interestRate!) +
                                                                100) *
                                                            0.01 /
                                                            ((int.parse(duration!
                                                                    .split(' ')
                                                                    .first)) *
                                                                30)),
                                                        2);

                                            interestRate!.isEmpty
                                                ? totalCollection =
                                                    roundDouble(0, 2)
                                                : duration != "1 month"
                                                    ? totalCollection = roundDouble(
                                                        (loan['amount'] *
                                                            (double.parse(
                                                                    interestRate!) +
                                                                100) *
                                                            0.01),
                                                        2)
                                                    : totalCollection = roundDouble(
                                                        (loan['amount'] *
                                                            (double.parse(
                                                                    interestRate!) +
                                                                100) *
                                                            0.01),
                                                        2);
                                          }
                                        });
                                      },
                                      validator: (value) => value!.isEmpty
                                          ? 'Enter interest rate'
                                          : int.parse(value) > 400.00
                                              ? 'Please enter a value < 400.00'
                                              : null,
                                      inputFormatters: <TextInputFormatter>[
                                        // FilteringTextInputFormatter.digitsOnly
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[0-9\\.]")),
                                        DecimalTextInputFormatter(
                                            decimalRange: 2),
                                      ],
                                    ),
                                  ),
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
                                      textValue: interestRate! + "%",
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
                                          ? 'Monthly Profit'
                                          : 'Daily Profit',
                                      textSize: 4.0,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    CustomTextBox(
                                      textValue: interestRate!.isEmpty
                                          ? "${loan['currency']} " +
                                              monthlyInterest.toString()
                                          : duration != "1 month"
                                              ? "${loan['currency']} " +
                                                  monthlyInterest.toString()
                                              : "${loan['currency']} " +
                                                  monthlyInterest.toString(),
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
                                      textValue: 'Total Profit',
                                      textSize: 4.0,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    CustomTextBox(
                                      textValue: interestRate!.isEmpty
                                          ? "${loan['currency']} " +
                                              totalInterest.toString()
                                          : duration! != "1 month"
                                              ? "${loan['currency']} " +
                                                  totalInterest.toString()
                                              : "${loan['currency']} " +
                                                  (totalInterest.toString()),
                                      textSize: 4.0,
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
                                      textValue: interestRate!.isEmpty
                                          ? "${loan['currency']} " +
                                              monthlyCollection.toString()
                                          : duration != "1 month"
                                              ? "${loan['currency']} " +
                                                  monthlyCollection.toString()
                                              : "${loan['currency']} " +
                                                  monthlyCollection.toString(),
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
                                      textValue: 'Total Collection',
                                      textSize: 4.0,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    CustomTextBox(
                                      textValue: interestRate!.isEmpty
                                          ? "${loan['currency']} " +
                                              totalCollection.toString()
                                          : duration != "1 month"
                                              ? "${loan['currency']} " +
                                                  totalCollection.toString()
                                              : "${loan['currency']} " +
                                                  totalCollection.toString(),
                                      textSize: 4.0,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
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
                          label: 'Send to Customer',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await loanRequestsCollection
                                  .doc(args.loan!.id)
                                  .update({
                                'interestRate': interestRate,
                                'monthlyInterest': monthlyInterest,
                                'totalInterest': totalInterest,
                                'monthlyCollection': monthlyCollection,
                                'totalCollection': totalCollection,
                                'status': "accepted",
                                'acceptedDate': formattedDate,
                              });

                              Navigator.pop(context);
                            }
                          },
                        ),
                        SizedBox(height: height * 10),
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

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}
