import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/admins/give_new_loan.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/admin_view_loan_card.dart';
import 'package:mcm/reusable_components/admins/user_not_accepted_loan_cards.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/reusable_components/requested_loan_card.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

class NewLoan extends StatefulWidget {
  NewLoan({Key? key}) : super(key: key);

  @override
  _NewLoanState createState() => _NewLoanState();
}

class _NewLoanState extends State<NewLoan> {
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

            return Scaffold(
              backgroundColor: white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: mainColor),
                elevation: 0.0,
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 5.0, vertical: width * 2.0),
                    child: PositiveHalfElevatedButton(
                      label: 'Refresh',
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(width * 5.1, 0, width * 5.1, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextBox(
                            textValue: 'Loans',
                            textSize: 10,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          PositiveHalfElevatedButton(
                            label: 'Add +',
                            onPressed: () {
                              Navigator.pushNamed(context, '/giveNewLoan',
                                  arguments: GiveNewLoanArgs(
                                      isAdmin: userDetails!.isAdmin));
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: height * 2),
                      SizedBox(
                        height: height * 80,
                        width: width * 100.0,
                        child: DefaultTabController(
                          length: 5,
                          child: Column(
                            children: [
                              TabBar(
                                isScrollable: true,
                                tabs: [
                                  CustomTextBox(
                                    textValue: 'New Loans',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: red,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Ongoing Loans',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'User not Accepted',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Closed Loans',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Rejected Loans',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 70,
                                width: width * 100,
                                child: Padding(
                                  padding: EdgeInsets.only(top: height * 2),
                                  child: TabBarView(
                                    children: [
                                      SizedBox(
                                        height: height * 80,
                                        child: FutureBuilder<QuerySnapshot>(
                                          future: loanRequestsCollection
                                              .where('companyName',
                                                  isEqualTo:
                                                      userDetails!.companyName)
                                              .where('status',
                                                  isEqualTo: 'requested')
                                              .get(),
                                          // initialData: InitialData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState !=
                                                ConnectionState.done) {
                                              return const Loading();
                                            } else {
                                              if (snapshot.hasData) {
                                                final loans = snapshot
                                                    .data!.docs
                                                    .toList();
                                                return ListView.builder(
                                                  itemCount: loans.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return RequestedLoanCard(
                                                        loan: loans[index]);
                                                  },
                                                );
                                              } else {
                                                return const Loading();
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 80,
                                        child: FutureBuilder<QuerySnapshot>(
                                          future: loanRequestsCollection
                                              .where('companyName',
                                                  isEqualTo:
                                                      userDetails.companyName)
                                              .where('status',
                                                  isEqualTo: 'okayed')
                                              .get(),
                                          // initialData: InitialData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState !=
                                                ConnectionState.done) {
                                              return const Loading();
                                            } else {
                                              if (snapshot.hasData) {
                                                final loans = snapshot
                                                    .data!.docs
                                                    .toList();
                                                return ListView.builder(
                                                  itemCount: loans.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return AdminViewLoanCard(
                                                      loan: loans[index],
                                                      isAdmin:
                                                          userDetails.isAdmin,
                                                    );
                                                  },
                                                );
                                              } else {
                                                return const Loading();
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 80,
                                        child: FutureBuilder<QuerySnapshot>(
                                          future: loanRequestsCollection
                                              .where('companyName',
                                                  isEqualTo:
                                                      userDetails.companyName)
                                              .where('status',
                                                  isEqualTo: 'accepted')
                                              .get(),
                                          // initialData: InitialData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState !=
                                                ConnectionState.done) {
                                              return const Loading();
                                            } else {
                                              if (snapshot.hasData) {
                                                final loans = snapshot
                                                    .data!.docs
                                                    .toList();
                                                return ListView.builder(
                                                  itemCount: loans.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return UserNotAcceptedLoanCard(
                                                        loan: loans[index]);
                                                  },
                                                );
                                              } else {
                                                return const Loading();
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 80,
                                        child: FutureBuilder<QuerySnapshot>(
                                          future: loanRequestsCollection
                                              .where('companyName',
                                                  isEqualTo:
                                                      userDetails.companyName)
                                              .where('status',
                                                  isEqualTo: 'closed')
                                              .get(),
                                          // initialData: InitialData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState !=
                                                ConnectionState.done) {
                                              return const Loading();
                                            } else {
                                              if (snapshot.hasData) {
                                                final loans = snapshot
                                                    .data!.docs
                                                    .toList();
                                                return ListView.builder(
                                                  itemCount: loans.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return RequestedLoanCard(
                                                        loan: loans[index]);
                                                  },
                                                );
                                              } else {
                                                return const Loading();
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 80,
                                        child: FutureBuilder<QuerySnapshot>(
                                          future: loanRequestsCollection
                                              .where('companyName',
                                                  isEqualTo:
                                                      userDetails.companyName)
                                              .where('status',
                                                  isEqualTo: 'rejected')
                                              .get(),
                                          // initialData: InitialData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState !=
                                                ConnectionState.done) {
                                              return const Loading();
                                            } else {
                                              if (snapshot.hasData) {
                                                final loans = snapshot
                                                    .data!.docs
                                                    .toList();
                                                return ListView.builder(
                                                  itemCount: loans.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return RequestedLoanCard(
                                                        loan: loans[index]);
                                                  },
                                                );
                                              } else {
                                                return const Loading();
                                              }
                                            }
                                          },
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
