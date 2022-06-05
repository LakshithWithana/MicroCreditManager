import 'package:cloud_firestore/cloud_firestore.dart';
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

class AddNewExpense extends StatefulWidget {
  AddNewExpense({Key? key}) : super(key: key);

  @override
  State<AddNewExpense> createState() => _AddNewExpenseState();
}

class _AddNewExpenseState extends State<AddNewExpense> {
  final _formKey = GlobalKey<FormState>();
  String? error = "";
  final reasonController = TextEditingController();
  final amountController = TextEditingController();
  String? category = 'Day-to-day expenses';
  double? totalExpenses = 0.00;

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextBox(
                              textValue: 'Add Expense',
                              textSize: 10,
                              textWeight: FontWeight.bold,
                              typeAlign: Alignment.topLeft,
                              captionAlign: TextAlign.left,
                              textColor: black,
                            ),
                          ],
                        ),
                        SizedBox(height: height * 2),
                        Column(
                          children: [
                            CustomTextBox(
                              textValue: 'Category',
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
                                borderRadius: BorderRadius.circular(width * 3),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: DropdownButton<String?>(
                                  value: category,
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
                                      category = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'Day-to-day expenses',
                                    'Foods',
                                    'Transport',
                                    'Family',
                                    'Telecomunication',
                                    'Vehicles',
                                    'Electronics',
                                    'Furnitures',
                                    'Presents',
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
                        Column(
                          children: [
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
                                  label: 'Reason',
                                  controller: reasonController,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter a reason' : null,
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
                              label: 'Add expense',
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  await transactionsCollection
                                      .doc(user.uid)
                                      .get()
                                      .then((value) {
                                    setState(() {
                                      totalExpenses = (value.data()
                                              as dynamic)['totalExpenses']
                                          .toDouble();
                                    });
                                  });
                                  await transactionsCollection
                                      .doc(user.uid)
                                      .update({
                                    'expenses': FieldValue.arrayUnion([
                                      {
                                        'userId': userDetails.uid,
                                        'category': category,
                                        'amount':
                                            int.parse(amountController.text),
                                        'reason': reasonController.text,
                                        'date': formattedDate,
                                      }
                                    ]),
                                    'totalExpenses': totalExpenses! +
                                        double.parse(amountController.text),
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
            return Loading();
          }
        });
  }
}
