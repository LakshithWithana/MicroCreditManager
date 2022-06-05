import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mcm/models/user_model.dart';

///users collection reference
final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

final CollectionReference documentCollection =
    FirebaseFirestore.instance.collection('documents');

///user_requests collection reference
final CollectionReference userRequestsCollection =
    FirebaseFirestore.instance.collection('user_requests');

///agent_requests collection reference
final CollectionReference agentRequestsCollection =
    FirebaseFirestore.instance.collection('agent_requests');

///loan_requests collection reference
final CollectionReference loanRequestsCollection =
    FirebaseFirestore.instance.collection('loan_requests');

///accounts collection reference
final CollectionReference accountsCollection =
    FirebaseFirestore.instance.collection('accounts');

///accounts collection reference
final CollectionReference transactionsCollection =
    FirebaseFirestore.instance.collection('transactions');

///expenses collection reference
final CollectionReference expensesCollection =
    FirebaseFirestore.instance.collection('expenses');

///deposits collection reference
final CollectionReference depositsCollection =
    FirebaseFirestore.instance.collection('deposits');

///images collection reference
final CollectionReference imagesCollection =
    FirebaseFirestore.instance.collection('images');

///admin Ids collection reference
final CollectionReference adminIdsCollection =
    FirebaseFirestore.instance.collection('adminIdsCollection');

///user Ids collection reference
final CollectionReference userIdsCollection =
    FirebaseFirestore.instance.collection('userIdsCollection');

///admin Ids collection reference
final CollectionReference agentIdsCollection =
    FirebaseFirestore.instance.collection('agentIdsCollection');

///user emails collection reference
final CollectionReference userEmailsCollection =
    FirebaseFirestore.instance.collection('userEmailsCollection');

class DatabaseServices {
  final String? uid;
  DatabaseServices({this.uid});

  ///this is created to get userDetail from snapshot
  UserDetails _userDetailsFromSnapshot(DocumentSnapshot snapshot) {
    return UserDetails(
      uid: uid,
      userId: (snapshot.data() as dynamic)['userId'],
      email: (snapshot.data() as dynamic)['email'],
      password: (snapshot.data() as dynamic)['password'],
      firstName: (snapshot.data() as dynamic)['firstName'],
      lastName: (snapshot.data() as dynamic)['lastName'],
      isUser: (snapshot.data() as dynamic)['isUser'],
      isAdmin: (snapshot.data() as dynamic)['isAdmin'],
      isSuperAdmin: (snapshot.data() as dynamic)['isSuperAdmin'],
      ownAccounts: (snapshot.data() as dynamic)['ownAccounts'],
      companyName: (snapshot.data() as dynamic)['companyName'],
      govtID: (snapshot.data() as dynamic)['govIdNumber'],
      isGovernmentRegistered:
          (snapshot.data() as dynamic)['governmentRegistered'],
      companyRegistrationNo:
          (snapshot.data() as dynamic)['companyRegistrationNo'],
      country: (snapshot.data() as dynamic)['country'],
      companyTelNo: (snapshot.data() as dynamic)['companyTelNo'],
      currency: (snapshot.data() as dynamic)['currency'],
      capitalAmount: ((snapshot.data() as dynamic)['capitalAmount']).toDouble(),
      accountIds: (snapshot.data() as dynamic)['accountIds'],
      debt: (snapshot.data() as dynamic)['debt'],
      paidDebt: (snapshot.data() as dynamic)['paidDebt'],
      viewCustomer: (snapshot.data() as dynamic)['viewCustomer'],
      viewAgent: (snapshot.data() as dynamic)['viewAgent'],
      deposits: (snapshot.data() as dynamic)['deposits'],
      newLoans: (snapshot.data() as dynamic)['newLoans'],
      expenses: (snapshot.data() as dynamic)['expenses'],
      accounts: (snapshot.data() as dynamic)['accounts'],
      statistics: (snapshot.data() as dynamic)['statistics'],
      downloads: (snapshot.data() as dynamic)['downloads'],
      totalLoans: (snapshot.data() as dynamic)['totalLoans'],
      collection: (snapshot.data() as dynamic)['collection'],
      collectionTotal:
          (snapshot.data() as dynamic)['collectionTotal'].toDouble(),
      points: (snapshot.data() as dynamic)['points'],
      totalAgents: (snapshot.data() as dynamic)['totalAgents'],
      totalCustomers: (snapshot.data() as dynamic)['totalCustomers'],
      totalDeposits: (snapshot.data() as dynamic)['totalDeposits'],
    );
  }

  //get user doc stream
  Stream<UserDetails> get userDetails {
    return usersCollection.doc(uid).snapshots().map(_userDetailsFromSnapshot);
  }

  //update user data
  Future updateUserData({
    String? createdDate,
    String? userId,
    String? companyName,
    String? governmentRegistered,
    String? companyRegistrationNo,
    String? country,
    String? currency,
    String? companyTelNo,
    int? capitalAmount,
    String? firstName,
    String? lastName,
    String? govIdNumber,
    String? email,
    String? password,
    bool? isUser,
    bool? isAdmin,
    bool? isSuperAdmin,
    List? ownAccounts,
    List? accountIds,
    List? debt,
    List? paidDebt,
    bool? viewCustomer,
    bool? viewAgent,
    bool? deposits,
    bool? newLoans,
    bool? expenses,
    bool? accounts,
    bool? statistics,
    bool? downloads,
  }) async {
    await usersCollection.doc(uid).set({
      'userId': userId,
      'companyName': companyName,
      'governmentRegistered': governmentRegistered == "Yes" ? true : false,
      'companyRegistrationNo': companyRegistrationNo,
      'country': country,
      'currency': currency,
      'companyTelNo': companyTelNo,
      'capitalAmount': capitalAmount,
      'firstName': firstName,
      'lastName': lastName,
      'govIdNumber': govIdNumber,
      'email': email,
      'password': password,
      'isUser': isUser,
      'isAdmin': isAdmin,
      'isSuperAdmin': isSuperAdmin,
      'ownAccounts': ownAccounts,
      'accountIds': accountIds,
      'debt': debt,
      'paidDebt': paidDebt,
      'viewCustomer': viewCustomer,
      'viewAgent': viewAgent,
      'deposits': deposits,
      'newLoans': newLoans,
      'expenses': expenses,
      'accounts': accounts,
      'statistics': statistics,
      'downloads': downloads,
      'totalLoans': 0.00,
      'collection': [],
      'collectionTotal': 0.00,
      'points': 0,
      'totalCustomers': 0,
      'totalAgents': 0,
      'totalDeposits': 0.00,
    });
    await accountsCollection.doc(uid).set({
      'accountId': accountIds![0],
      'userId': uid,
      'accountType': ownAccounts![0]['accountType'],
      'amount': capitalAmount,
      'transactions': [
        {
          'transactionId': accountIds[0],
          'amount': capitalAmount,
          'date': createdDate,
          'type': 'Initial Deposit',
        }
      ],
    });
    await transactionsCollection.doc(uid).set({
      'createdDate': createdDate,
      'totalExpenses': 0,
    });
  }
}
