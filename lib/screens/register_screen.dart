import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:podcasts_ruben/context_extension.dart';
import 'package:podcasts_ruben/screens/home_screen.dart';
import 'package:podcasts_ruben/services/auth.dart';

// import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/widgets/custom_text_field.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;

  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // text editing controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // final _auth = FirebaseAuth.instance;
  String errorMessage = '';
  bool isLoading = false;

  void signUserUp() async {
    setState(() => isLoading = true);
    if (_formKey.currentState!.validate()) {
      // try creating the user
      try {
        if (passwordController.text == confirmPasswordController.text) {
          await AuthService()
              .emailPasswordRegister(
                emailController.text.trim(),
                passwordController.text.trim(),
                nameController.text.trim(),
              )
              .whenComplete(() => context.pushTo(const HomeScreen()));

          errorMessage = '';
        } else {
          errorMessage = 'Las contraseñas no son iguales';
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Ese correo electrónico ya está registrado';
        } else {
          errorMessage = e.code;
        }
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // final auth = ref.watch(authService);

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
              child: Form(
                key: _formKey,
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
                      controller: nameController,
                      hintText: 'nombre completo',
                      isPassword: false,
                      isEmail: false,
                    ),

                    const SizedBox(height: 10),

                    /// email text-field
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Correo electrónico',
                      isPassword: false,
                      isEmail: true,
                    ),

                    const SizedBox(height: 10),

                    /// password text-field
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Contraseña',
                      isPassword: true,
                      isEmail: false,
                    ),

                    const SizedBox(height: 10),

                    /// confirm password text-field
                    CustomTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirmar contraseña',
                      isPassword: true,
                      isEmail: false,
                    ),

                    /// show error message
                    errorMessage.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  errorMessage,
                                  style: TextStyle(color: Colors.red[700]),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),

                    const SizedBox(height: 15),

                    /// sign up button
                    MyButton(
                      text: 'Registrarse',
                      onTap: signUserUp,
                      isLoading: isLoading,
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
      ),
    );
  }
}
