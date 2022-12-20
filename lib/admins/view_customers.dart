import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/reusable_components/user_card.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/services/revenuecat.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

class ViewCustomers extends StatefulWidget {
  const ViewCustomers({Key? key}) : super(key: key);

  @override
  _ViewCustomersState createState() => _ViewCustomersState();
}

class _ViewCustomersState extends State<ViewCustomers> {
  int customersCount = 0;
  String? url = "";
  String? serachQuery = "";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);
    final entitlement = Provider.of<RevenuecatProvider>(context).entitlement;

    // Future<int> customerCount(String? companyName) async {
    //   await usersCollection
    //       .where('companyName', isEqualTo: companyName)
    //       .where('isAdmin', isEqualTo: true)
    //       .get()
    //       .then((value) {
    //     usersCollection.doc(value.docs.first.id).get().then((value) {
    //       if (mounted) {
    //         setState(() {
    //           customersCount = (value.data() as dynamic)['totalCustomer'];
    //         });
    //       }
    //     });
    //   });
    //   print("customersCount $customersCount");
    //   return customersCount;
    // }

    return StreamBuilder<UserDetails>(
        stream: DatabaseServices(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;
            // customerCount(userDetails!.companyName);

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
                              entitlement == Entitlement.free &&
                                      (customersCount >= 10)
                                  ? showAlertDialog(context)
                                  : Navigator.pushNamed(
                                      context, '/addCustomer');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: height * 2),
                      TextField(
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Customer name",
                          fillColor: Colors.white70,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 0),
                        ),
                        onChanged: (value) => setState(() {
                          serachQuery = value;
                        }),
                      ),
                      SizedBox(height: height * 1),
                      SizedBox(
                        height: height * 80,
                        child: FutureBuilder<QuerySnapshot>(
                          future: usersCollection
                              .where('companyName',
                                  isEqualTo: userDetails!.companyName)
                              .where('isUser', isEqualTo: true)
                              .where('searchQuery',
                                  arrayContainsAny: serachQuery!.isEmpty
                                      ? null
                                      : [serachQuery!.toLowerCase()])
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
                                      // userId: users[index]['userId'],
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Maximum Customer Count Reached"),
      content: const Text(
          "To add more Customers into your business buy the Subscription plan."),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
