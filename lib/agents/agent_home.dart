import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/admin_view_loan_card.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';

class AgentHome extends StatefulWidget {
  AgentHome({Key? key}) : super(key: key);

  @override
  _AgentHomeState createState() => _AgentHomeState();
}

class _AgentHomeState extends State<AgentHome> {
  int? forLoans = 0;
  int? totalLoans = 0;
  bool? isNotification = false;
  double? totCollection = 0.00;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);

    // int? forLoansCal(UserDetails? userDetails) {
    //   loanRequestsCollection
    //       .where('companyName', isEqualTo: userDetails!.companyName)
    //       .where('status', isEqualTo: 'okayed')
    //       .get()
    //       .then((value) {
    //     // for (var item in value.docs) {
    //     //   forLoans = item['amount'] + forLoans!;
    //     // }
    //     forLoans = (value.docs.first.data() as dynamic)['amount'];
    //     return forLoans;
    //   });
    // }

    return StreamBuilder<UserDetails>(
        stream: DatabaseServices(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;

            var okayedLoan = loanRequestsCollection
                .where('companyName', isEqualTo: userDetails!.companyName)
                .where('status', isEqualTo: 'okayed')
                .get()
                .then((value) {
              if (mounted) {
                // for (var item in value.docs) {
                //   forLoans = item['amount'] + forLoans!;
                // }
                // for (var i = 0; i < value.docs.length; i++) {
                //   forLoans = value.docs[i]['amount'] + forLoans!;
                // }
              }
            });
            // print(forLoans);

            loanRequestsCollection
                .where('companyName', isEqualTo: userDetails.companyName)
                .where('status', isEqualTo: 'requested')
                .get()
                .then((value) {
              if (mounted) {
                if (value.docs.isNotEmpty) {
                  setState(() {
                    isNotification = true;
                  });
                } else {
                  setState(() {
                    isNotification = false;
                  });
                }
              }
            });

            return StreamBuilder<QuerySnapshot>(
                stream: usersCollection
                    .where('companyName', isEqualTo: userDetails.companyName)
                    .where('isAdmin', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // print((snapshot.data as dynamic)['firstName']);

                  if (snapshot.hasData) {
                    QuerySnapshot adminSnapshot = snapshot.data!;
                    var admin = adminSnapshot.docs.first.data() as dynamic;
                    return Scaffold(
                      backgroundColor: white,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        iconTheme: const IconThemeData(color: mainColor),
                        elevation: 0.0,
                        actions: isNotification == true
                            ? [
                                Padding(
                                  padding: EdgeInsets.only(right: width * 5.0),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/newLoan');
                                    },
                                    icon: Icon(
                                      Icons.notifications,
                                      color: red,
                                      size: width * 10,
                                    ),
                                  ),
                                ),
                              ]
                            : [
                                Padding(
                                  padding: EdgeInsets.only(right: width * 5.0),
                                  child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    setState) {
                                              return BottomSheet(
                                                onClosing: () {},
                                                builder: (context) {
                                                  return Container(
                                                    height: height * 10,
                                                    color: white,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          width * 5.1),
                                                      child: CustomTextBox(
                                                        textValue:
                                                            "No new notifications.",
                                                        textSize: 4,
                                                        textWeight:
                                                            FontWeight.normal,
                                                        typeAlign:
                                                            Alignment.topLeft,
                                                        captionAlign:
                                                            TextAlign.left,
                                                        textColor: black,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            });
                                          });
                                    },
                                    icon: Icon(
                                      Icons.notifications_outlined,
                                      color: black,
                                      size: width * 10,
                                    ),
                                  ),
                                ),
                              ],
                      ),
                      drawer: Drawer(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            DrawerHeader(
                              decoration: const BoxDecoration(
                                color: mainColor,
                              ),
                              child: CustomTextBox(
                                textValue: 'Micro Credit Manager',
                                textSize: 4,
                                textWeight: FontWeight.normal,
                                typeAlign: Alignment.topLeft,
                                captionAlign: TextAlign.left,
                                textColor: black,
                              ),
                            ),
                            ListTile(
                              title: CustomTextBox(
                                textValue: 'Home',
                                textSize: 5,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.topLeft,
                                captionAlign: TextAlign.left,
                                textColor: black,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            userDetails.viewCustomer == true
                                ? ListTile(
                                    title: CustomTextBox(
                                      textValue: 'View Customers',
                                      textSize: 5,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, '/viewCustomers');
                                    },
                                  )
                                : const SizedBox(),
                            userDetails.viewAgent == true
                                ? ListTile(
                                    title: CustomTextBox(
                                      textValue: 'View Agents',
                                      textSize: 5,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, '/viewAgents');
                                    },
                                  )
                                : const SizedBox(),
                            userDetails.deposits == true
                                ? ListTile(
                                    title: CustomTextBox(
                                      textValue: 'Deposits',
                                      textSize: 5,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    onTap: () {},
                                  )
                                : const SizedBox(),
                            userDetails.newLoans == true
                                ? ListTile(
                                    title: CustomTextBox(
                                      textValue: 'Loans',
                                      textSize: 5,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/newLoan');
                                    },
                                  )
                                : const Loading(),
                            userDetails.expenses == true
                                ? ListTile(
                                    title: CustomTextBox(
                                      textValue: 'Expenses',
                                      textSize: 5,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/expenses');
                                    },
                                  )
                                : const SizedBox(),
                            userDetails.accounts == true
                                ? ListTile(
                                    title: CustomTextBox(
                                      textValue: 'Accounts',
                                      textSize: 5,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/accounts');
                                    },
                                  )
                                : const SizedBox(),
                            userDetails.statistics == true
                                ? ListTile(
                                    title: CustomTextBox(
                                      textValue: 'Statistics',
                                      textSize: 5,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    onTap: () {},
                                  )
                                : const SizedBox(),
                            userDetails.downloads == true
                                ? ListTile(
                                    title: CustomTextBox(
                                      textValue: 'Downloads',
                                      textSize: 5,
                                      textWeight: FontWeight.normal,
                                      typeAlign: Alignment.topLeft,
                                      captionAlign: TextAlign.left,
                                      textColor: black,
                                    ),
                                    onTap: () {},
                                  )
                                : const SizedBox(),
                            ListTile(
                              title: CustomTextBox(
                                textValue: 'Settings',
                                textSize: 5,
                                textWeight: FontWeight.normal,
                                typeAlign: Alignment.topLeft,
                                captionAlign: TextAlign.left,
                                textColor: black,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/adminSettings');
                              },
                            ),
                          ],
                        ),
                      ),
                      body: Padding(
                        padding: EdgeInsets.fromLTRB(
                            width * 5.1, 0, width * 5.1, 0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: height * 2),
                              CustomTextBox(
                                textValue: 'Agent Home',
                                textSize: 10,
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 5.1,
                                      vertical: width * 2),
                                  child: Column(
                                    children: [
                                      SizedBox(height: height * 1),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomTextBox(
                                            textValue: 'Capital',
                                            textSize: 5.0,
                                            textWeight: FontWeight.normal,
                                            typeAlign: Alignment.topLeft,
                                            captionAlign: TextAlign.left,
                                            textColor: black,
                                          ),
                                          CustomTextBox(
                                            textValue: admin['currency'] +
                                                " " +
                                                admin['capitalAmount']
                                                    .toString(),
                                            textSize: 5.0,
                                            textWeight: FontWeight.bold,
                                            typeAlign: Alignment.topLeft,
                                            captionAlign: TextAlign.left,
                                            textColor: black,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 1),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomTextBox(
                                            textValue: 'For Loans',
                                            textSize: 4.0,
                                            textWeight: FontWeight.normal,
                                            typeAlign: Alignment.topLeft,
                                            captionAlign: TextAlign.left,
                                            textColor: secondaryColor,
                                          ),
                                          CustomTextBox(
                                            textValue: admin['currency'] +
                                                " " +
                                                admin['totalLoans'].toString(),
                                            textSize: 4.0,
                                            textWeight: FontWeight.bold,
                                            typeAlign: Alignment.topLeft,
                                            captionAlign: TextAlign.left,
                                            textColor: secondaryColor,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 1),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomTextBox(
                                            textValue: 'Collection',
                                            textSize: 4.0,
                                            textWeight: FontWeight.normal,
                                            typeAlign: Alignment.topLeft,
                                            captionAlign: TextAlign.left,
                                            textColor: secondaryColor,
                                          ),
                                          CustomTextBox(
                                            textValue: admin['currency'] +
                                                " " +
                                                admin['collectionTotal']
                                                    .toString(),
                                            textSize: 4.0,
                                            textWeight: FontWeight.bold,
                                            typeAlign: Alignment.topLeft,
                                            captionAlign: TextAlign.left,
                                            textColor: secondaryColor,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 1),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 70,
                                width: width * 100,
                                child: Padding(
                                  padding: EdgeInsets.only(top: height * 2),
                                  child: SizedBox(
                                    height: height * 80,
                                    child: FutureBuilder<QuerySnapshot>(
                                      future: loanRequestsCollection
                                          .where('companyName',
                                              isEqualTo:
                                                  userDetails.companyName)
                                          .where('status', isEqualTo: 'okayed')
                                          .get(),
                                      // initialData: InitialData,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          final loans =
                                              snapshot.data!.docs.toList();
                                          return ListView.builder(
                                            itemCount: loans.length,
                                            itemBuilder: (context, index) {
                                              return AdminViewLoanCard(
                                                loan: loans[index],
                                                isAdmin: userDetails.isAdmin,
                                              );
                                            },
                                          );
                                        } else {
                                          return const Loading();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 5),
                            ],
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
        });
  }
}
