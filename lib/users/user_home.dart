import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/accepeted_loan_card.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/reusable_components/view_loan_card.dart';
import 'package:mcm/services/auth_services.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

class UserHome extends StatefulWidget {
  UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  bool? isNotification = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);

    return StreamBuilder<UserDetails>(
        stream: DatabaseServices(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;

            loanRequestsCollection
                .where('user', isEqualTo: userDetails!.uid)
                .where('status', isEqualTo: 'accepted')
                .get()
                .then((value) {
              if (mounted) {
                if (value.docs.isNotEmpty) {
                  setState(() {
                    isNotification = true;
                  });
                } else {
                  setState(() {
                    isNotification = false;
                  });
                }
              }
            });

            return Scaffold(
              backgroundColor: white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: mainColor),
                elevation: 0.0,
                actions: isNotification == true
                    ? [
                        Padding(
                          padding: EdgeInsets.only(right: width * 5.0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/acceptedLoan');
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
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: mainColor,
                      ),
                      child: CustomTextBox(
                        textValue: 'Micro Credit Manager',
                        textSize: 4,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                    ),
                    ListTile(
                      title: CustomTextBox(
                        textValue: 'Home',
                        textSize: 5,
                        textWeight: FontWeight.bold,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: CustomTextBox(
                        textValue: 'Request a loan',
                        textSize: 5,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/requestLoan');
                      },
                    ),
                    ListTile(
                      title: CustomTextBox(
                        textValue: 'Settings',
                        textSize: 5,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/userSettings');
                      },
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(width * 5.1, 0, width * 5.1, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height * 2),
                      CustomTextBox(
                        textValue: 'Customer Home',
                        textSize: 10,
                        textWeight: FontWeight.bold,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SizedBox(height: height * 2),
                      Container(
                        height: height * 75,
                        width: width * 100.0,
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              TabBar(
                                tabs: [
                                  CustomTextBox(
                                    textValue: 'My Loans',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Deposits',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                ],
                              ),
                              Container(
                                height: height * 70,
                                width: width * 100,
                                child: Padding(
                                  padding: EdgeInsets.only(top: height * 2),
                                  child: TabBarView(
                                    children: [
                                      SizedBox(
                                        height: height * 80,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: height * 60,
                                              child:
                                                  FutureBuilder<QuerySnapshot>(
                                                future: loanRequestsCollection
                                                    .where('user',
                                                        isEqualTo: user.uid)
                                                    .where('companyName',
                                                        isEqualTo: userDetails
                                                            .companyName)
                                                    .where('status',
                                                        isEqualTo: 'okayed')
                                                    .get(),
                                                // initialData: InitialData,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot.hasData) {
                                                    final loans = snapshot
                                                        .data!.docs
                                                        .toList();
                                                    return ListView.builder(
                                                      itemCount: loans.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ViewLoanCard(
                                                            loan: loans[index]);
                                                      },
                                                    );
                                                  } else {
                                                    return const Loading();
                                                  }
                                                },
                                              ),
                                            ),
                                            PositiveElevatedButton(
                                              label: 'Request a Loan',
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/requestLoan');
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 80,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: height * 60,
                                              child:
                                                  FutureBuilder<QuerySnapshot>(
                                                future: depositsCollection
                                                    .where('userId',
                                                        isEqualTo:
                                                            userDetails.uid)
                                                    .get(),
                                                // initialData: InitialData,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot.hasData) {
                                                    final expenses = snapshot
                                                        .data!.docs
                                                        .toList();
                                                    return ListView.builder(
                                                      itemCount:
                                                          expenses.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            CustomTextBox(
                                                              textValue: expenses[
                                                                      index][
                                                                  'customerName'],
                                                              textSize: 5.0,
                                                              textWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              typeAlign:
                                                                  Alignment
                                                                      .topLeft,
                                                              captionAlign:
                                                                  TextAlign
                                                                      .left,
                                                              textColor: black,
                                                            ),
                                                            CustomTextBox(
                                                              textValue: userDetails
                                                                      .currency! +
                                                                  " " +
                                                                  expenses[index]
                                                                          [
                                                                          'amount']
                                                                      .toString(),
                                                              textSize: 5.0,
                                                              textWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              typeAlign:
                                                                  Alignment
                                                                      .topRight,
                                                              captionAlign:
                                                                  TextAlign
                                                                      .right,
                                                              textColor: black,
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    return const Loading();
                                                  }
                                                },
                                              ),
                                            ),
                                            PositiveElevatedButton(
                                              label: 'Add a Deposit',
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/addNewDeposit');
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
