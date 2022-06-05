import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcm/admins/view_loan.dart';
import 'package:mcm/admins/view_user_not_accepted_loan.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';

class UserNotAcceptedLoanCard extends StatefulWidget {
  UserNotAcceptedLoanCard({Key? key, this.loan}) : super(key: key);
  final QueryDocumentSnapshot? loan;

  @override
  _UserNotAcceptedLoanCardState createState() =>
      _UserNotAcceptedLoanCardState();
}

class _UserNotAcceptedLoanCardState extends State<UserNotAcceptedLoanCard> {
  bool? isLoading = false;

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatter.format(now);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NegativeHalfElevatedButton(
                  label: 'Cancel',
                  onPressed: () {
                    loanRequestsCollection.doc(widget.loan!.id).update({
                      'status': 'rejected',
                      'rejectedDate': formattedDate,
                    });
                  },
                ),
                PositiveHalfElevatedButton(
                  label: 'View',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/viewUserNotAcceptedLoan',
                      arguments: ViewUserNotAcceptedLoanArgs(loan: widget.loan),
                    );
                  },
                ),
              ],
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
