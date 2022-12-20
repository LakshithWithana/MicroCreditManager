import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/reusable_components/admin_view_loan_card.dart';
import 'package:mcm/reusable_components/custom_elevated_buttons.dart';
import 'package:mcm/reusable_components/loading.dart';
import 'package:mcm/services/database_services.dart';
import 'package:mcm/services/revenuecat.dart';
import 'package:mcm/shared/colors.dart';
import 'package:mcm/shared/text.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

const int maxFailedLoadAttempts = 3;

class _AdminHomeState extends State<AdminHome> {
  int? forLoans = 0;
  int? totalLoans = 0;
  bool? isNotification = false;
  double? totCollection = 0.00;
  double? totalExpenses = 0.00;
  double? totalDeposits = 0.00;
  String? loanTypeFilterValues = "All";
  String? searchString = "";
  List? searchStringArray = [];
  double? capitalAmount = 0.00;
  String? url = "";

  // COMPLETE: Add a banner ad instance
  BannerAd? _ad;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  @override
  void initState() {
    super.initState();

    BannerAd(
      adUnitId: "ca-app-pub-8305805110829789/9002225884",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          debugPrint(
              'Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();

    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-8305805110829789/9740524612',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd({required function}) {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        function;
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // void _loadInterstitialAd() {
  //   InterstitialAd.load(
  //     adUnitId: 'ca-app-pub-8305805110829789/9740524612',
  //     request: const AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         ad.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {
  //             // _moveToHome();
  //             _numInterstitialLoadAttempts = 0;
  //           },
  //         );

  //         setState(() {
  //           _interstitialAd = ad;
  //         });
  //       },
  //       onAdFailedToLoad: (err) {
  //         print('Failed to load an interstitial ad: ${err.message}');
  //       },
  //     ),
  //   );
  // }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int _counter = 0;

  handleDrawer() {
    _key.currentState?.openDrawer();

    setState(() {
      ///DO MY API CALLS
      _counter++;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _ad?.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width / 100;
    double height = screenSize.height / 100;

    final user = Provider.of<mcmUser?>(context);

    final entitlement = Provider.of<RevenuecatProvider>(context).entitlement;

    return StreamBuilder<UserDetails>(
        stream: DatabaseServices(uid: user!.uid).userDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDetails? userDetails = snapshot.data;

            transactionsCollection
                .where('companyName', isEqualTo: userDetails!.companyName)
                .get()
                .then((value) {
              if (mounted) {
                setState(() {
                  totalExpenses =
                      (value.docs.first.data() as dynamic)['totalExpenses']
                          .toDouble();
                });
              }
            });

            getUrl() async {
              final ref = FirebaseStorage.instance.ref().child(
                  "${userDetails.companyName}/${userDetails.companyName}");
              // no need of then file extension, the name will do fine.
              // var urlLoaded = await ref.getDownloadURL();
              // if (mounted) {
              //   setState(() {
              //     url = urlLoaded;
              //   });
              // }
              await ref.getDownloadURL().then((value) {
                if (mounted) {
                  setState(() {
                    url = value;
                  });
                }
              }).catchError((e) => print(e.toString()));

              print(url);
            }

            // getUrl();

            var okayedLoan = loanRequestsCollection
                .where('companyName', isEqualTo: userDetails.companyName)
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

            return Scaffold(
              key: _key,
              backgroundColor: white,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    getUrl();
                    handleDrawer();
                  },
                  icon: const Icon(Icons.menu),
                ),
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
                                        (BuildContext context, setState) {
                                      return BottomSheet(
                                        onClosing: () {},
                                        builder: (context) {
                                          return Container(
                                            height: height * 10,
                                            color: white,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.all(width * 5.1),
                                              child: CustomTextBox(
                                                textValue:
                                                    "No new notifications.",
                                                textSize: 4,
                                                textWeight: FontWeight.normal,
                                                typeAlign: Alignment.topLeft,
                                                captionAlign: TextAlign.left,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextBox(
                                textValue: userDetails.companyName!,
                                textSize: 5,
                                textWeight: FontWeight.bold,
                                typeAlign: Alignment.topLeft,
                                captionAlign: TextAlign.left,
                                textColor: black,
                              ),
                              CustomTextBox(
                                textValue:
                                    "${userDetails.firstName!} ${userDetails.lastName!}",
                                textSize: 4,
                                textWeight: FontWeight.normal,
                                typeAlign: Alignment.topLeft,
                                captionAlign: TextAlign.left,
                                textColor: Colors.grey,
                              ),
                            ],
                          ),
                          url != ""
                              ? Center(
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              url!,
                                            ),
                                            fit: BoxFit.cover),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                  ),
                                )
                              : Center(
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/MCM app icon.png"),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                  ),
                                ),
                        ],
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
                              Navigator.pushNamed(context, '/viewCustomers');
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
                            onTap: entitlement == Entitlement.allCourses
                                ? () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, '/viewAgents');
                                  }
                                : _counter % 5 == 0
                                    ? () {
                                        Navigator.pop(context);
                                        _showInterstitialAd(
                                          function: Navigator.pushNamed(
                                              context, '/viewAgents'),
                                        );
                                      }
                                    : () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/viewAgents');
                                      },
                          )
                        : const SizedBox(),
                    // userDetails.deposits == true
                    //     ? ListTile(
                    //         title: CustomTextBox(
                    //           textValue: 'Deposits',
                    //           textSize: 5,
                    //           textWeight: FontWeight.normal,
                    //           typeAlign: Alignment.topLeft,
                    //           captionAlign: TextAlign.left,
                    //           textColor: black,
                    //         ),
                    //         onTap: () {},
                    //       )
                    //     : const SizedBox(),
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
                            onTap: entitlement == Entitlement.allCourses
                                ? () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, '/expenses');
                                  }
                                : _counter % 5 == 0
                                    ? () {
                                        Navigator.pop(context);
                                        // Navigator.pushNamed(context, '/expenses');

                                        _showInterstitialAd(
                                          function: Navigator.pushNamed(
                                              context, '/expenses'),
                                        );
                                      }
                                    : () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/expenses');
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
                            onTap: entitlement == Entitlement.allCourses
                                ? () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, '/accounts');
                                  }
                                : _counter % 5 == 0
                                    ? () {
                                        Navigator.pop(context);
                                        // Navigator.pushNamed(context, '/accounts');

                                        _showInterstitialAd(
                                          function: Navigator.pushNamed(
                                              context, '/accounts'),
                                        );
                                      }
                                    : () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, '/accounts');
                                      },
                          )
                        : const SizedBox(),
                    userDetails.statistics == true
                        ? entitlement == Entitlement.allCourses
                            ? ListTile(
                                title: CustomTextBox(
                                  textValue: 'Statistics',
                                  textSize: 5,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topLeft,
                                  captionAlign: TextAlign.left,
                                  textColor: black,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/statistics');
                                },
                              )
                            : ListTile(
                                title: CustomTextBox(
                                  textValue: 'Statistics',
                                  textSize: 5,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topLeft,
                                  captionAlign: TextAlign.left,
                                  textColor: black,
                                ),
                                onTap: () async {
                                  // Navigator.pop(context);
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    backgroundColor: white,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 20.0, 20.0, 40.0),
                                        child: SizedBox(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                  "You want to subscribe to activate this service"),
                                              const SizedBox(height: 20.0),
                                              PositiveElevatedButton(
                                                label: "Buy Subscription",
                                                onPressed: () async {
                                                  try {
                                                    Offerings offerings =
                                                        await Purchases
                                                            .getOfferings();
                                                    PurchaserInfo
                                                        purchaserInfo =
                                                        await Purchases
                                                            .purchasePackage(
                                                                offerings
                                                                    .current!
                                                                    .availablePackages[0]);

                                                    if (purchaserInfo
                                                        .entitlements
                                                        .all["Starter"]!
                                                        .isActive) {
                                                      // Unlock that great "pro" content
                                                      print("Unlocked");
                                                    }
                                                  } on PlatformException catch (e) {
                                                    var errorCode =
                                                        PurchasesErrorHelper
                                                            .getErrorCode(e);
                                                    if (errorCode !=
                                                        PurchasesErrorCode
                                                            .purchaseCancelledError) {
                                                      print(e);
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                        : const SizedBox(),
                    // ListTile(
                    //   title: CustomTextBox(
                    //     textValue: 'Statistics',
                    //     textSize: 5,
                    //     textWeight: FontWeight.normal,
                    //     typeAlign: Alignment.topLeft,
                    //     captionAlign: TextAlign.left,
                    //     textColor: black,
                    //   ),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.pushNamed(context, '/statistics');
                    //   },
                    // ),
                    userDetails.downloads == true
                        ? entitlement == Entitlement.allCourses
                            ? ListTile(
                                title: CustomTextBox(
                                  textValue: 'Downloads',
                                  textSize: 5,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topLeft,
                                  captionAlign: TextAlign.left,
                                  textColor: black,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/downlaods');
                                },
                              )
                            : ListTile(
                                title: CustomTextBox(
                                  textValue: 'Downloads',
                                  textSize: 5,
                                  textWeight: FontWeight.normal,
                                  typeAlign: Alignment.topLeft,
                                  captionAlign: TextAlign.left,
                                  textColor: black,
                                ),
                                onTap: () async {
                                  // Navigator.pop(context);
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    backgroundColor: white,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 20.0, 20.0, 40.0),
                                        child: SizedBox(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                  "You want to subscribe to activate this service"),
                                              const SizedBox(height: 20.0),
                                              PositiveElevatedButton(
                                                label: "Buy Subscription",
                                                onPressed: () async {
                                                  try {
                                                    Offerings offerings =
                                                        await Purchases
                                                            .getOfferings();
                                                    PurchaserInfo
                                                        purchaserInfo =
                                                        await Purchases
                                                            .purchasePackage(
                                                                offerings
                                                                    .current!
                                                                    .availablePackages[0]);

                                                    if (purchaserInfo
                                                        .entitlements
                                                        .all["Starter"]!
                                                        .isActive) {
                                                      // Unlock that great "pro" content
                                                      print("Unlocked");
                                                    }
                                                  } on PlatformException catch (e) {
                                                    var errorCode =
                                                        PurchasesErrorHelper
                                                            .getErrorCode(e);
                                                    if (errorCode !=
                                                        PurchasesErrorCode
                                                            .purchaseCancelledError) {
                                                      print(e);
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
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
                padding: EdgeInsets.fromLTRB(width * 5.1, 0, width * 5.1, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height * 2),
                      CustomTextBox(
                        textValue: userDetails.isAdmin == true
                            ? 'Admin Home'
                            : 'Agent Home',
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
                              horizontal: width * 5.1, vertical: width * 2),
                          child: Column(
                            children: [
                              SizedBox(height: height * 1),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     CustomTextBox(
                              //       textValue: 'Capital',
                              //       textSize: 4.0,
                              //       textWeight: FontWeight.normal,
                              //       typeAlign: Alignment.topLeft,
                              //       captionAlign: TextAlign.left,
                              //       textColor: secondaryColor,
                              //     ),
                              //     CustomTextBox(
                              //       textValue:
                              //           "+ ${userDetails.currency!} ${userDetails.capitalAmount!.toStringAsFixed(2)}",
                              //       textSize: 4.0,
                              //       textWeight: FontWeight.bold,
                              //       typeAlign: Alignment.topLeft,
                              //       captionAlign: TextAlign.left,
                              //       textColor: secondaryColor,
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(height: height * 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextBox(
                                    textValue: 'Deposits',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: secondaryColor,
                                  ),
                                  CustomTextBox(
                                    textValue:
                                        "+ ${userDetails.currency!} ${userDetails.totalDeposits!.toStringAsFixed(2)}",
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
                                    textValue:
                                        "+ ${userDetails.currency!} ${userDetails.collectionTotal!.toStringAsFixed(2)}",
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
                                    textValue: 'For Loans',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: secondaryColor,
                                  ),
                                  CustomTextBox(
                                    textValue:
                                        "- ${userDetails.currency!} ${userDetails.totalLoans!.toStringAsFixed(2)}",
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
                                    textValue: 'Expenses',
                                    textSize: 4.0,
                                    textWeight: FontWeight.normal,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: secondaryColor,
                                  ),
                                  CustomTextBox(
                                    textValue:
                                        "- ${userDetails.currency!} ${totalExpenses!.toStringAsFixed(2)}",
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
                                    textValue: 'Balance',
                                    textSize: 5.0,
                                    textWeight: FontWeight.bold,
                                    typeAlign: Alignment.topLeft,
                                    captionAlign: TextAlign.left,
                                    textColor: black,
                                  ),
                                  CustomTextBox(
                                    textValue:
                                        "${userDetails.currency!} ${(userDetails.capitalAmount! + userDetails.totalDeposits! + userDetails.collectionTotal!).toStringAsFixed(2)}",
                                    textSize: 5.0,
                                    textWeight: FontWeight.bold,
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
                      entitlement == Entitlement.allCourses
                          ? const SizedBox()
                          : _ad != null
                              ? Container(
                                  width: _ad!.size.width.toDouble(),
                                  height: 72.0,
                                  alignment: Alignment.center,
                                  child: AdWidget(ad: _ad!),
                                )
                              : const SizedBox(),
                      SizedBox(height: height * 3),
                      SizedBox(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: width * 45,
                                child: TextField(
                                  decoration: InputDecoration(
                                    suffixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: "Cus. name",
                                    fillColor: Colors.white70,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 0),
                                  ),
                                  onChanged: (value) => setState(() {
                                    searchString = value;
                                  }),
                                ),
                                // TextFormField(
                                //   onChanged: ((value) {
                                //     setState(() {
                                //       searchString = value;
                                //     });
                                //   }),
                                //   decoration: InputDecoration(
                                //     hintText: "Search by name",
                                //     suffix: IconButton(
                                //       splashRadius: 15,
                                //       onPressed: () {
                                //         searchStringArray =
                                //             searchString!.trim().split("");
                                //         print(searchStringArray);
                                //       },
                                //       icon: const Icon(Icons.search),
                                //     ),
                                //   ),
                                //   style: TextStyle(fontSize: width * 4),
                                // ),
                              ),
                              SizedBox(width: width * 5),
                              // CustomTextBox(
                              //   textValue: 'Loan Types',
                              //   textSize: 4,
                              //   textWeight: FontWeight.normal,
                              //   typeAlign: Alignment.topLeft,
                              //   captionAlign: TextAlign.left,
                              //   textColor: secondaryColor,
                              // ),
                              // SizedBox(width: width * 5),
                              Container(
                                width: width * 35,
                                height: height * 4,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius:
                                      BorderRadius.circular(width * 2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 4.0),
                                  child: DropdownButton<String?>(
                                    value: loanTypeFilterValues,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: mainColor,
                                    ),
                                    iconSize: width * 7,
                                    isExpanded: true,
                                    elevation: 16,
                                    style: const TextStyle(color: black),
                                    underline: Container(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        loanTypeFilterValues = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'All',
                                      'Monthly',
                                      'Daily',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontSize: width * 4,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
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
                                      isEqualTo: userDetails.companyName)
                                  .where('status', isEqualTo: 'okayed')
                                  .where('loanType',
                                      isEqualTo: loanTypeFilterValues == "Daily"
                                          ? "Daily"
                                          : loanTypeFilterValues == "Monthly"
                                              ? "Monthly"
                                              : null)
                                  .where('searchQuery',
                                      arrayContainsAny: searchString!.isEmpty
                                          ? null
                                          : [searchString!.toLowerCase()])
                                  .get(),
                              // initialData: InitialData,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  final loans = snapshot.data!.docs.toList();
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
  }
}
