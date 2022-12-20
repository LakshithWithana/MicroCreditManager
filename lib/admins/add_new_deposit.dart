import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/custom_checkbox.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/custom_text_form_field.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

import '../reusable_components/text_input_formatters.dart';

class AddNewDeposit extends StatefulWidget {
  const AddNewDeposit({Key? key}) : super(key: key);

  @override
  State<AddNewDeposit> createState() => _AddNewDepositState();
}

class _AddNewDepositState extends State<AddNewDeposit> {
  final _formKey = GlobalKey<FormState>();
  String? error = "";
  final customerNameController = TextEditingController();
  String? customerName = "";
  final customerIdController = TextEditingController();
  final interestController = TextEditingController();
  final amountController = TextEditingController();
  bool? isExistingCustomer = false;

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  bool? loading = false;

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatter.format(now);

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
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: height * 2),
                        CustomTextBox(
                          textValue: 'Add New Deposit',
                          textSize: 10,
                          textWeight: FontWeight.bold,
                          typeAlign: Alignment.topLeft,
                          captionAlign: TextAlign.left,
                          textColor: black,
                        ),
                        SizedBox(height: height * 2),
                        SizedBox(height: height * 2),
                        Column(
                          children: [
                            CustomCheckBox(
                              textField: 'Existing Customer ?',
                              initValue: isExistingCustomer,
                              onChanged: (value) {
                                setState(() {
                                  isExistingCustomer = value;
                                });
                              },
                            ),
                            SizedBox(height: height * 2),
                            isExistingCustomer == false
                                ? CustomTextFormField(
                                    label: 'Customer Name',
                                    controller: customerNameController,
                                  )
                                : Column(
                                    children: [
                                      CustomTextFormField(
                                        label: 'Customer Id',
                                        controller: customerIdController,
                                        onChanged: (value) {
                                          usersCollection
                                              .where("userId", isEqualTo: value)
                                              .get()
                                              .then((user) {
                                            if (user.docs.isNotEmpty) {
                                              setState(() {
                                                customerName = (user.docs.first
                                                            .data() as dynamic)[
                                                        'firstName'] +
                                                    " " +
                                                    (user.docs.first.data()
                                                        as dynamic)['lastName'];
                                              });
                                            } else {
                                              setState(() {
                                                customerName = "No user found";
                                              });
                                            }
                                          });
                                        },
                                      ),
                                      Row(
                                        children: [
                                          CustomTextBox(
                                            textValue: "Customer Name:",
                                            textSize: 4.0,
                                            textWeight: FontWeight.normal,
                                            typeAlign: Alignment.topLeft,
                                            captionAlign: TextAlign.left,
                                            textColor: secondaryColor,
                                          ),
                                          SizedBox(width: width * 5),
                                          CustomTextBox(
                                            textValue: customerName!,
                                            textSize: 4.0,
                                            textWeight: FontWeight.normal,
                                            typeAlign: Alignment.topLeft,
                                            captionAlign: TextAlign.left,
                                            textColor: accentColor,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 1),
                                    ],
                                  ),
                            CustomTextFormField(
                              label: "Amount (${userDetails!.currency!})",
                              controller: amountController,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter a amount' : null,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                            SizedBox(height: height * 1),
                            Column(
                              children: [
                                CustomTextFormField(
                                  label: 'Interest rate',
                                  controller: interestController,
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter a interest rate'
                                      : null,
                                  inputFormatters: <TextInputFormatter>[
                                    // FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9\\.]")),
                                    DecimalTextInputFormatter(decimalRange: 2),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height * 2),
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
                              label: 'Add Deposit',
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  depositsCollection.doc().set({
                                    'companyName': userDetails.companyName,
                                    'userId': userDetails.uid,
                                    'customerName': isExistingCustomer == true
                                        ? customerName
                                        : customerNameController.text,
                                    'amount': int.parse(amountController.text),
                                    'interestRate':
                                        double.parse(interestController.text),
                                    'date': formattedDate,
                                  });
                                  await usersCollection
                                      .where('companyName',
                                          isEqualTo: userDetails.companyName)
                                      .where('isAdmin', isEqualTo: true)
                                      .get()
                                      .then((user) {
                                    usersCollection
                                        .doc(user.docs.first.id)
                                        .update({
                                      // 'capitalAmount':
                                      //     userDetails.capitalAmount! +
                                      //         int.parse(amountController.text),
                                      'totalDeposits':
                                          userDetails.totalDeposits! +
                                              int.parse(amountController.text),
                                    });
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
  }
}
