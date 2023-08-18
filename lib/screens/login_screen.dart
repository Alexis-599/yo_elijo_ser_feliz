import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:podcasts_ruben/screens/forgot_passsword_screen.dart';
import 'package:podcasts_ruben/services/auth.dart';
import 'package:podcasts_ruben/widgets/custom_text_field.dart';
import 'package:podcasts_ruben/widgets/my_button.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    // show loading circle
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     });

    // try sign in
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

                  /// forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Text(
                            '¿Olvidó su contraseña?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const ForgotPasswordScreen();
                            }));
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// sign in button
                  MyButton(
                    text: 'Iniciar Sesión',
                    onTap: signUserIn,
                  ),

                  const SizedBox(height: 10),

                  /// or continue with
                  // Row(
                  //   children: const [
                  //     Expanded(
                  //       child: Divider(),
                  //     ),
                  //     Text('O continuar con'),
                  //     Expanded(
                  //       child: Divider(),
                  //     ),
                  //   ],
                  // ),
                  //
                  // const SizedBox(height: 20),
                  // /// google + apple sign in button
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     _SquareTile(
                  //         imageUrl: 'assets/images/google.png',
                  //       loginMethod: AuthService().googleLogin,
                  //     ),
                  //     const SizedBox(width: 10),
                  //     _SquareTile(
                  //       imageUrl: 'assets/images/facebook.png',
                  //       loginMethod: () {},
                  //     ),
                  //     const SizedBox(width: 10),
                  //     _SquareTile(
                  //       imageUrl: 'assets/images/apple.png',
                  //       loginMethod: () {},
                  //     ),
                  //     // FutureBuilder<Object>(
                  //     //   future: SignInWithApple.isAvailable(),
                  //     //   builder: (context, snapshot) {
                  //     //     if (snapshot.data == true) {
                  //     //       return Row(
                  //     //         children: [
                  //     //           const SizedBox(width: 10),
                  //     //           _SquareTile(
                  //     //             imageUrl: 'assets/images/apple.png',
                  //     //             loginMethod: AuthService().signInWithApple,
                  //     //           ),
                  //     //         ],
                  //     //       );
                  //     //     } else {
                  //     //       return Container();
                  //     //     }
                  //     //   },
                  //     // ),
                  //   ],
                  // ),
                  const SizedBox(height: 80), // 40

                  const Text('¿No tiene cuenta?'),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Registrarse',
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

// class _SquareTile extends StatelessWidget {
//   final String imageUrl;
//   final Function loginMethod;
//
//   const _SquareTile(
//       {super.key, required this.imageUrl, required this.loginMethod});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => loginMethod(),
//       child: Container(
//         padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.white),
//           borderRadius: BorderRadius.circular(16),
//           color: Colors.white70,
//         ),
//         child: Image.asset(
//           imageUrl,
//           height: 40,
//         ),
//       ),
//     );
//   }
// }

// class LoginButton extends StatelessWidget {
//   final Color color;
//   final IconData icon;
//   final String text;
//   final Function loginMethod;
//
//   const LoginButton({
//     super.key,
//     required this.color,
//     required this.icon,
//     required this.text,
//     required this.loginMethod,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       child: ElevatedButton.icon(
//         icon: Icon(
//           icon,
//           color: Colors.white,
//           size: 20,
//         ),
//         style: TextButton.styleFrom(
//           padding: const EdgeInsets.all(24),
//           backgroundColor: color,
//         ),
//         onPressed: () => loginMethod(),
//         label: Text(text),
//       ),
//     );
//   }
// }
