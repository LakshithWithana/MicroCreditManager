import 'package:firebase_auth/firebase_auth.dart';
import 'package:mcm/models/user_model.dart';
import 'package:mcm/services/database_services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase
  mcmUser? _userFromFirebaseUser(User? user) {
    return user != null ? mcmUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<mcmUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // register with email and password
  Future registerWithEmailAndPassword({
    String? createdDate,
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
    String? userId,
    bool? isUser,
    bool? isAdmin,
    bool? isSuperAdmin,
    List? accountIds,
    List? debt,
    List? paidDebt,
    List? ownAccounts,
    bool? viewCustomer,
    bool? viewAgent,
    bool? deposits,
    bool? newLoans,
    bool? expenses,
    bool? accounts,
    bool? statistics,
    bool? downloads,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      User user = result.user!;

      await DatabaseServices(uid: user.uid).updateUserData(
        createdDate: createdDate,
        userId: userId,
        companyName: companyName,
        governmentRegistered: governmentRegistered,
        companyRegistrationNo: companyRegistrationNo,
        country: country,
        currency: currency,
        companyTelNo: companyTelNo,
        capitalAmount: capitalAmount,
        firstName: firstName,
        lastName: lastName,
        govIdNumber: govIdNumber,
        email: email,
        password: password,
        isUser: isUser,
        isAdmin: isAdmin,
        isSuperAdmin: isSuperAdmin,
        accountIds: accountIds,
        debt: debt,
        paidDebt: paidDebt,
        ownAccounts: ownAccounts,
        viewCustomer: viewCustomer,
        viewAgent: viewAgent,
        deposits: deposits,
        newLoans: newLoans,
        expenses: expenses,
        accounts: accounts,
        statistics: statistics,
        downloads: downloads,
      );
      await Purchases.logIn(result.user!.uid);
      print('uid: ${user.uid}');
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword({String? email, String? password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      User user = result.user!;
      print('uid: ${user.uid}');
      await Purchases.logIn(result.user!.uid);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      print('Signed out');
      await Purchases.logOut();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> changePassword(
      String currentPassword, String newPassword, String uid) async {
    bool success = false;

    //Create an instance of the current user.
    var user = FirebaseAuth.instance.currentUser!;
    //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.

    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {
        success = true;
        usersCollection.doc(uid).update({"password": newPassword});
      }).catchError((error) {
        print(error);
      });
    }).catchError((err) {
      print(err);
    });

    return success;
  }
}
