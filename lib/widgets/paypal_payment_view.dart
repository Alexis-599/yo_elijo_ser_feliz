import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../services/paypal_payment_service.dart';

class Payment extends StatefulWidget {
  final Function onFinish;
  final CourseModel courseModel;

  const Payment({super.key, required this.onFinish, required this.courseModel});

  @override
  State<StatefulWidget> createState() {
    return PaymentState();
  }
}

class PaymentState extends State<Payment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  Services services = Services();
  WebViewController controller = WebViewController();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams(widget.courseModel);
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
            controller = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.contains(returnURL)) {
                    final uri = Uri.parse(request.url);
                    final payerID = uri.queryParameters['PayerID'];
                    if (payerID != null) {
                      services
                          .executePayment(executeUrl, payerID, accessToken)
                          .then((id) {
                        widget.onFinish(id);
                        Get.back();
                      });
                    } else {
                      Get.back();
                    }
                    Get.back();
                  }
                  if (request.url.contains(cancelURL)) {
                    print('=========>>>>>> cancel');
                    Get.back();
                  }
                  return NavigationDecision.navigate;
                },
              ))
              ..loadRequest(Uri.parse(checkoutUrl!));
          });
        }
      } catch (e) {
        print('exception: $e');
        // final snackBar = SnackBar(
        //   content: Text(e.toString()),
        //   duration: const Duration(seconds: 10),
        //   action: SnackBarAction(
        //     label: 'Close',
        //     onPressed: () {
        //       // Some code to undo the change.
        //     },
        //   ),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  // item name, price and quantity
  String itemName = 'iPhone 7';
  String itemPrice = '200';
  int quantity = 1;

  Map<String, dynamic> getOrderParams(CourseModel courseModel) {
    // checkout invoice details

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": courseModel.price,
            "currency": "MXN",
            "details": {
              "subtotal": courseModel.price,
              "shipping": '0',
              "shipping_discount": 0
            }
          },
          "description": "The payment transaction description.",
          "item_list": {
            "items": [
              {
                "name": courseModel.title,
                "quantity": 1,
                "price": courseModel.price,
                "currency": "MXN"
              }
            ],
          }
        }
      ],
      "note_to_payer":
          "Gracias por comprar el curso ${widget.courseModel.title}, te contactaremos por correo para enviarte los detalles.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () => Get.back(),
          ),
        ),
        body: WebViewWidget(controller: controller),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
  }
}
