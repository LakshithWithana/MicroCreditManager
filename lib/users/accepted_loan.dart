import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/accepeted_loan_card.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/reusable_components/requested_loan_card.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

class AcceptedLoan extends StatefulWidget {
  AcceptedLoan({Key? key}) : super(key: key);

  @override
  State<AcceptedLoan> createState() => _AcceptedLoanState();
}

class _AcceptedLoanState extends State<AcceptedLoan> {
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
                      CustomTextBox(
                        textValue: 'Accepted Loans',
                        textSize: 10,
                        textWeight: FontWeight.bold,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SizedBox(height: height * 2),
                      SizedBox(
                        height: height * 80,
                        child: FutureBuilder<QuerySnapshot>(
                          future: loanRequestsCollection
                              .where('user', isEqualTo: user.uid)
                              .where('status', isEqualTo: 'accepted')
                              .get(),
                          // initialData: InitialData,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              final loans = snapshot.data!.docs.toList();
                              return ListView.builder(
                                itemCount: loans.length,
                                itemBuilder: (context, index) {
                                  return AcceptedLoanCard(loan: loans[index]);
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
            );
          } else {
            return const Loading();
          }
        });
  }
}
