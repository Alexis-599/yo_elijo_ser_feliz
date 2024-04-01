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
                          onPressed: () => usePaypal(context, currentUser),
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
                              context: context,
                              amount: widget.courseModel.price,
                              currentUser: currentUser,
                              test: false,
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

  usePaypal(BuildContext context, UserModel currentUser) {
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
          FirestoreService().postUserCourseIds(widget.courseModel.id);
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 100.0,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                            "Gracias por comprar el curso ${widget.courseModel.title}, te contactaremos por correo para enviarte los detalles"),
                      ],
                    ),
                  ));
          AppData().sendEmail(currentUser, widget.courseModel);
        },
        onError: (error) {
          showDialog(
              context: context,
              builder: (_) => const AlertDialog(
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
                  ));
        },
        onCancel: (params) {
          showDialog(
              context: context,
              builder: (_) => const AlertDialog(
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
                  ));
          // Fluttertoast.showToast(
          //     msg: 'Cancelación de pago para ${widget.courseModel.title}');
        },
      ),
    );
  }

  Future<void> makePayment({context, amount, test, currentUser}) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'MXN', test);

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
      displayPaymentSheet(context, currentUser);
    } catch (err) {
      // print(err);
    }
  }

  displayPaymentSheet(BuildContext context, UserModel currentUser) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                          "Gracias por comprar el curso ${widget.courseModel.title}, te contactaremos por correo para enviarte los detalles"),
                    ],
                  ),
                ));

        AppData().sendEmail(currentUser, widget.courseModel);

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
