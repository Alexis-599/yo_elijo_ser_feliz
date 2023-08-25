import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:podcasts_ruben/services/auth.dart';
import 'package:podcasts_ruben/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void passwordReset() async {
    try {
      await AuthService().passwordReset(_emailController.text.trim());
      showMessage('Enlace de reinicio de contraseña enviado a su correo');
    } on FirebaseAuthException catch (e) {
      showMessage(e.message.toString());
    }
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Ingrese su correo y le enviaremos un link para actualizar su contraseña',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _emailController,
            hintText: 'Correo electrónico',
            isPassword: false,
          ),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: passwordReset,
            color: Colors.amber,
            child: const Text('Enviar correo'),
          )
        ],
      ),
    );
  }
}
