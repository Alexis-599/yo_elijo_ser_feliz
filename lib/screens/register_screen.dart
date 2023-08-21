import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:podcasts_ruben/services/auth.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/custom_text_field.dart';
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
  final confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void signUserUp() async {
    // const CircularProgressIndicator();

    // try creating the user
    try {
      if (passwordController.text == confirmPasswordController.text) {
        // create user
        // await AuthService().emailPasswordRegister(
        //     emailController.text.trim(), passwordController.text.trim());
        await _auth
            .createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim())
            .then((value) => {postDetailsToFirestore(emailController.text.trim())})
            .catchError((e) {});

      } else {
        showErrorMessage('Las contraseñas no son iguales');
      }
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

      else {
        showErrorMessage(e.message.toString());
      }
    }
  }

  postDetailsToFirestore(String email) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({'email': email, 'role': 'user'});
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

  // Future postUserDetails() async {
  //   await FirestoreService().addUserDetails(emailController.text.trim());
  // }

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
                  CustomTextField(
                    controller: emailController,
                    hintText: 'Correo electrónico',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  /// password text-field
                  CustomTextField(
                    controller: passwordController,
                    hintText: 'Contraseña',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  /// confirm password text-field
                  CustomTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirmar contraseña',
                    obscureText: true,
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