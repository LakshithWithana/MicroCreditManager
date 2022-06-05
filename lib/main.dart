import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:mcm/firebase_options.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/services/auth_services.dart';
import 'package:mcm/users/accepted_loan.dart';
import 'package:mcm/users/customer_profile.dart';
import 'package:mcm/users/request_loan.dart';
import 'package:mcm/users/user_home.dart';
import 'package:mcm/users/user_settings.dart';
import 'package:mcm/users/view_accepted_loan.dart';
import 'package:mcm/users/view_ok_loan.dart';
import 'package:mcm/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<mcmUser?>.value(
      value: AuthServices().user,
      initialData: null,
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
          '/': (context) => Wrapper(),
          '/authentication': (context) => Authentication(),
          '/passwordReset': (context) => PasswordReset(),
          '/adminSignUpDetails': (context) => const AdminSignUpDetails(),
          //admin pages---------------------------------------------------------
          '/viewCustomers': (context) => ViewCustomers(),
          '/viewSingleCustomer': (context) => ViewSingleCustomer(),
          '/viewAgents': (context) => ViewAgents(),
          '/viewSingleAgent': (context) => ViewSingleAgent(),
          '/desposits': (context) => Desposits(),
          '/newLoan': (context) => NewLoan(),
          '/expenses': (context) => Expenses(),
          '/accounts': (context) => Accounts(),
          '/statistics': (context) => Statistics(),
          '/downlaods': (context) => ChangeNotifierProvider(
                child: Downloads(),
                create: (context) => SingleCollectionModel(),
              ),
          '/adminSettings': (context) => AdminSettings(),
          '/addCustomer': (context) => AddCustomer(),
          '/addAgent': (context) => AddAgent(),
          '/viewLoan': (context) => ViewLoan(),
          '/adminViewOkLoan': (context) => AdminViewOkLoan(),
          '/addNewDeposit': (context) => AddNewDeposit(),
          '/addNewExpenses': (context) => AddNewExpense(),
          '/viewUserNotAcceptedLoan': (context) => ViewUserNotAcceptedLoan(),
          '/giveNewLoan': (context) => GiveNewLoan(),
          '/viewPDF': (context) => ViewPDF(),
          //customer pages------------------------------------------------------
          '/userHome': (context) => UserHome(),
          '/requestLoan': (context) => RequestLoan(),
          '/userSettings': (context) => UserSettings(),
          '/acceptedLoan': (context) => AcceptedLoan(),
          '/viewAcceptedLoan': (context) => ViewAcceptedLoan(),
          '/viewOkLoan': (context) => ViewOkLoan(),
          '/customerProfile': (context) => CustomerProfile(),
        },
      ),
    );
  }
}
