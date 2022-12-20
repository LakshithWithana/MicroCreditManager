import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum Entitlement { free, allCourses }

class RevenuecatProvider extends ChangeNotifier {
  RevenuecatProvider() {
    init();
  }

  Entitlement _entitlement = Entitlement.free;
  Entitlement get entitlement => _entitlement;

  Future init() async {
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      updatePurchasesStatus();
    });
  }

  Future updatePurchasesStatus() async {
    final purchaserInfo = await Purchases.getPurchaserInfo();

    final entitlements = purchaserInfo.entitlements.active.values.toList();

    print("ENTITLEMENTS $entitlements");
    _entitlement =
        entitlements.isEmpty ? Entitlement.free : Entitlement.allCourses;

    notifyListeners();
  }
}
