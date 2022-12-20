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
  const AdminViewOkLoan({Key? key}) : super(key: key);

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

  bool? haveNotifications = false;
  Object? collectingDatesExtension = {};
  QueryDocumentSnapshot<Map<String, dynamic>>? loanExtensionRequestSnapshot;
  Map collectingDatesUpdated = {};
  List? collectingDatesUpdatedList = [];
  String? lastCollectingDate = "";

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

    checkNotificationsForExtensionRequests(String loanId, String lastDate) {
      FirebaseFirestore.instance
          .collection("loanExtentionRequests")
          .where("loanId", isEqualTo: loanId)
          .where("status", isEqualTo: "pending")
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          if (mounted) {
            setState(() {
              lastCollectingDate = lastDate;
              loanExtensionRequestSnapshot = value.docs.first;
              haveNotifications = true;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              haveNotifications = false;
            });
          }
        }
      });
    }

    // getLoanLastCollectingDate(String lastDate) {
    //   if (mounted) {
    //     setState(() {
    //       lastCollectingDate = lastDate;
    //     });
    //   }
    // }

    // getLoanLastCollectingDate();
    // print("last $lastCollectingDate");

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
                actions: haveNotifications == true
                    ? [
                        Padding(
                          padding: EdgeInsets.only(right: width * 5.0),
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder:
                                        (BuildContext context, setState) {
                                      return BottomSheet(
                                        enableDrag: false,
                                        onClosing: () {
                                          updated(setState, '');
                                        },
                                        builder: (context) {
                                          return Container(
                                            height: height * 45,
                                            color: white,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.all(width * 5.1),
                                              child: FutureBuilder(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection(
                                                        "loanExtentionRequests")
                                                    .where('loanId',
                                                        isEqualTo: args.loanId)
                                                    .get(),
                                                // initialData: InitialData,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot.hasData) {
                                                    final extensionRequest =
                                                        snapshot
                                                            .data!.docs.first;
                                                    return SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          CustomTextBox(
                                                            textValue:
                                                                'Customer Request',
                                                            textSize: 7,
                                                            textWeight:
                                                                FontWeight.bold,
                                                            typeAlign: Alignment
                                                                .topLeft,
                                                            captionAlign:
                                                                TextAlign.left,
                                                            textColor: black,
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  height * 3),
                                                          CustomTextBox(
                                                            textValue:
                                                                "This customer needs to extend the time period",
                                                            textSize: 5,
                                                            textWeight:
                                                                FontWeight
                                                                    .normal,
                                                            typeAlign: Alignment
                                                                .topLeft,
                                                            captionAlign:
                                                                TextAlign.left,
                                                            textColor:
                                                                Colors.grey,
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  height * 2),
                                                          Row(
                                                            children: [
                                                              CustomTextBox(
                                                                textValue:
                                                                    'Start Date: ',
                                                                textSize: 5,
                                                                textWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                typeAlign:
                                                                    Alignment
                                                                        .topLeft,
                                                                captionAlign:
                                                                    TextAlign
                                                                        .left,
                                                                textColor:
                                                                    black,
                                                              ),
                                                              CustomTextBox(
                                                                textValue:
                                                                    extensionRequest[
                                                                        'startingDate'],
                                                                textSize: 5,
                                                                textWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                typeAlign:
                                                                    Alignment
                                                                        .topLeft,
                                                                captionAlign:
                                                                    TextAlign
                                                                        .left,
                                                                textColor:
                                                                    Colors.grey,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  height * 1),
                                                          Row(
                                                            children: [
                                                              CustomTextBox(
                                                                textValue:
                                                                    'End Date: ',
                                                                textSize: 5,
                                                                textWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                typeAlign:
                                                                    Alignment
                                                                        .topLeft,
                                                                captionAlign:
                                                                    TextAlign
                                                                        .left,
                                                                textColor:
                                                                    black,
                                                              ),
                                                              CustomTextBox(
                                                                textValue:
                                                                    extensionRequest[
                                                                        'endingDate'],
                                                                textSize: 5,
                                                                textWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                typeAlign:
                                                                    Alignment
                                                                        .topLeft,
                                                                captionAlign:
                                                                    TextAlign
                                                                        .left,
                                                                textColor:
                                                                    Colors.grey,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  height * 1),
                                                          Row(
                                                            children: [
                                                              CustomTextBox(
                                                                textValue:
                                                                    'Duration: ',
                                                                textSize: 5,
                                                                textWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                typeAlign:
                                                                    Alignment
                                                                        .topLeft,
                                                                captionAlign:
                                                                    TextAlign
                                                                        .left,
                                                                textColor:
                                                                    black,
                                                              ),
                                                              CustomTextBox(
                                                                textValue:
                                                                    " ${extensionRequest['duration'].toString()} days",
                                                                textSize: 5,
                                                                textWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                typeAlign:
                                                                    Alignment
                                                                        .topLeft,
                                                                captionAlign:
                                                                    TextAlign
                                                                        .left,
                                                                textColor:
                                                                    Colors.grey,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  height * 3),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              NegativeHalfElevatedButton(
                                                                label:
                                                                    "Decline",
                                                                onPressed:
                                                                    () async {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "loanExtentionRequests")
                                                                      .where(
                                                                          "loanId",
                                                                          isEqualTo: args
                                                                              .loanId)
                                                                      .get()
                                                                      .then(
                                                                          (value) {
                                                                    if (value
                                                                        .docs
                                                                        .isNotEmpty) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "loanExtentionRequests")
                                                                          .doc(value
                                                                              .docs
                                                                              .first
                                                                              .id)
                                                                          .delete();
                                                                    }
                                                                  });
                                                                  setstate() {}

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              PositiveHalfElevatedButton(
                                                                label: "Accept",
                                                                onPressed:
                                                                    () async {
                                                                  collectingDatesUpdated =
                                                                      {
                                                                    for (var i =
                                                                            0;
                                                                        i <
                                                                            ((loanExtensionRequestSnapshot!.data() as dynamic)['duration'] +
                                                                                1);
                                                                        i++)
                                                                      formatter.format(DateTime(
                                                                          int.parse(lastCollectingDate!
                                                                              .split(
                                                                                  '-')
                                                                              .first),
                                                                          int.parse(lastCollectingDate!.split('-')[
                                                                              1]),
                                                                          int.parse(lastCollectingDate!.split('-').last) +
                                                                              i)): 0.00,
                                                                  };

                                                                  for (var i =
                                                                          0;
                                                                      i <
                                                                          ((loanExtensionRequestSnapshot!.data()
                                                                              as dynamic)['duration']);
                                                                      i++) {
                                                                    collectingDatesUpdatedList!.add(formatter.format(DateTime(
                                                                        int.parse(((loanExtensionRequestSnapshot!.data() as dynamic)['startingDate'])
                                                                            .split(
                                                                                '-')
                                                                            .first),
                                                                        int.parse(((loanExtensionRequestSnapshot!.data() as dynamic)['startingDate']).split('-')[
                                                                            1]),
                                                                        int.parse(((loanExtensionRequestSnapshot!.data() as dynamic)['startingDate']).split('-').last) +
                                                                            i)));
                                                                  }
                                                                  await loanRequestsCollection
                                                                      .doc(args
                                                                          .loanId)
                                                                      .set({
                                                                    "extentionStartDate":
                                                                        (loanExtensionRequestSnapshot!.data()
                                                                            as dynamic)['startingDate'],
                                                                    "extentionEndDate":
                                                                        (loanExtensionRequestSnapshot!.data()
                                                                            as dynamic)['endingDate'],
                                                                    "extentionDuration":
                                                                        (loanExtensionRequestSnapshot!.data()
                                                                            as dynamic)['duration'],
                                                                    "collectingDates":
                                                                        collectingDatesUpdated,
                                                                    "extendedDates":
                                                                        FieldValue.arrayUnion(
                                                                            collectingDatesUpdatedList!),
                                                                  }, SetOptions(merge: true));

                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "loanExtentionRequests")
                                                                      .where(
                                                                          "loanId",
                                                                          isEqualTo: args
                                                                              .loanId)
                                                                      .get()
                                                                      .then(
                                                                          (value) {
                                                                    if (value
                                                                        .docs
                                                                        .isNotEmpty) {
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "loanExtentionRequests")
                                                                          .doc(value
                                                                              .docs
                                                                              .first
                                                                              .id)
                                                                          .delete();
                                                                    }
                                                                  });
                                                                  setstate() {}
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  }
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    });
                                  });
                            },
                            icon: Icon(
                              Icons.notifications,
                              color: red,
                              size: width * 10,
                            ),
                          ),
                        ),
                      ]
                    : [
                        Padding(
                          padding: EdgeInsets.only(right: width * 5.0),
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder:
                                        (BuildContext context, setState) {
                                      return BottomSheet(
                                        onClosing: () {},
                                        builder: (context) {
                                          return Container(
                                            height: height * 10,
                                            color: white,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.all(width * 5.1),
                                              child: CustomTextBox(
                                                textValue:
                                                    "No new notifications.",
                                                textSize: 4,
                                                textWeight: FontWeight.normal,
                                                typeAlign: Alignment.topLeft,
                                                captionAlign: TextAlign.left,
                                                textColor: black,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    });
                                  });
                            },
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: black,
                              size: width * 10,
                            ),
                          ),
                        ),
                      ],
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
                    List extendedDates = loan['extendedDates'];

                    // print("last $lastCollectingDate");

                    // getLoanLastCollectingDate(collectionHistoryList.last.key);

                    checkNotificationsForExtensionRequests(
                        args.loanId!, collectionHistoryList.last.key);

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
                                              "${int.parse(loan['interestRate']).toStringAsFixed(2)} %",
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
                                              (loan['balance'])
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
                                    getRowWidget(
                                        collectionHistoryList,
                                        notPaidDates,
                                        formattedDate,
                                        extendedDates),
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
                                          enableDrag: false,
                                          onClosing: () {
                                            updated(setState, '');
                                          },
                                          builder: (context) {
                                            return Container(
                                              height: height * 150,
                                              color: white,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.all(width * 5.1),
                                                child: SingleChildScrollView(
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
                                                            'Amount (Due Amount ${loan['currency']} ${loan['totalCollection'] - loan['collectedMoney']})',
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
                                                      (((double.parse(amount!) -
                                                                      (loan['totalCollection'] -
                                                                          loan[
                                                                              'collectedMoney'])) >
                                                                  0) &&
                                                              (double.parse(
                                                                      amount!) !=
                                                                  null))
                                                          ? CustomTextBox(
                                                              textValue:
                                                                  "Change ${loan['currency']} ${double.parse(amount!) - (loan['totalCollection'] - loan['collectedMoney'])}",
                                                              textSize: 4,
                                                              textWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              typeAlign:
                                                                  Alignment
                                                                      .topLeft,
                                                              captionAlign:
                                                                  TextAlign
                                                                      .left,
                                                              textColor: red,
                                                            )
                                                          : const SizedBox(),
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
                                                            // if (double.parse(
                                                            //         amount!) >=
                                                            //     (loan['monthlyCollection'] -
                                                            //         loan[
                                                            //             'extraChange'])) {
                                                            print('passed 1');
                                                            updated(
                                                                setState, '');
                                                            // setState(() {
                                                            //   extraChange = roundDouble(
                                                            //       (double.parse(
                                                            //               amount!) +
                                                            //           loan[
                                                            //               'extraChange'] -
                                                            //           (loan[
                                                            //               'monthlyCollection'])),
                                                            //       2);
                                                            // });

                                                            if (loan[
                                                                    'loanType'] ==
                                                                "Daily") {
                                                              // if (loan['collectingDates']
                                                              //         [
                                                              //         formattedDate] ==
                                                              //     0) {
                                                              if (loan[
                                                                      'extendedDates']
                                                                  .contains(
                                                                      formattedDate)) {
                                                                updated(
                                                                    setState,
                                                                    'Today is marked as extended date.');
                                                              } else {
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

                                                                    if ((loan['collectedMoney'] +
                                                                            double.parse(
                                                                                amount!)) >
                                                                        loan[
                                                                            'totalCollection']) {
                                                                      showModalBottomSheet(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return BottomSheet(
                                                                                onClosing: () {},
                                                                                builder: (context) {
                                                                                  return SizedBox(
                                                                                    height: 200,
                                                                                    child: Padding(
                                                                                      padding: EdgeInsets.all(width * 5.1),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          CustomTextBox(
                                                                                            textValue: 'Oops!',
                                                                                            textSize: 5,
                                                                                            textWeight: FontWeight.bold,
                                                                                            typeAlign: Alignment.center,
                                                                                            captionAlign: TextAlign.left,
                                                                                            textColor: black,
                                                                                          ),
                                                                                          SizedBox(height: height * 3),
                                                                                          CustomTextBox(
                                                                                            textValue: "${loan['currency']} ${loan['totalCollection'] - loan['collectedMoney']} should be collected to close this loan.",
                                                                                            textSize: 4,
                                                                                            textWeight: FontWeight.normal,
                                                                                            typeAlign: Alignment.topLeft,
                                                                                            captionAlign: TextAlign.left,
                                                                                            textColor: black,
                                                                                          ),
                                                                                          const SizedBox(height: 20),
                                                                                          PositiveHalfElevatedButton(
                                                                                            label: "Ok",
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                });
                                                                          });
                                                                    } else {
                                                                      if ((loan['collectingDates'][formattedDate] !=
                                                                              null)
                                                                          //     &&
                                                                          // (loan['collectingDates'][formattedDate] ==
                                                                          //     0)
                                                                          ) {
                                                                        collectingDates[formattedDate] =
                                                                            FieldValue.increment(double.parse(amount!));
                                                                        print(
                                                                            collectingDates);
                                                                        await loanRequestsCollection
                                                                            .doc(loan!.id)
                                                                            .update({
                                                                          'collectingDates':
                                                                              collectingDates,
                                                                          'balance':
                                                                              FieldValue.increment(-double.parse(amount!)),
                                                                          // 'extraChange':
                                                                          //     extraChange
                                                                        });
                                                                        await usersCollection
                                                                            .where('companyName',
                                                                                isEqualTo: loan['companyName'])
                                                                            .where('isAdmin', isEqualTo: true)
                                                                            .get()
                                                                            .then((user) async {
                                                                          print(user
                                                                              .docs
                                                                              .first
                                                                              .id);
                                                                          await usersCollection
                                                                              .doc(user.docs.first.id)
                                                                              .update({
                                                                            // 'capitalAmount':
                                                                            //     userDetails!.capitalAmount! +
                                                                            //         loan['monthlyCollection'],
                                                                            // 'capitalAmount': userDetails!.capitalAmount! + double.parse(amount!),
                                                                            // 'collectionTotal':
                                                                            //     loan['monthlyCollection'] +
                                                                            //         userDetails.collectionTotal!,
                                                                            'collectionTotal':
                                                                                double.parse(amount!) + userDetails!.collectionTotal!,
                                                                          });

                                                                          await transactionsCollection
                                                                              .doc(user.docs.first.id)
                                                                              .update({
                                                                            'collection':
                                                                                FieldValue.arrayUnion([
                                                                              {
                                                                                // 'amount':
                                                                                //     loan['monthlyCollection'],
                                                                                'amount': double.parse(amount!),
                                                                                'date': formattedDate,
                                                                                'loanId': loan!.id,
                                                                                'collector': userDetails.firstName,
                                                                                'loanUser': loan['userName'],
                                                                                'profit': (loan['totalInterest'] / loan['totalCollection']) * double.parse(amount!),
                                                                              },
                                                                            ]),
                                                                          });

                                                                          await loanMoneyCollectionCollection
                                                                              .doc()
                                                                              .set({
                                                                            'amount':
                                                                                double.parse(amount!),
                                                                            'date':
                                                                                formattedDate,
                                                                            'loanId':
                                                                                loan!.id,
                                                                            'companyName':
                                                                                loan['companyName'],
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        });
                                                                      }
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
                                                              }

                                                              //TODO: add here
                                                              // } else {
                                                              //   updated(
                                                              //       setState,
                                                              //       'Already paid');
                                                              // }
                                                            } else {
                                                              if ((loan['collectingDates']
                                                                      [
                                                                      formattedDate] !=
                                                                  null)) {
                                                                print("run 1");
                                                                collectingDates[
                                                                    formattedDate] = 0;
                                                                // print(collectingDates);
                                                                await loanRequestsCollection
                                                                    .doc(loan!
                                                                        .id)
                                                                    .update({
                                                                  'collectingDates':
                                                                      collectingDates,
                                                                  'extraChange':
                                                                      extraChange,
                                                                  'balance': FieldValue
                                                                      .increment(
                                                                          -double.parse(
                                                                              amount!)),
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
                                                                        (user) async {
                                                                  await usersCollection
                                                                      .doc(user
                                                                          .docs
                                                                          .first
                                                                          .id)
                                                                      .update({
                                                                    // 'capitalAmount': userDetails!
                                                                    //         .capitalAmount! +
                                                                    //     double.parse(
                                                                    //         amount!),
                                                                    'collectionTotal': double.parse(
                                                                            amount!) +
                                                                        userDetails!
                                                                            .collectionTotal!,
                                                                    'collection':
                                                                        FieldValue
                                                                            .arrayUnion([
                                                                      {
                                                                        'amount':
                                                                            double.parse(amount!),
                                                                        'date':
                                                                            formattedDate,
                                                                        'loanId':
                                                                            loan!.id,
                                                                        'collector':
                                                                            userDetails.firstName,
                                                                        'loanUser':
                                                                            loan['userName'],
                                                                        'profit':
                                                                            (loan['totalInterest'] / loan['totalCollection']) *
                                                                                double.parse(amount!),
                                                                      },
                                                                    ]),
                                                                  });
                                                                  await loanMoneyCollectionCollection
                                                                      .doc()
                                                                      .set({
                                                                    'amount': double
                                                                        .parse(
                                                                            amount!),
                                                                    'date':
                                                                        formattedDate,
                                                                    'loanId':
                                                                        loan!
                                                                            .id,
                                                                    'companyName':
                                                                        loan[
                                                                            'companyName'],
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
                                                                    print(
                                                                        "a${formatter.format(DateTime(entryYear, entryMonth, entryDay))}");

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
                                                                    0) {
                                                                  //TODO:
                                                                  collectingDates[
                                                                          formatter
                                                                              .format(dateList![0])] !=
                                                                      0;
                                                                  print(
                                                                      "run 3");
                                                                  await loanRequestsCollection
                                                                      .doc(loan!
                                                                          .id)
                                                                      .update({
                                                                    'collectingDates':
                                                                        collectingDates,
                                                                    'extraChange':
                                                                        extraChange,
                                                                    'balance': FieldValue
                                                                        .increment(
                                                                            -double.parse(amount!)),
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
                                                                    await usersCollection
                                                                        .doc(user
                                                                            .docs
                                                                            .first
                                                                            .id)
                                                                        .update({
                                                                      // 'capitalAmount': userDetails!
                                                                      //         .capitalAmount! +
                                                                      //     double.parse(
                                                                      //         amount!),
                                                                      'collectionTotal': double.parse(
                                                                              amount!) +
                                                                          userDetails!
                                                                              .collectionTotal!,
                                                                      'collection':
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        {
                                                                          'amount':
                                                                              double.parse(amount!),
                                                                          'date':
                                                                              formattedDate,
                                                                          'loanId':
                                                                              loan!.id,
                                                                          'collector':
                                                                              userDetails.firstName,
                                                                          'loanUser':
                                                                              loan['userName'],
                                                                          'profit':
                                                                              (loan['totalInterest'] / loan['totalCollection']) * double.parse(amount!),
                                                                        },
                                                                      ]),
                                                                    });
                                                                    await loanMoneyCollectionCollection
                                                                        .doc()
                                                                        .set({
                                                                      'amount':
                                                                          double.parse(
                                                                              amount!),
                                                                      'date':
                                                                          formattedDate,
                                                                      'loanId':
                                                                          loan!
                                                                              .id,
                                                                      'companyName':
                                                                          loan[
                                                                              'companyName'],
                                                                    });
                                                                  });
                                                                } else {
                                                                  updated(
                                                                      setState,
                                                                      'Already paid');
                                                                }
                                                              }
                                                            }
                                                            // } else {
                                                            //   updated(setState,
                                                            //       'Insufficient ammount');
                                                            // }
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
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
    List notPaidDates, String? currentDate, List extendedDates) {
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
                        textColor: notPaidDates.contains(item.key)
                            ? red
                            : extendedDates.contains(item.key)
                                ? Colors.yellow.shade700
                                : black,
                      )
                    : CustomTextBox(
                        textValue: item.key,
                        textSize: 4.0,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: notPaidDates.contains(item.key)
                            ? red
                            : extendedDates.contains(item.key)
                                ? Colors.yellow.shade700
                                : black,
                      ),

                item.key == currentDate
                    ? CustomTextBox(
                        textValue: notPaidDates.contains(item.key)
                            ? "Not Paid"
                            : item.value.toString(),
                        textSize: 4.5,
                        textWeight: FontWeight.bold,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: notPaidDates.contains(item.key)
                            ? red
                            : extendedDates.contains(item.key)
                                ? Colors.yellow.shade700
                                : black,
                      )
                    : CustomTextBox(
                        textValue: notPaidDates.contains(item.key)
                            ? "Not Paid"
                            : item.value.toString(),
                        textSize: 4.0,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: notPaidDates.contains(item.key)
                            ? red
                            : extendedDates.contains(item.key)
                                ? Colors.yellow.shade700
                                : black,
                      ),

                // item.value == 0 && notPaidDates.contains(item.key)
                //     ? item.key == currentDate
                //         ? CustomTextBox(
                //             textValue: 'Not Paid',
                //             textSize: 4.5,
                //             textWeight: FontWeight.bold,
                //             typeAlign: Alignment.topLeft,
                //             captionAlign: TextAlign.left,
                //             textColor: red,
                //           )
                //         : CustomTextBox(
                //             textValue: 'Not Paid',
                //             textSize: 4.0,
                //             textWeight: FontWeight.normal,
                //             typeAlign: Alignment.topLeft,
                //             captionAlign: TextAlign.left,
                //             textColor: red,
                //           )
                //     : const SizedBox(),
                // : item.value == 0
                //     ? item.key == currentDate
                //         ? CustomTextBox(
                //             textValue: "Awaiting",
                //             textSize: 4.5,
                //             textWeight: FontWeight.bold,
                //             typeAlign: Alignment.topLeft,
                //             captionAlign: TextAlign.left,
                //             textColor: black,
                //           )
                //         : CustomTextBox(
                //             textValue: "Awaiting",
                //             textSize: 4.0,
                //             textWeight: FontWeight.normal,
                //             typeAlign: Alignment.topLeft,
                //             captionAlign: TextAlign.left,
                //             textColor: black,
                //           )
                //     : item.key == currentDate
                //         ? CustomTextBox(
                //             textValue: "Paid",
                //             textSize: 4.5,
                //             textWeight: FontWeight.bold,
                //             typeAlign: Alignment.topLeft,
                //             captionAlign: TextAlign.left,
                //             textColor: green!,
                //           )
                //         : CustomTextBox(
                //             textValue: "Paid",
                //             textSize: 4.0,
                //             textWeight: FontWeight.normal,
                //             typeAlign: Alignment.topLeft,
                //             captionAlign: TextAlign.left,
                //             textColor: green!,
                //           ),
              ],
            ),
          )
          .toList());
}
