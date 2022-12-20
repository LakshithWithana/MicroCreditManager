import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../models/user_model.dart';
import '../services/database_services.dart';
import '../services/revenuecat.dart';
import '../shared/colors.dart';
import '../shared/text.dart';

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);
    final entitlement = Provider.of<RevenuecatProvider>(context).entitlement;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: mainColor),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(width * 5.1, 0, width * 5.1, 0.0),
        child: StreamBuilder<UserDetails>(
            stream: DatabaseServices(uid: user!.uid).userDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserDetails? userDetails = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 2),
                      CustomTextBox(
                        textValue: 'Subscription',
                        textSize: 10,
                        textWeight: FontWeight.bold,
                        typeAlign: Alignment.topLeft,
                        captionAlign: TextAlign.left,
                        textColor: black,
                      ),
                      SizedBox(height: height * 2),
                      Card(
                        child: ListTile(
                          title: CustomTextBox(
                            textValue: 'Monthly Subscription',
                            textSize: 4.5,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          subtitle: CustomTextBox(
                            textValue:
                                'Statistcis, Downloads unlocked with unlimited Agents and unlimited Customers.',
                            textSize: 4,
                            textWeight: FontWeight.normal,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          leading: entitlement == Entitlement.allCourses
                              ? Icon(Icons.check_circle, color: green)
                              : null,
                          trailing: SizedBox(
                            width: width * 15,
                            child: CustomTextBox(
                              textValue: '\$3.99/month',
                              textSize: 4,
                              textWeight: FontWeight.bold,
                              typeAlign: Alignment.topLeft,
                              captionAlign: TextAlign.left,
                              textColor: mainColor,
                            ),
                          ),
                          onTap: entitlement == Entitlement.allCourses
                              ? null
                              : () async {
                                  showBuySubscriptionAlertDialog(context);
                                },
                        ),
                      ),
                      SizedBox(height: height * 1),
                      Card(
                        child: ListTile(
                          title: CustomTextBox(
                            textValue: entitlement == Entitlement.free
                                ? 'No Subscription'
                                : "Cancel Subscription",
                            textSize: 4.5,
                            textWeight: FontWeight.bold,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          subtitle: CustomTextBox(
                            textValue: entitlement == Entitlement.free
                                ? 'No subscription plan subscribed.'
                                : "Cancel the current subscription plan",
                            textSize: 4,
                            textWeight: FontWeight.normal,
                            typeAlign: Alignment.topLeft,
                            captionAlign: TextAlign.left,
                            textColor: black,
                          ),
                          leading: entitlement == Entitlement.free
                              ? Icon(Icons.check_circle, color: green)
                              : null,
                          onTap: entitlement == Entitlement.free
                              ? null
                              : () async {
                                  showCancelSubscriptionAlertDialog(context);
                                },
                        ),
                      ),
                      SizedBox(height: height * 10),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

showCancelSubscriptionAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Hide"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Cancel Subscription"),
    onPressed: () async {
      try {
        PurchaserInfo restoredInfo = await Purchases.restoreTransactions();
        // ... check restored purchaserInfo to see if entitlement is now active
      } on PlatformException {
        // Error restoring purchases
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Canceling Subscription"),
    content: const Text("Would you like to cancel the subscription?"),
    actions: [
      cancelButton,
      continueButton,
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

showBuySubscriptionAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Hide"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Buy Subscription"),
    onPressed: () async {
      try {
        Offerings offerings = await Purchases.getOfferings();
        PurchaserInfo purchaserInfo = await Purchases.purchasePackage(
            offerings.current!.availablePackages[0]);

        if (purchaserInfo.entitlements.all["Starter"]!.isActive) {
          // Unlock that great "pro" content
          print("Unlocked");
        }
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          print(e);
        }
      }
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Buy subscription"),
    content: const Text("Would you like to buy the Subscription?"),
    actions: [
      cancelButton,
      continueButton,
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
