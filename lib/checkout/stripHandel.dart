@JS()
library stripe;

import 'package:aisyahh_store/checkout/constant.dart';
import 'package:flutter/material.dart';
import 'package:aisyahh_store/checkout/stripHandel.dart';
import 'package:js/js.dart';

const String apikey =
    'pk_test_51QQp4VE2QyD8OKoNxYc4BDi7mWi6Z48yGM0dq4p5eSk1cDDEEBT9FiVBPMz6eP4sbAwRTjBe6IT2SqxL8dmqUzYw00U98LdcxF';

void redirectToCheckout(BuildContext _) async {
  final stripe = Stripe(apikey);
  stripe.redirectToCheckout(CheckoutOptions(
    lineItems: [
      LineItem(price: nikesPriceId, quantity: 1),
    ],
    mode: 'payment',
    successUrl: 'http://localhost:58524/#/kerjabagus',

    // Halaman terimakasih

    cancelUrl: 'http://localhost:8080/#/cancel',
  ));
}

@JS()
class Stripe {
  external Stripe(String key);

  external redirectToCheckout(CheckoutOptions options);
}

@JS()
@anonymous
class CheckoutOptions {
  external List<LineItem> get lineItems;

  external String get mode;

  external String get successUrl;

  external String get cancelUrl;

  external factory CheckoutOptions({
    List<LineItem> lineItems,
    String mode,
    String successUrl,
    String cancelUrl,
    String sessionId,
  });
}

@JS()
@anonymous
class LineItem {
  external String get price;

  external int get quantity;

  external factory LineItem({String price, int quantity});
}
