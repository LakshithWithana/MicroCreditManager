import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/reusable_components/user_card.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

class ViewCustomers extends StatefulWidget {
  ViewCustomers({Key? key}) : super(key: key);

  @override
  _ViewCustomersState createState() => _ViewCustomersState();
}

class _ViewCustomersState extends State<ViewCustomers> {
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
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 5.0, vertical: width * 2.0),
                    child: PositiveHalfElevatedButton(
                      label: 'Refresh',
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ),
                ],
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
                            textValue: 'Customers',
                            textSize: 10,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          PositiveHalfElevatedButton(
                            label: '+ Add',
                            onPressed: () {
                              Navigator.pushNamed(context, '/addCustomer');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: height * 2),
                      SizedBox(
                        height: height * 80,
                        child: FutureBuilder<QuerySnapshot>(
                          future: usersCollection
                              .where('companyName',
                                  isEqualTo: userDetails!.companyName)
                              .where('isUser', isEqualTo: true)
                              .get(),
                          // initialData: InitialData,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const Loading();
                            } else {
                              if (snapshot.hasData) {
                                final users = snapshot.data!.docs.toList();
                                return ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    return UserCard(
                                      userProfile: users[index],
                                      isAdmin: userDetails.isAdmin,
                                    );
                                  },
                                );
                              } else {
                                return const Loading();
                              }
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
