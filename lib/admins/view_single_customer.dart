import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/reusable_components/admin_view_loan_card.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/reusable_components/ratings.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';

class ViewSingleCustomerArgs {
  final QueryDocumentSnapshot? userProfile;
  final bool? isAdmin;
  ViewSingleCustomerArgs(this.userProfile, this.isAdmin);
}

class ViewSingleCustomer extends StatefulWidget {
  ViewSingleCustomer({Key? key}) : super(key: key);

  @override
  State<ViewSingleCustomer> createState() => _ViewSingleCustomerState();
}

class _ViewSingleCustomerState extends State<ViewSingleCustomer> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final args =
        ModalRoute.of(context)!.settings.arguments as ViewSingleCustomerArgs;

    final userData = (args.userProfile!.data() as Map);

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
                textValue: userData['firstName'] + " " + userData['lastName'],
                textSize: 7,
                textWeight: FontWeight.bold,
                typeAlign: Alignment.topLeft,
                captionAlign: TextAlign.left,
                textColor: black,
              ),
              SizedBox(height: height * 2),
              Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextBox(
                            textValue: 'User ID',
                            textSize: 4.0,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          CustomTextBox(
                            textValue: userData['userId'],
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
                            textValue: 'Government ID',
                            textSize: 4.0,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          CustomTextBox(
                            textValue: userData['govtID'],
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
                            textValue: 'Email',
                            textSize: 4.0,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          CustomTextBox(
                            textValue: userData['email'],
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
                            textValue: 'Accounts ID',
                            textSize: 4.0,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          CustomTextBox(
                            textValue: userData['accountIds'][0],
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
                            textValue: 'Rating Score',
                            textSize: 4.0,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          Rating(totalPoints: userData['points']),
                        ],
                      ),
                      SizedBox(height: height * 1),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 3),
              CustomTextBox(
                textValue: "Loans",
                textSize: 6,
                textWeight: FontWeight.bold,
                typeAlign: Alignment.topLeft,
                captionAlign: TextAlign.left,
                textColor: black,
              ),
              // SizedBox(height: height * 2),
              SizedBox(
                height: height * 70,
                width: width * 100,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 2),
                      child: SizedBox(
                        height: height * 40,
                        child: FutureBuilder<QuerySnapshot>(
                          future: loanRequestsCollection
                              .where('user', isEqualTo: args.userProfile!.id)
                              .where('status', isEqualTo: 'okayed')
                              .get(),
                          // initialData: InitialData,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              final loans = snapshot.data!.docs.toList();
                              return ListView.builder(
                                itemCount: loans.length,
                                itemBuilder: (context, index) {
                                  return AdminViewLoanCard(
                                    loan: loans[index],
                                    isAdmin: args.isAdmin,
                                  );
                                },
                              );
                            } else {
                              return const Loading();
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: height * 2),
                    PositiveElevatedButton(
                      label: 'Add a Loan',
                      onPressed: () {
                        Navigator.pushNamed(context, '/giveNewLoan');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
