import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_time_patterns.dart';
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

class GiveNewLoanArgs {
  final bool? isAdmin;

  GiveNewLoanArgs({this.isAdmin});
}

class GiveNewLoan extends StatefulWidget {
  GiveNewLoan({Key? key}) : super(key: key);

  @override
  State<GiveNewLoan> createState() => _GiveNewLoanState();
}

class _GiveNewLoanState extends State<GiveNewLoan> {
  final _formKey = GlobalKey<FormState>();

  bool? loading = false;
  String? userName = "";
  String? userId = "";
  String? uid = "";
  String? duration = "1 month";
  String? loanType = "Monthly";
  String? error = "";
  double extraChange = 0.00;
  double? newCapital = 0.00;
  String? interestRate = "";
  double? monthlyInterest = 0;
  double? totalInterest = 0;
  double? monthlyCollection = 0;
  double? totalCollection = 0;

  final amountController = TextEditingController();
  String? amount = "0";
  final dateController = TextEditingController();

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  int? year = 0;
  int? month = 0;
  int? day = 0;

  Map collectingDates = {};
  List? dateList = [];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);

    final args = ModalRoute.of(context)!.settings.arguments as GiveNewLoanArgs;

    // final loan = (args.loan!.data() as dynamic);

    String formattedDate = formatter.format(now);

    Future<void> updated(StateSetter updateState, String? errorMessage) async {
      updateState(() {
        error = errorMessage!;
      });
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextBox(
                              textValue: 'Add New Loan',
                              textSize: 10,
                              textWeight: FontWeight.bold,
                              typeAlign: Alignment.topLeft,
                              captionAlign: TextAlign.left,
                              textColor: black,
                            ),
                          ],
                        ),
                        SizedBox(height: height * 2),
                        CustomTextFormField(
                          label: 'User Id',
                          onChanged: (value) {
                            usersCollection
                                .where('userId', isEqualTo: value)
                                .where('isUser', isEqualTo: true)
                                .get()
                                .then((user) {
                              setState(() {
                                uid = user.docs.first.id;
                                userName = (user.docs.first.data()
                                        as dynamic)['firstName'] +
                                    " " +
                                    (user.docs.first.data()
                                        as dynamic)['lastName'];

                                userId = (user.docs.first.data()
                                    as dynamic)['userId'];
                              });
                            }).onError((error, stackTrace) => null);
                          },
                          // inputFormatters: [
                          //   LengthLimitingTextInputFormatter(10),
                          //   FilteringTextInputFormatter.digitsOnly,
                          // ]
                          // validator: (value) =>
                          //     value!.isEmpty ? 'Enter the amount' : null,
                        ),
                        userName != ""
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: userName!,
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: secondaryColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'User Id: ' + userId!,
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: secondaryColor,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        uid = "";
                                        userName = "";
                                        userId = "";
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: red,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        SizedBox(height: height * 2),
                        CustomTextFormField(
                          label: 'Amount (${userDetails!.currency})',
                          controller: amountController,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter the amount' : null,
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
                                  value: duration,
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
                                  value: loanType,
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
                        SizedBox(height: height * 2),
                        CustomTextFormField(
                          initialValue: "0",
                          label: 'Interest (0.00 - 400.00)%',
                          // controller: interestController,
                          onChanged: (String? value) {
                            setState(() {
                              interestRate = value;
                              if (loanType == "Monthly") {
                                interestRate!.isEmpty
                                    ? monthlyInterest = roundDouble(0, 2)
                                    : duration != "1 month"
                                        ? monthlyInterest = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                double.parse(interestRate!) *
                                                0.01 /
                                                (int.parse(duration!
                                                    .split(' ')
                                                    .first))),
                                            2)
                                        : monthlyInterest = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                double.parse(interestRate!) *
                                                0.01 /
                                                (int.parse((duration)!
                                                    .split(' ')
                                                    .first))),
                                            2);

                                interestRate!.isEmpty
                                    ? totalInterest = roundDouble(0, 2)
                                    : duration! != "1 month"
                                        ? totalInterest = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                double.parse(interestRate!) *
                                                0.01),
                                            2)
                                        : totalInterest = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                double.parse(interestRate!) *
                                                0.01),
                                            2);

                                interestRate!.isEmpty
                                    ? monthlyCollection = roundDouble(0, 2)
                                    : duration != "1 month"
                                        ? monthlyCollection = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                (double.parse(interestRate!) +
                                                    100) *
                                                0.01 /
                                                (int.parse(duration!
                                                    .split(' ')
                                                    .first))),
                                            2)
                                        : monthlyCollection = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                (double.parse(interestRate!) +
                                                    100) *
                                                0.01 /
                                                (int.parse((duration)!
                                                    .split(' ')
                                                    .first))),
                                            2);

                                interestRate!.isEmpty
                                    ? totalCollection = roundDouble(0, 2)
                                    : duration != "1 month"
                                        ? totalCollection = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                (double.parse(interestRate!) +
                                                    100) *
                                                0.01),
                                            2)
                                        : totalCollection = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                (double.parse(interestRate!) +
                                                    100) *
                                                0.01),
                                            2);
                              } else {
                                interestRate!.isEmpty
                                    ? monthlyInterest = roundDouble(0, 2)
                                    : duration != "1 month"
                                        ? monthlyInterest = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                double.parse(interestRate!) *
                                                0.01 /
                                                ((int.parse(duration!
                                                        .split(' ')
                                                        .first)) *
                                                    30)),
                                            2)
                                        : monthlyInterest = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                double.parse(interestRate!) *
                                                0.01 /
                                                ((int.parse((duration)!
                                                        .split(' ')
                                                        .first)) *
                                                    30)),
                                            2);

                                interestRate!.isEmpty
                                    ? totalInterest = roundDouble(0, 2)
                                    : duration! != "1 month"
                                        ? totalInterest = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                double.parse(interestRate!) *
                                                0.01),
                                            2)
                                        : totalInterest = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                double.parse(interestRate!) *
                                                0.01),
                                            2);

                                interestRate!.isEmpty
                                    ? monthlyCollection = roundDouble(0, 2)
                                    : duration != "1 month"
                                        ? monthlyCollection = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                (double.parse(interestRate!) +
                                                    100) *
                                                0.01 /
                                                ((int.parse(duration!
                                                        .split(' ')
                                                        .first)) *
                                                    30)),
                                            2)
                                        : monthlyCollection = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                (double.parse(interestRate!) +
                                                    100) *
                                                0.01 /
                                                ((int.parse(duration!
                                                        .split(' ')
                                                        .first)) *
                                                    30)),
                                            2);

                                interestRate!.isEmpty
                                    ? totalCollection = roundDouble(0, 2)
                                    : duration != "1 month"
                                        ? totalCollection = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                (double.parse(interestRate!) +
                                                    100) *
                                                0.01),
                                            2)
                                        : totalCollection = roundDouble(
                                            (double.parse(
                                                    amountController.text) *
                                                (double.parse(interestRate!) +
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
                            DecimalTextInputFormatter(decimalRange: 2),
                          ],
                        ),
                        SizedBox(height: height * 2),
                        SizedBox(height: height * 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextBox(
                              textValue: loanType == "Monthly"
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
                                  ? "${userDetails.currency} " +
                                      monthlyInterest.toString()
                                  : duration != "1 month"
                                      ? "${userDetails.currency} " +
                                          monthlyInterest.toString()
                                      : "${userDetails.currency} " +
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  ? "${userDetails.currency} " +
                                      totalInterest.toString()
                                  : duration! != "1 month"
                                      ? "${userDetails.currency} " +
                                          totalInterest.toString()
                                      : "${userDetails.currency} " +
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextBox(
                              textValue: loanType == "Monthly"
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
                                  ? "${userDetails.currency} " +
                                      monthlyCollection.toString()
                                  : duration != "1 month"
                                      ? "${userDetails.currency} " +
                                          monthlyCollection.toString()
                                      : "${userDetails.currency} " +
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
                        SizedBox(height: height * 5),
                        PositiveElevatedButton(
                          label: 'Send to Customer',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              await loanRequestsCollection.doc().set({
                                'interestRate': interestRate,
                                'monthlyInterest': monthlyInterest,
                                'totalInterest': totalInterest,
                                'monthlyCollection': monthlyCollection,
                                'totalCollection': totalCollection,
                                'status': "accepted",
                                'acceptedDate': formattedDate,
                                'user': uid,
                                'userName': userName,
                                'amount': int.parse(amountController.text),
                                'duration': duration,
                                'loanType': loanType,
                                'companyName': userDetails.companyName,
                                'currency': userDetails.currency,
                                'createdDate': "",
                              });

                              showModalBottomSheet(
                                  isDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BottomSheet(
                                      onClosing: () {},
                                      builder: (context) {
                                        return Container(
                                          height: height * 20,
                                          color: white,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.all(width * 5.1),
                                            child: Column(
                                              children: [
                                                CustomTextBox(
                                                  textValue:
                                                      "Loan successfully sent to the customer.",
                                                  textSize: 4,
                                                  textWeight: FontWeight.normal,
                                                  typeAlign: Alignment.topLeft,
                                                  captionAlign: TextAlign.left,
                                                  textColor: black,
                                                ),
                                                SizedBox(height: height * 2),
                                                PositiveHalfElevatedButton(
                                                  label: 'Ok',
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  });
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
