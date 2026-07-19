import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

/// One-time non-consumable premium unlock, per spec §2 (Play Billing).
class BillingService {
  BillingService() : _iap = InAppPurchase.instance;

  final InAppPurchase _iap;

  static const premiumProductId = 'premium_unlock';

  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  Future<bool> isAvailable() => _iap.isAvailable();

  Future<ProductDetails?> queryPremiumProduct() async {
    final response = await _iap.queryProductDetails({premiumProductId});
    if (response.notFoundIDs.contains(premiumProductId) || response.productDetails.isEmpty) {
      return null;
    }
    return response.productDetails.first;
  }

  Future<bool> buyPremium(ProductDetails product) {
    final param = PurchaseParam(productDetails: product);
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() => _iap.restorePurchases();

  Future<void> completePurchase(PurchaseDetails purchase) {
    if (purchase.pendingCompletePurchase) {
      return _iap.completePurchase(purchase);
    }
    return Future.value();
  }
}
