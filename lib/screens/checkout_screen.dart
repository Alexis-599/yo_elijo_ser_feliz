import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:http/http.dart' as http;
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:podcasts_ruben/models/user_model.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:provider/provider.dart';

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
    final currentUser = context.watch<UserModel?>();
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.amber.shade300,
            Colors.amber.shade100,
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'Comprar lista de reproducción del curso',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: currentUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '\$MXN${widget.courseModel.price}',
                            style: const TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.courseModel.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.courseModel.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.courseModel.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => usePaypal(currentUser),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * .8,
                              52,
                            ),
                          ),
                          child: const Text(
                            "Pagar con PayPal",
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
                            'O',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await makePayment(
                              amount: widget.courseModel.price,
                              currentUser: currentUser,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * .8,
                              52,
                            ),
                          ),
                          child: const Text(
                            "Pagar con tarjeta de débito/crédito",
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
      ),
    );
  }

  usePaypal(UserModel currentUser) {
    Get.to(
      () => UsePaypal(
        sandboxMode: false,
        clientId: AppData.paypalLiveClientId,
        secretKey: AppData.paypalLiveSecretKey,
        returnURL: "https://samplesite.com/return",
        cancelURL: "https://samplesite.com/cancel",
        transactions: [
          {
            "amount": {
              "total": widget.courseModel.price,
              "currency": "MXN",
              "details": {
                "subtotal": widget.courseModel.price,
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": "The payment transaction description.",
            "item_list": {
              "items": [
                {
                  "name": widget.courseModel.title,
                  "quantity": 1,
                  "price": widget.courseModel.price,
                  "currency": "MXN"
                }
              ],
            }
          }
        ],
        note:
            "Gracias por comprar el curso ${widget.courseModel.title}, te contactaremos por correo para enviarte los detalles",
        onSuccess: (Map params) {
          onPaymentSuccess(currentUser);
        },
        onError: (error) {
          print('error');
          Get.snackbar(
            'Error',
            "Se produjo un error desconocido. Inténtelo más tarde",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
          );
        },
        onCancel: (params) {
          print('cancel');
        },
      ),
    );
  }

  Future<void> makePayment({amount, currentUser}) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'MXN', true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            //Gotten from payment intent
            style: ThemeMode.light,
            merchantDisplayName: 'Podcasts App',
            // appearance: PaymentSheetAppearance()
          ))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(currentUser);
    } catch (err) {
      // print(err);
    }
  }

  displayPaymentSheet(UserModel currentUser) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        onPaymentSuccess(currentUser);
        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      // print('Error is:---> $e');
      // showDialog(
      //     context: context,
      //     builder: (_) => const ;
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text(
                    "Se produjo un error al realizar el pago. Inténtelo de nuevo."),
              ],
            ),
          ],
        ),
      );
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  onPaymentSuccess(UserModel currentUser) {
    FirestoreService().postUserCourseIds(widget.courseModel.id);
    Get.back();
    Get.snackbar(
      'Felicidades',
      "Gracias por comprar el curso ${widget.courseModel.title}, te contactaremos por correo para enviarte los detalles",
      backgroundColor: Colors.white,
      colorText: Colors.black,
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
    );
    AppData().sendEmail(currentUser, widget.courseModel);
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
      // print('Payment Intent Body->>> ${response.body.toString()}');
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
