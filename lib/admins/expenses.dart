import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

class Expenses extends StatefulWidget {
  Expenses({Key? key}) : super(key: key);

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
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
                            textValue: 'Expenses',
                            textSize: 10,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          PositiveHalfElevatedButton(
                            label: '+ Add',
                            onPressed: () {
                              Navigator.pushNamed(context, '/addNewExpenses');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: height * 2),
                      SizedBox(
                        height: height * 80,
                        width: width * 100.0,
                        child: DefaultTabController(
                          length: 9,
                          child: Column(
                            children: [
                              TabBar(
                                isScrollable: true,
                                tabs: [
                                  CustomTextBox(
                                    textValue: 'Day-to-day',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Foods',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Transport',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Family',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Telecomunication',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Vehicles',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Electronics',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Furnitures',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                  CustomTextBox(
                                    textValue: 'Presents',
                                    textSize: 5,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.center,
                                    captionAlign: TextAlign.center,
                                    textColor: mainFontColor,
                                  ),
                                ],
                              ),
                              Container(
                                height: height * 70,
                                width: width * 100,
                                child: Padding(
                                  padding: EdgeInsets.only(top: height * 2),
                                  child: TabBarView(
                                    children: [
                                      SingleExpense(
                                        height: height,
                                        user: user,
                                        userDetails: userDetails,
                                        category: "Day-to-day expenses",
                                      ),
                                      SingleExpense(
                                          height: height,
                                          user: user,
                                          userDetails: userDetails,
                                          category: "Foods"),
                                      SingleExpense(
                                        height: height,
                                        user: user,
                                        userDetails: userDetails,
                                        category: "Transport",
                                      ),
                                      SingleExpense(
                                        height: height,
                                        user: user,
                                        userDetails: userDetails,
                                        category: "Family",
                                      ),
                                      SingleExpense(
                                        height: height,
                                        user: user,
                                        userDetails: userDetails,
                                        category: "Telecomunication",
                                      ),
                                      SingleExpense(
                                        height: height,
                                        user: user,
                                        userDetails: userDetails,
                                        category: "Vehicles",
                                      ),
                                      SingleExpense(
                                        height: height,
                                        user: user,
                                        userDetails: userDetails,
                                        category: "Electronics",
                                      ),
                                      SingleExpense(
                                        height: height,
                                        user: user,
                                        userDetails: userDetails,
                                        category: "Furnitures",
                                      ),
                                      SingleExpense(
                                        height: height,
                                        user: user,
                                        userDetails: userDetails,
                                        category: "Presents",
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

class SingleExpense extends StatelessWidget {
  const SingleExpense({
    Key? key,
    required this.height,
    required this.user,
    required this.userDetails,
    required this.category,
  }) : super(key: key);
  final height;
  final user;
  final userDetails;
  final category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 80,
      child: FutureBuilder(
        future: transactionsCollection.doc(user.uid).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List expenses = snapshot.data!['expenses'].toList();
            List filteredExpenses = expenses
                .where((element) => element['category'] == category.toString())
                .toList();
            return ListView.builder(
              itemCount: filteredExpenses.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextBox(
                      textValue: filteredExpenses[index]['reason'],
                      textSize: 5.0,
                      textWeight: FontWeight.normal,
                      typeAlign: Alignment.topLeft,
                      captionAlign: TextAlign.left,
                      textColor: black,
                    ),
                    CustomTextBox(
                      textValue: userDetails!.currency! +
                          " " +
                          filteredExpenses[index]['amount'].toString(),
                      textSize: 5.0,
                      textWeight: FontWeight.normal,
                      typeAlign: Alignment.topRight,
                      captionAlign: TextAlign.right,
                      textColor: black,
                    ),
                  ],
                );
              },
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
