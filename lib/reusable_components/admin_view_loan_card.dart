import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/admins/admin_view_ok_loan.dart';
import 'package:mcm/admins/view_loan.dart';
import 'package:mcm/admins/view_single_customer.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:mcm/users/view_accepted_loan.dart';
import 'package:mcm/users/view_ok_loan.dart';

class AdminViewLoanCard extends StatefulWidget {
  AdminViewLoanCard({Key? key, this.loan, this.isAdmin}) : super(key: key);
  final QueryDocumentSnapshot? loan;
  final bool? isAdmin;

  @override
  _AdminViewLoanCardState createState() => _AdminViewLoanCardState();
}

class _AdminViewLoanCardState extends State<AdminViewLoanCard> {
  bool? isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final loan = (widget.loan!.data() as dynamic);

    return GestureDetector(
      child: Card(
        color: backgroundColor,
        child: Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextBox(
                    textValue: loan['userName'],
                    textSize: 5.0,
                    textWeight: FontWeight.normal,
                    typeAlign: Alignment.topLeft,
                    captionAlign: TextAlign.left,
                    textColor: black,
                  ),
                  Row(
                    children: [
                      CustomTextBox(
                        textValue: loan['currency'],
                        textSize: 4.0,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      CustomTextBox(
                        textValue: "  " + loan['amount'].toStringAsFixed(2),
                        textSize: 5.0,
                        textWeight: FontWeight.bold,
                        typeAlign: Alignment.topRight,
                        captionAlign: TextAlign.right,
                        textColor: black,
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: CustomTextBox(
                textValue: loan['duration'].toString(),
                textSize: 4.0,
                textWeight: FontWeight.normal,
                typeAlign: Alignment.topLeft,
                captionAlign: TextAlign.left,
                textColor: secondaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextBox(
                        textValue: loan['loanType'] == "Monthly"
                            ? 'Monthly payment'
                            : 'Daily payment',
                        textSize: 4.0,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      CustomTextBox(
                        textValue: loan['currency'] +
                            " " +
                            loan['monthlyCollection'].toStringAsFixed(2),
                        textSize: 4.0,
                        textWeight: FontWeight.normal,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                    ],
                  ),
                  // CustomTextBox(
                  //   textValue: "Every month ${(loan['okDate']).toString().split('-').last} ",
                  //   // "Every month ${(loan['okDate']).toString().substring(0, (loan['okDate']).toString().lastIndexOf('-') + 1)} ",
                  //   textSize: 4.0,
                  //   textWeight: FontWeight.normal,
                  //   typeAlign: Alignment.topLeft,
                  //   captionAlign: TextAlign.left,
                  //   textColor: secondaryColor,
                  // ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // NegativeHalfElevatedButton(
                      //   label: 'Decline',
                      //   onPressed: () {
                      //     loanRequestsCollection.doc(widget.loan!.id).update({
                      //       'status': 'rejected',
                      //     });
                      //   },
                      // ),
                      PositiveHalfElevatedButton(
                        label: 'View',
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/adminViewOkLoan',
                            arguments: AdminViewOkLoanArgs(
                              loanId: widget.loan!.id,
                              isAdmin: widget.isAdmin,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
      onTap: () {
        // Navigator.pushNamed(
        //   context,
        //   '/viewSingleCustomer',
        //   arguments: ViewSingleCustomerArgs(widget.userProfile),
        // );
      },
    );
  }
}
