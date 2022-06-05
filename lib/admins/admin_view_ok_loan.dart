import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class AdminViewOkLoanArgs {
  final String? loanId;
  final bool? isAdmin;

  AdminViewOkLoanArgs({this.loanId, this.isAdmin});
}

class AdminViewOkLoan extends StatefulWidget {
  AdminViewOkLoan({Key? key}) : super(key: key);

  @override
  State<AdminViewOkLoan> createState() => _AdminViewOkLoanState();
}

class _AdminViewOkLoanState extends State<AdminViewOkLoan> {
  final _formKey = GlobalKey<FormState>();

  bool? loading = false;
  String? duration = "1 month";
  String? loanType = "Monthly";
  String? error = "";
  double extraChange = 0.00;
  double? newCapital = 0.00;

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
  List? unpaidDates = [];

  bool? notPaid = false;
  int? points = 0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final args =
        ModalRoute.of(context)!.settings.arguments as AdminViewOkLoanArgs;

    final user = Provider.of<mcmUser?>(context);

    // final loan = (args.loan!.data() as dynamic);

    String formattedDate = formatter.format(now);
    String? fDate = "2022-03-04";

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
              body: StreamBuilder(
                stream: loanRequestsCollection.doc(args.loanId).snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final loan = snapshot.data;
                    Map<String, dynamic> collectionHistory =
                        loan['collectingDates'];
                    List<MapEntry<String, dynamic>> collectionHistoryList =
                        collectionHistory.entries.toList();

                    collectionHistoryList.sort((a, b) {
                      return a.key.compareTo(b.key);
                    });

                    List notPaidDates = loan['notPaidDates'];

                    return Padding(
                      padding:
                          EdgeInsets.fromLTRB(width * 5.1, 0, width * 5.1, 0.0),
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
                                              loan['amount'].toStringAsFixed(2),
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
                                          // loan['loanType'] == "Monthly"
                                          //     ? loan['duration']
                                          //     : (int.parse((loan['duration'])!
                                          //                     .split(' ')
                                          //                     .first) *
                                          //                 30)
                                          //             .toString() +
                                          //         ' Days',
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
                                              int.parse(loan['interestRate'])
                                                      .toStringAsFixed(2) +
                                                  " %",
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
                                          textValue:
                                              loan['loanType'] == "Monthly"
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
                                              loan['monthlyInterest']
                                                  .toStringAsFixed(2),
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
                                              loan['totalInterest']
                                                  .toStringAsFixed(2),
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
                                          textValue:
                                              loan['loanType'] == "Monthly"
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
                                              loan['monthlyCollection']
                                                  .toStringAsFixed(2),
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
                                          textValue: loan['loanType'] ==
                                                  "Monthly"
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
                                              loan['totalCollection']
                                                  .toStringAsFixed(2),
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
                                    getRowWidget(collectionHistoryList,
                                        notPaidDates, formattedDate),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: height * 5),
                            PositiveElevatedButton(
                              label: 'Collect',
                              onPressed: () {
                                updated(setState, '');
                                setState(() {
                                  amount = "0";
                                });
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context, setState) {
                                        return BottomSheet(
                                          onClosing: () {
                                            updated(setState, '');
                                          },
                                          builder: (context) {
                                            return Container(
                                              height: height * 100,
                                              color: white,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.all(width * 5.1),
                                                child: Column(
                                                  children: [
                                                    CustomTextBox(
                                                      textValue: 'Collect',
                                                      textSize: 7,
                                                      textWeight:
                                                          FontWeight.bold,
                                                      typeAlign:
                                                          Alignment.topLeft,
                                                      captionAlign:
                                                          TextAlign.left,
                                                      textColor: black,
                                                    ),
                                                    SizedBox(
                                                        height: height * 3),
                                                    CustomTextFormField(
                                                      enabled: !notPaid!,
                                                      label:
                                                          'Amount (last CR ${loan['currency']} ${loan['extraChange']})',
                                                      // controller: amountController,
                                                      initialValue: "0",
                                                      onChanged: (value) {
                                                        amount = value;
                                                      },
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: height * 1),
                                                    CustomTextFormField(
                                                      label: 'Date',
                                                      controller:
                                                          dateController,
                                                      initialValue:
                                                          formattedDate,
                                                      readOnly: true,
                                                    ),
                                                    CustomTextBox(
                                                      textValue: error!,
                                                      textSize: 4,
                                                      textWeight:
                                                          FontWeight.normal,
                                                      typeAlign:
                                                          Alignment.topLeft,
                                                      captionAlign:
                                                          TextAlign.left,
                                                      textColor: red,
                                                    ),
                                                    CustomCheckBox(
                                                      textField: "Not paid",
                                                      initValue: notPaid,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          notPaid = value;
                                                          value == true
                                                              ? amount = (loan[
                                                                          'monthlyCollection'] -
                                                                      loan[
                                                                          'extraChange'])
                                                                  .toString()
                                                              : amount = "0";
                                                        });
                                                        print(amount);
                                                      },
                                                    ),
                                                    SizedBox(
                                                        height: height * 3),
                                                    PositiveElevatedButton(
                                                      label: 'Collect',
                                                      onPressed: () async {
                                                        // check from top of the list -----------------
                                                        // int? falseIndex =
                                                        //     collectionHistoryList
                                                        //         .indexWhere(
                                                        //             (element) =>
                                                        //                 element
                                                        //                     .value ==
                                                        //                 false);

                                                        // int? todayIndex =
                                                        //     collectionHistoryList
                                                        //         .indexWhere(
                                                        //             (element) =>
                                                        //                 element
                                                        //                     .key ==
                                                        //                 '2022-02-27');
                                                        // print(falseIndex);
                                                        // print(todayIndex);
                                                        // print(
                                                        //     collectionHistoryList
                                                        //         .sublist(
                                                        //             0,
                                                        //             falseIndex +
                                                        //                 1));
                                                        //-----------------------------------------
                                                        // check from current day to top ----------
                                                        // if (loan['collectingDates'][formatter.format(DateTime(
                                                        //         int.parse(fDate
                                                        //             .split("-")
                                                        //             .first),
                                                        //         int.parse(
                                                        //             fDate.split(
                                                        //                     "-")[
                                                        //                 1]),
                                                        //         int.parse(fDate
                                                        //                 .split(
                                                        //                     "-")
                                                        //                 .last) -
                                                        //             1))] ==
                                                        //     false) {
                                                        //   print("false");
                                                        // }

                                                        //------------------------------------------
                                                        if (loan[
                                                                'acceptedDate'] ==
                                                            formattedDate) {
                                                          updated(setState,
                                                              'Loan Collection will be start from tomorrow.');
                                                        } else {
                                                          collectingDates = loan[
                                                              'collectingDates'];

                                                          print(double.parse(
                                                              amount!));
                                                          print((loan[
                                                                  'monthlyCollection'] -
                                                              loan[
                                                                  'extraChange']));
                                                          if (double.parse(
                                                                  amount!) >=
                                                              (loan['monthlyCollection'] -
                                                                  loan[
                                                                      'extraChange'])) {
                                                            print('passed 1');
                                                            updated(
                                                                setState, '');
                                                            setState(() {
                                                              extraChange = roundDouble(
                                                                  (double.parse(
                                                                          amount!) +
                                                                      loan[
                                                                          'extraChange'] -
                                                                      (loan[
                                                                          'monthlyCollection'])),
                                                                  2);
                                                            });

                                                            if (loan[
                                                                    'loanType'] ==
                                                                "Daily") {
                                                              if (loan['collectingDates']
                                                                      [
                                                                      formattedDate] ==
                                                                  false) {
                                                                if (loan[
                                                                        'notPaidDates']
                                                                    .contains(
                                                                        formattedDate)) {
                                                                  updated(
                                                                      setState,
                                                                      'Today is marked as not paid.');
                                                                } else {
                                                                  if (notPaid ==
                                                                      false) {
                                                                    updated(
                                                                        setState,
                                                                        '');
                                                                    if ((loan['collectingDates'][formattedDate] !=
                                                                            null) &&
                                                                        (loan['collectingDates'][formattedDate] ==
                                                                            false)) {
                                                                      collectingDates[
                                                                              formattedDate] =
                                                                          true;
                                                                      print(
                                                                          collectingDates);
                                                                      await loanRequestsCollection
                                                                          .doc(loan!
                                                                              .id)
                                                                          .update({
                                                                        'collectingDates':
                                                                            collectingDates,
                                                                        'extraChange':
                                                                            extraChange
                                                                      });
                                                                      await usersCollection
                                                                          .where(
                                                                              'companyName',
                                                                              isEqualTo: loan[
                                                                                  'companyName'])
                                                                          .where(
                                                                              'isAdmin',
                                                                              isEqualTo:
                                                                                  true)
                                                                          .get()
                                                                          .then(
                                                                              (user) async {
                                                                        print(user
                                                                            .docs
                                                                            .first
                                                                            .id);
                                                                        await usersCollection
                                                                            .doc(user.docs.first.id)
                                                                            .update({
                                                                          'capitalAmount':
                                                                              userDetails!.capitalAmount! + loan['monthlyCollection'],
                                                                          'collectionTotal':
                                                                              loan['monthlyCollection'] + userDetails.collectionTotal!,
                                                                        });

                                                                        await transactionsCollection
                                                                            .doc(user.docs.first.id)
                                                                            .update({
                                                                          'collection':
                                                                              FieldValue.arrayUnion([
                                                                            {
                                                                              'amount': loan['monthlyCollection'],
                                                                              'date': formattedDate,
                                                                              'loanId': loan!.id,
                                                                              'collector': userDetails.firstName,
                                                                              'loanUser': loan['userName'],
                                                                              'profit': loan['monthlyInterest'],
                                                                            },
                                                                          ]),
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    }
                                                                  } else {
                                                                    await usersCollection
                                                                        .doc(loan[
                                                                            'user'])
                                                                        .get()
                                                                        .then(
                                                                      (value) {
                                                                        setState(
                                                                            () {
                                                                          points =
                                                                              (value.data() as dynamic)['points'];
                                                                        });
                                                                      },
                                                                    );

                                                                    print(
                                                                        points);
                                                                    if (points! <=
                                                                        0) {
                                                                      await usersCollection
                                                                          .doc(loan[
                                                                              'user'])
                                                                          .update({
                                                                        'points':
                                                                            0,
                                                                      });
                                                                    } else {
                                                                      await usersCollection
                                                                          .doc(loan[
                                                                              'user'])
                                                                          .update({
                                                                        'points':
                                                                            points! -
                                                                                10,
                                                                      });
                                                                    }
                                                                    await loanRequestsCollection
                                                                        .doc(loan!
                                                                            .id)
                                                                        .update({
                                                                      'notPaidDates':
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        formattedDate
                                                                      ]),
                                                                    });

                                                                    setState(
                                                                        () {
                                                                      notPaid =
                                                                          false;
                                                                    });

                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                }
                                                                //TODO: add here
                                                              } else {
                                                                updated(
                                                                    setState,
                                                                    'Already paid');
                                                              }
                                                            } else {
                                                              if ((loan['collectingDates']
                                                                      [
                                                                      formattedDate] !=
                                                                  null)) {
                                                                print("run 1");
                                                                collectingDates[
                                                                        formattedDate] =
                                                                    true;
                                                                // print(collectingDates);
                                                                await loanRequestsCollection
                                                                    .doc(loan!
                                                                        .id)
                                                                    .update({
                                                                  'collectingDates':
                                                                      collectingDates,
                                                                  'extraChange':
                                                                      extraChange
                                                                });
                                                                await usersCollection
                                                                    .where(
                                                                        'companyName',
                                                                        isEqualTo:
                                                                            loan[
                                                                                'companyName'])
                                                                    .where(
                                                                        'isAdmin',
                                                                        isEqualTo:
                                                                            true)
                                                                    .get()
                                                                    .then(
                                                                        (user) {
                                                                  usersCollection
                                                                      .doc(user
                                                                          .docs
                                                                          .first
                                                                          .id)
                                                                      .update({
                                                                    'capitalAmount':
                                                                        userDetails!.capitalAmount! +
                                                                            loan['monthlyCollection'],
                                                                    'collectionTotal': loan[
                                                                            'monthlyCollection'] +
                                                                        userDetails
                                                                            .collectionTotal!,
                                                                    'collection':
                                                                        FieldValue
                                                                            .arrayUnion([
                                                                      {
                                                                        'amount':
                                                                            loan['monthlyCollection'],
                                                                        'date':
                                                                            formattedDate,
                                                                        'loanId':
                                                                            loan!.id,
                                                                        'collector':
                                                                            userDetails.firstName,
                                                                        'loanUser':
                                                                            loan['userName'],
                                                                        'profit':
                                                                            loan['monthlyInterest'],
                                                                      },
                                                                    ]),
                                                                  });
                                                                });
                                                              } else {
                                                                for (final mapEntry
                                                                    in collectingDates
                                                                        .entries) {
                                                                  final key =
                                                                      mapEntry
                                                                          .key;
                                                                  final value =
                                                                      mapEntry
                                                                          .value;

                                                                  int entryYear =
                                                                      int.parse(key
                                                                          .split(
                                                                              '-')
                                                                          .first);

                                                                  int entryMonth =
                                                                      int.parse(
                                                                          key.split(
                                                                              '-')[1]);

                                                                  int entryDay =
                                                                      int.parse(key
                                                                          .split(
                                                                              '-')
                                                                          .last);

                                                                  if (DateTime
                                                                          .now()
                                                                      .isBefore(DateTime(
                                                                          entryYear,
                                                                          entryMonth,
                                                                          entryDay))) {
                                                                    print(
                                                                        "run 2");
                                                                    print("a" +
                                                                        formatter.format(DateTime(
                                                                            entryYear,
                                                                            entryMonth,
                                                                            entryDay)));

                                                                    setState(
                                                                        () {
                                                                      dateList!.add(DateTime(
                                                                          entryYear,
                                                                          entryMonth,
                                                                          entryDay));
                                                                    });
                                                                  }
                                                                }
                                                                dateList!.sort((a,
                                                                        b) =>
                                                                    a.compareTo(
                                                                        b));

                                                                if (collectingDates[
                                                                        formatter
                                                                            .format(dateList![0])] ==
                                                                    false) {
                                                                  //TODO:
                                                                  collectingDates[
                                                                      formatter.format(
                                                                          dateList![
                                                                              0])] = true;
                                                                  print(
                                                                      "run 3");
                                                                  await loanRequestsCollection
                                                                      .doc(loan!
                                                                          .id)
                                                                      .update({
                                                                    'collectingDates':
                                                                        collectingDates,
                                                                    'extraChange':
                                                                        extraChange
                                                                  });
                                                                  await usersCollection
                                                                      .where(
                                                                          'companyName',
                                                                          isEqualTo: loan[
                                                                              'companyName'])
                                                                      .where(
                                                                          'isAdmin',
                                                                          isEqualTo:
                                                                              true)
                                                                      .get()
                                                                      .then(
                                                                          (user) {
                                                                    usersCollection
                                                                        .doc(user
                                                                            .docs
                                                                            .first
                                                                            .id)
                                                                        .update({
                                                                      'capitalAmount':
                                                                          userDetails!.capitalAmount! +
                                                                              loan['monthlyCollection'],
                                                                      'collectionTotal': loan[
                                                                              'monthlyCollection'] +
                                                                          userDetails
                                                                              .collectionTotal!,
                                                                      'collection':
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        {
                                                                          'amount':
                                                                              loan['monthlyCollection'],
                                                                          'date':
                                                                              formattedDate,
                                                                          'loanId':
                                                                              loan!.id,
                                                                          'collector':
                                                                              userDetails.firstName,
                                                                          'loanUser':
                                                                              loan['userName'],
                                                                          'profit':
                                                                              loan['monthlyInterest'],
                                                                        },
                                                                      ]),
                                                                    });
                                                                  });
                                                                } else {
                                                                  updated(
                                                                      setState,
                                                                      'Already paid');
                                                                }
                                                              }
                                                            }
                                                          } else {
                                                            updated(setState,
                                                                'Insufficient ammount');
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      });
                                    });
                              },
                            ),
                            SizedBox(height: height * 10),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Loading();
                  }
                },
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

Widget getRowWidget(List<MapEntry<String, dynamic>> singleRow,
    List notPaidDates, String? currentDate) {
  return Column(
      children: singleRow
          .map(
            (item) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                item.key == currentDate
                    ? CustomTextBox(
                        textValue: item.key,
                        textSize: 4.5,
                        textWeight: FontWeight.bold,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      )
                    : CustomTextBox(
                        textValue: item.key,
                        textSize: 4.0,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                item.value == false && notPaidDates.contains(item.key)
                    ? item.key == currentDate
                        ? CustomTextBox(
                            textValue: 'Not Paid',
                            textSize: 4.5,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: red,
                          )
                        : CustomTextBox(
                            textValue: 'Not Paid',
                            textSize: 4.0,
                            textWeight: FontWeight.normal,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: red,
                          )
                    : item.value == false
                        ? item.key == currentDate
                            ? CustomTextBox(
                                textValue: "Awaiting",
                                textSize: 4.5,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.topLeft,
                                captionAlign: TextAlign.left,
                                textColor: black,
                              )
                            : CustomTextBox(
                                textValue: "Awaiting",
                                textSize: 4.0,
                                textWeight: FontWeight.normal,
                                typeAlign: Alignment.topLeft,
                                captionAlign: TextAlign.left,
                                textColor: black,
                              )
                        : item.key == currentDate
                            ? CustomTextBox(
                                textValue: "Paid",
                                textSize: 4.5,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.topLeft,
                                captionAlign: TextAlign.left,
                                textColor: green!,
                              )
                            : CustomTextBox(
                                textValue: "Paid",
                                textSize: 4.0,
                                textWeight: FontWeight.normal,
                                typeAlign: Alignment.topLeft,
                                captionAlign: TextAlign.left,
                                textColor: green!,
                              ),
              ],
            ),
          )
          .toList());
}
