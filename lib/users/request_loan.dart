import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/custom_text_form_field.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

class RequestLoan extends StatefulWidget {
  RequestLoan({Key? key}) : super(key: key);

  @override
  _RequestLoanState createState() => _RequestLoanState();
}

class _RequestLoanState extends State<RequestLoan> {
  final _formKey = GlobalKey<FormState>();

  bool? loading = false;
  String? duration = "1 month";
  String? loanType = "Monthly";
  String? error = "";

  final amountController = TextEditingController();

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);

    String formattedDate = formatter.format(now);

    if (loading == false) {
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
                  padding:
                      EdgeInsets.fromLTRB(width * 5.1, 0, width * 5.1, 0.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: height * 2),
                          CustomTextBox(
                            textValue: 'Request a Loan',
                            textSize: 10,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          SizedBox(height: height * 2),
                          Column(
                            children: [
                              CustomTextFormField(
                                label: 'Amount (${userDetails!.currency})',
                                controller: amountController,
                                validator: (value) =>
                                    value!.isEmpty ? 'Enter the amount' : null,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              SizedBox(height: height * 2),
                              Column(
                                children: [
                                  CustomTextBox(
                                    textValue: 'Duration',
                                    textSize: 4,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  SizedBox(height: height * 0.5),
                                  Container(
                                    width: width * 90,
                                    height: height * 6.5,
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius:
                                          BorderRadius.circular(width * 3),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: DropdownButton<String?>(
                                        value: duration,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: mainColor,
                                        ),
                                        iconSize: width * 9,
                                        isExpanded: true,
                                        elevation: 16,
                                        style: const TextStyle(color: black),
                                        underline: Container(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            duration = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          '1 month',
                                          '2 month',
                                          '3 month',
                                          '6 month',
                                          '12 month',
                                          '24 month',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                fontSize: width * 5,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 2),
                              SizedBox(height: height * 2),
                              Column(
                                children: [
                                  CustomTextBox(
                                    textValue: 'Loan Type',
                                    textSize: 4,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  SizedBox(height: height * 0.5),
                                  Container(
                                    width: width * 90,
                                    height: height * 6.5,
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius:
                                          BorderRadius.circular(width * 3),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: DropdownButton<String?>(
                                        value: loanType,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: mainColor,
                                        ),
                                        iconSize: width * 9,
                                        isExpanded: true,
                                        elevation: 16,
                                        style: const TextStyle(color: black),
                                        underline: Container(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            loanType = newValue!;
                                          });
                                        },
                                        items: <String>[
                                          'Daily',
                                          'Monthly',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                fontSize: width * 5,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 2),
                              SizedBox(height: height * 1),
                              CustomTextBox(
                                textValue: error!,
                                textSize: 3.5,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.center,
                                captionAlign: TextAlign.left,
                                textColor: accentColor,
                              ),
                              SizedBox(height: height * 8),
                              PositiveElevatedButton(
                                label: 'Request Loan',
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    loanRequestsCollection.doc().set({
                                      'user': userDetails.uid,
                                      'userName': userDetails.firstName! +
                                          " " +
                                          userDetails.lastName!,
                                      'amount':
                                          int.parse(amountController.text),
                                      'duration': duration,
                                      'loanType': loanType,
                                      'companyName': userDetails.companyName,
                                      'currency': userDetails.currency,
                                      'createdDate': formattedDate,
                                      'status': 'requested',
                                    });
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                              SizedBox(height: height * 2),
                            ],
                          ),
                          SizedBox(height: height * 2),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Loading();
            }
          });
    } else {
      return const Loading();
    }
  }
}
