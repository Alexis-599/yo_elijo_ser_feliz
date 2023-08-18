import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:podcasts_ruben/services/auth.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserUp() async {
    // show loading circle
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     });

    // try creating the user
    try {
      await AuthService()
          .emailPasswordLogin(emailController.text, passwordController.text);
    } on FirebaseAuthException catch (e) {
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        showErrorMessage(
            'Correo electrónico incorrecto y/o contraseña incorrecta');
      }

      // WRONG PASSWORD
      if (e.code == 'wrong-password') {
        // show error to user
        showErrorMessage('Contraseña incorrecta');
      }
    }

    // pop the loading circle
    // Navigator.pop(context);
  }

  // wrong email message popup
  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.amber,
            title: Text(message),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.amber.shade300,
                  Colors.amber.shade100,
                ])),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: MediaQuery.of(context).size.height * 0.14,
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.12,
                        backgroundImage: const AssetImage(
                            'assets/images/yo_elijo_ser_feliz.jpg'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// email text-field
                  _CustomTextField(
                    controller: emailController,
                    hintText: 'Correo electrónico',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  /// password text-field
                  _CustomTextField(
                    controller: passwordController,
                    hintText: 'Contraseña',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  /// confirm password text-field
                  _CustomTextField(
                    controller: passwordController,
                    hintText: 'Confirmar contraseña',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  /// forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '¿Olvidó su contraseña?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// sign up button
                  MyButton(
                    text: 'Registrarse',
                    onTap: signUserUp,
                  ),

                  const SizedBox(height: 10),

                  const SizedBox(height: 40), // 40

                  const Text('¿Ya tiene una cuenta?'),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text(' | '),
                      InkWell(
                        onTap: AuthService().anonLogin,
                        child: const Text(
                          'Ingresar como invitado',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;

  const _CustomTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  State<_CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        obscureText: widget.obscureText ? _isObscure : false,
        controller: widget.controller,
        decoration: InputDecoration(
            suffixIcon: widget.obscureText
                ? IconButton(
              icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            )
                : const Icon(
              Icons.abc,
              color: Colors.white,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}