import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:http/http.dart' as http;
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/services/firestore.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.courseModel});

  final CourseModel courseModel;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  dynamic paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Buy Playlist',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '\$${widget.courseModel.price}',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.courseModel.title,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                  ),
                ),
                Text(
                  widget.courseModel.subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                  ),
                ),
                Text(
                  widget.courseModel.description,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => UsePaypal(
                            sandboxMode: true,
                            clientId: AppData.paypalSandboxClientId,
                            secretKey: AppData.paypalSandboxSecretKey,
                            returnURL: "https://samplesite.com/return",
                            cancelURL: "https://samplesite.com/cancel",
                            transactions: [
                              {
                                "amount": {
                                  "total": widget.courseModel.price,
                                  "currency": "USD",
                                  "details": {
                                    "subtotal": widget.courseModel.price,
                                    "shipping": '0',
                                    "shipping_discount": 0
                                  }
                                },
                                "description":
                                    "The payment transaction description.",
                                // "payment_options": {
                                //   "allowed_payment_method":
                                //       "INSTANT_FUNDING_SOURCE"
                                // },
                                "item_list": {
                                  "items": [
                                    {
                                      "name": "A demo product",
                                      "quantity": 1,
                                      "price": widget.courseModel.price,
                                      "currency": "USD"
                                    }
                                  ],

                                  // shipping address is not required though
                                  "shipping_address": const {
                                    "recipient_name": "Jane Foster",
                                    "line1": "Travis County",
                                    "line2": "",
                                    "city": "Austin",
                                    "country_code": "US",
                                    "postal_code": "73301",
                                    "phone": "+00000000",
                                    "state": "Texas"
                                  },
                                }
                              }
                            ],
                            note: "Contact us for any questions on your order.",
                            onSuccess: (Map params) async {
                              print("onSuccess: $params");
                              FirestoreService()
                                  .postUserCourseIds(widget.courseModel.id);
                            },
                            onError: (error) {
                              print("onError: $error");
                            },
                            onCancel: (params) {
                              print('cancelled: $params');
                            }),
                      ),
                    )
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * .8,
                      52,
                    ),
                  ),
                  child: const Text(
                    "Pay with PayPal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await makePayment(
                        context: context,
                        amount: widget.courseModel.price,
                        test: false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * .8,
                      52,
                    ),
                  ),
                  child: const Text(
                    "Pay with Debit/Credit Card",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> makePayment({context, amount, test}) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD', test);

      // var gpay = PaymentSheetGooglePay(
      //   merchantCountryCode: "DE",
      //   currencyCode: "EUR",
      //   testEnv: true,
      // );
      // var aPay = const PaymentSheetApplePay(
      //   merchantCountryCode: "DE",
      //   buttonType: PlatformButtonType.pay,
      // );

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            //Gotten from payment intent
            style: ThemeMode.light,
            merchantDisplayName: 'Podcasts App',
            // googlePay: gpay,
            // applePay: aPay,
            // appearance: PaymentSheetAppearance()
          ))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(context);
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet(context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {});
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency, bool test) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${AppData.stripeLiveSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
