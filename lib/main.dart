import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mcm/admins/accounts.dart';
import 'package:mcm/admins/add_agent.dart';
import 'package:mcm/admins/add_customer.dart';
import 'package:mcm/admins/add_new_deposit.dart';
import 'package:mcm/admins/add_new_expense.dart';
import 'package:mcm/admins/admin_settings.dart';
import 'package:mcm/admins/admin_view_ok_loan.dart';
import 'package:mcm/admins/deposits.dart';
import 'package:mcm/admins/downloads.dart';
import 'package:mcm/admins/expenses.dart';
import 'package:mcm/admins/give_new_loan.dart';
import 'package:mcm/admins/loans.dart';
import 'package:mcm/admins/models/single_collection_model.dart';
import 'package:mcm/admins/statistics.dart';
import 'package:mcm/admins/view_agents.dart';
import 'package:mcm/admins/view_customers.dart';
import 'package:mcm/admins/view_loan.dart';
import 'package:mcm/admins/view_pdf.dart';
import 'package:mcm/admins/view_single_agent.dart';
import 'package:mcm/admins/view_single_customer.dart';
import 'package:mcm/admins/view_user_not_accepted_loan.dart';
import 'package:mcm/authentication/admin_sign_up_details.dart';
import 'package:mcm/authentication/authentication.dart';
import 'package:mcm/authentication/password_reset.dart';
import 'package:mcm/components.dart';
import 'package:mcm/firebase_options.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/services/auth_services.dart';
import 'package:mcm/services/revenuecat.dart';
import 'package:mcm/users/accepted_loan.dart';
import 'package:mcm/users/customer_profile.dart';
import 'package:mcm/users/request_loan.dart';
import 'package:mcm/users/user_home.dart';
import 'package:mcm/users/user_settings.dart';
import 'package:mcm/users/view_accepted_loan.dart';
import 'package:mcm/users/view_ok_loan.dart';
import 'package:mcm/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'admins/change_password.dart';
import 'admins/subscription.dart';
import 'admins/view_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    appData.isPro = false;

    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("goog_yuOaAkKSWaxCyKgXrXhmWhTJOzp");

    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
      print(purchaserInfo.toString());
      if (purchaserInfo.entitlements.all['Starter'] != null) {
        appData.isPro = purchaserInfo.entitlements.all['Starter']!.isActive;
      } else {
        appData.isPro = false;
      }
    } on PlatformException catch (e) {
      print(e);
    }

    print('Is user pro? ${appData.isPro}');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<mcmUser?>.value(
          value: AuthServices().user,
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => RevenuecatProvider()),
      ],
      child: MaterialApp(
        title: 'Micro Credit Manager',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          textTheme: GoogleFonts.exo2TextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Wrapper(),
          '/authentication': (context) => Authentication(),
          '/passwordReset': (context) => PasswordReset(),
          '/adminSignUpDetails': (context) => const AdminSignUpDetails(),
          //admin pages---------------------------------------------------------
          '/viewCustomers': (context) => const ViewCustomers(),
          '/viewSingleCustomer': (context) => const ViewSingleCustomer(),
          '/viewAgents': (context) => ViewAgents(),
          '/viewSingleAgent': (context) => ViewSingleAgent(),
          '/desposits': (context) => Desposits(),
          '/newLoan': (context) => NewLoan(),
          '/expenses': (context) => Expenses(),
          '/accounts': (context) => Accounts(),
          '/statistics': (context) => const Statistics(),
          '/downlaods': (context) => ChangeNotifierProvider(
                child: Downloads(),
                create: (context) => SingleCollectionModel(),
              ),
          '/adminSettings': (context) => const AdminSettings(),
          '/addCustomer': (context) => const AddCustomer(),
          '/addAgent': (context) => const AddAgent(),
          '/viewLoan': (context) => ViewLoan(),
          '/adminViewOkLoan': (context) => const AdminViewOkLoan(),
          '/addNewDeposit': (context) => const AddNewDeposit(),
          '/addNewExpenses': (context) => const AddNewExpense(),
          '/viewUserNotAcceptedLoan': (context) => ViewUserNotAcceptedLoan(),
          '/giveNewLoan': (context) => const GiveNewLoan(),
          '/viewPDF': (context) => ViewPDF(),
          '/viewProfile': (context) => const ViewProfile(),
          '/changePassword': (context) => const ChangePassword(),
          '/subscription': (context) => const Subscription(),
          //customer pages------------------------------------------------------
          '/userHome': (context) => const UserHome(),
          '/requestLoan': (context) => RequestLoan(),
          '/userSettings': (context) => UserSettings(),
          '/acceptedLoan': (context) => AcceptedLoan(),
          '/viewAcceptedLoan': (context) => const ViewAcceptedLoan(),
          '/viewOkLoan': (context) => const ViewOkLoan(),
          '/customerProfile': (context) => const CustomerProfile(),
        },
      ),
    );
  }
}
