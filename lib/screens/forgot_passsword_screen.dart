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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void passwordReset() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService().passwordReset(_emailController.text.trim());
        showMessage(
            'Enlace de reinicio de contraseña enviado a su correo', false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showMessage('Este correo electrónico no está registrado', true);
        } else {
          showMessage(e.code, true);
        }
      }
    }
  }

  void showMessage(String message, bool isError) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              message,
              style: isError ? TextStyle(color: Colors.red[700]) : null,
            ),
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
      body: Form(
        key: _formKey,
        child: Column(
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
              isEmail: false,
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: passwordReset,
              color: Colors.amber,
              child: const Text('Enviar correo'),
            )
          ],
        ),
      ),
    );
  }
}
