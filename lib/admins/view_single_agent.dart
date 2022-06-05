import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/reusable_components/custom_checkbox.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';

class ViewSingleAgentArgs {
  final QueryDocumentSnapshot? userProfile;
  ViewSingleAgentArgs(this.userProfile);
}

class ViewSingleAgent extends StatefulWidget {
  ViewSingleAgent({Key? key}) : super(key: key);

  @override
  State<ViewSingleAgent> createState() => _ViewSingleAgentState();
}

class _ViewSingleAgentState extends State<ViewSingleAgent> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final args =
        ModalRoute.of(context)!.settings.arguments as ViewSingleAgentArgs;

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
                            textValue: 'Agent ID',
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 3),
              CustomTextBox(
                textValue: "Powers",
                textSize: 6,
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
                      CustomCheckBox(
                        textField: 'Add Customers',
                        initValue: userData['viewCustomer'],
                        onChanged: (value) {},
                      ),
                      CustomCheckBox(
                        textField: 'View Deposits',
                        initValue: userData['deposits'],
                        onChanged: (value) {},
                      ),
                      CustomCheckBox(
                        textField: 'Accept Loans',
                        initValue: userData['newLoans'],
                        onChanged: (value) {},
                      ),
                      CustomCheckBox(
                        textField: 'View Expenses',
                        initValue: userData['expenses'],
                        onChanged: (value) {},
                      ),
                      CustomCheckBox(
                        textField: 'View Accounts',
                        initValue: userData['accounts'],
                        onChanged: (value) {},
                      ),
                      CustomCheckBox(
                        textField: 'View Statistics',
                        initValue: userData['statistics'],
                        onChanged: (value) {},
                      ),
                      CustomCheckBox(
                        textField: 'Downloads',
                        initValue: userData['downloads'],
                        onChanged: (value) {},
                      ),
                      SizedBox(height: height * 1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
