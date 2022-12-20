class mcmUser {
  final String? uid;
  mcmUser({this.uid});
}

class UserDetails {
  final String? userId;
  final String? uid;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final List? ownAccounts;
  final bool? isUser;
  final bool? isAdmin;
  final bool? isSuperAdmin;
  final String? companyName;
  final String? govtID;
  final bool? isGovernmentRegistered;
  final String? companyRegistrationNo;
  final String? country;
  final String? companyTelNo;
  final String? currency;
  final double? capitalAmount;
  final List? accountIds;
  final List? debt;
  final List? paidDebt;
  final bool? viewCustomer;
  final bool? viewAgent;
  final bool? deposits;
  final bool? newLoans;
  final bool? expenses;
  final bool? accounts;
  final bool? statistics;
  final bool? downloads;
  final double? totalLoans;
  final List? collection;
  final double? collectionTotal;
  final int? points;
  final int? totalCustomers;
  final int? totalAgents;
  final double? totalDeposits; //TODO change this to double
  final double? totalExpenses;

  UserDetails({
    this.userId,
    this.ownAccounts,
    this.govtID,
    this.isGovernmentRegistered,
    this.companyRegistrationNo,
    this.country,
    this.companyTelNo,
    this.currency,
    this.capitalAmount,
    this.accountIds,
    this.debt,
    this.paidDebt,
    this.viewCustomer,
    this.viewAgent,
    this.deposits,
    this.newLoans,
    this.expenses,
    this.accounts,
    this.statistics,
    this.downloads,
    this.uid,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.isUser,
    this.isAdmin,
    this.companyName,
    this.isSuperAdmin,
    this.totalLoans,
    this.collection,
    this.collectionTotal,
    this.points,
    this.totalAgents,
    this.totalCustomers,
    this.totalDeposits,
    this.totalExpenses,
  });
}
