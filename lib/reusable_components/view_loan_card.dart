import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/admins/view_loan.dart';
import 'package:mcm/admins/view_single_customer.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:mcm/users/view_accepted_loan.dart';
import 'package:mcm/users/view_ok_loan.dart';

class ViewLoanCard extends StatefulWidget {
  ViewLoanCard({Key? key, this.loan}) : super(key: key);
  final QueryDocumentSnapshot? loan;

  @override
  _ViewLoanCardState createState() => _ViewLoanCardState();
}

class _ViewLoanCardState extends State<ViewLoanCard> {
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
                    textValue: loan['companyName'],
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
                        textValue: "  " + loan['amount'].toString(),
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
                        textValue: loan['monthlyCollection'].toString(),
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
                            '/viewOkLoan',
                            arguments: ViewOkLoanArgs(loan: widget.loan),
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
