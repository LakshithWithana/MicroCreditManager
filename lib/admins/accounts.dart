import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

class Accounts extends StatefulWidget {
  Accounts({Key? key}) : super(key: key);

  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
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
                            textValue: 'Accounts',
                            textSize: 10,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          // PositiveHalfElevatedButton(
                          //   label: '+ Add',
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, '/addNewExpenses');
                          //   },
                          // ),
                        ],
                      ),
                      SizedBox(height: height * 2),
                      Container(
                        height: height * 80,
                        width: width * 100.0,
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              TabBar(
                                // isScrollable: true,
                                tabs: [
                                  CustomTextBox(
                                    textValue: 'Deposits',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Loans',
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
                                        child: Column(
                                          children: [
                                            // ? Desposits ---------------------
                                            SizedBox(
                                              height: height * 60,
                                              child:
                                                  FutureBuilder<QuerySnapshot>(
                                                future: depositsCollection
                                                    .where('companyName',
                                                        isEqualTo: userDetails!
                                                            .companyName)
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
                                                        return ExpansionTile(
                                                          childrenPadding:
                                                              EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          10),
                                                          title: Column(
                                                            children: [
                                                              CustomTextBox(
                                                                textValue: userDetails
                                                                        .currency! +
                                                                    " " +
                                                                    expenses[index]
                                                                            [
                                                                            'amount']
                                                                        .toStringAsFixed(
                                                                            2),
                                                                textSize: 5.0,
                                                                textWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                                textValue: expenses[
                                                                        index][
                                                                    'customerName'],
                                                                textSize: 4.0,
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
                                                            ],
                                                          ),
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                CustomTextBox(
                                                                  textValue:
                                                                      'Interest',
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
                                                                  textColor:
                                                                      black,
                                                                ),
                                                                CustomTextBox(
                                                                  textValue: expenses[index]
                                                                              [
                                                                              'interestRate']
                                                                          .toStringAsFixed(
                                                                              2) +
                                                                      " %",
                                                                  textSize: 5.0,
                                                                  textWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  typeAlign:
                                                                      Alignment
                                                                          .topLeft,
                                                                  captionAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  textColor:
                                                                      black,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  height * 3,
                                                            )
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
                                      // ? Loans -------------------------------
                                      SizedBox(
                                        height: height * 80,
                                        child: FutureBuilder<QuerySnapshot>(
                                          future: loanRequestsCollection
                                              .where('status',
                                                  isEqualTo: 'okayed')
                                              .where('companyName',
                                                  isEqualTo:
                                                      userDetails.companyName)
                                              .get(),
                                          // initialData: InitialData,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasData) {
                                              final loans =
                                                  snapshot.data!.docs.toList();
                                              return ListView.builder(
                                                itemCount: loans.length,
                                                itemBuilder: (context, index) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomTextBox(
                                                        textValue: loans[index]
                                                            ['userName'],
                                                        textSize: 5.0,
                                                        textWeight:
                                                            FontWeight.normal,
                                                        typeAlign:
                                                            Alignment.topLeft,
                                                        captionAlign:
                                                            TextAlign.left,
                                                        textColor: black,
                                                      ),
                                                      CustomTextBox(
                                                        textValue: userDetails
                                                                .currency! +
                                                            " " +
                                                            loans[index]
                                                                    ['amount']
                                                                .toString(),
                                                        textSize: 5.0,
                                                        textWeight:
                                                            FontWeight.normal,
                                                        typeAlign:
                                                            Alignment.topRight,
                                                        captionAlign:
                                                            TextAlign.right,
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
