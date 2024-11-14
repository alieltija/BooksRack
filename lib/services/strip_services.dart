import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();
  String? _paymentIntentClientSecret;

  Future<void> makePayment(int money) async {
    // GestureDetector(
    //         onTap: () async {
    //           StripeService.instance
    //               .makePayment(int.parse(_amountController.text));
    //         },
    try {
      final paymentIntent = await createPaymentIntent(money, "USD");
      _paymentIntentClientSecret = paymentIntent['client_secret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: _paymentIntentClientSecret!,
          style: ThemeMode.light,
          merchantDisplayName: "Nafees",
        ),
      );

      await displayPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      int amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        "amount": calculateAmount(amount), //in cents so multi by 100
        "currency": currency,
        "payment_method_types[]": "card"
      };

      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization":
              "Bearer sk_test_51PlnlVRqIP0WBM7bSoysfH3qGpLz84TDIVnJLOUPsGqZwyWmHNvvzpPVy71Mh86PXwArfNegWejHXKr0NDakBMg200AWsTdgGJ",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      return jsonDecode(response.body.toString());
    } catch (e) {
      print(e);
      return {};
    }
  }

  String calculateAmount(int amount) {
    final price = amount * 100;
    return price.toString();
  }
}
