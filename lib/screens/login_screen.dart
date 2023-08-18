import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:podcasts_ruben/services/auth.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
        wrongEmailMessage();
      }

      // WRONG PASSWORD
      if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
    }

    // pop the loading circle
    // Navigator.pop(context);
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Correo electrónico incorrecto'),
          );
        });
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Contraseña incorrecta'),
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

              /// sign in button
              _MyButton(
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
              const SizedBox(height: 40),

              const Text('¿No tiene cuenta?'),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Registrarse',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
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

              // LoginButton(
              //   text: 'Continue as Guest',
              //   icon: FontAwesomeIcons.user,
              //   color: Colors.deepPurple,
              //   loginMethod: AuthService().anonLogin,
              // ),
              // LoginButton(
              //     text: 'Sign in with Google',
              //     icon: FontAwesomeIcons.google,
              //     color: Colors.blue,
              //     loginMethod: AuthService().googleLogin,
              // ),
              // FutureBuilder<Object>(
              //   future: SignInWithApple.isAvailable(),
              //   builder: (context, snapshot) {
              //     if (snapshot.data == true) {
              //       return SignInWithAppleButton(
              //         onPressed: () {
              //           AuthService().signInWithApple();
              //         },
              //       );
              //     } else {
              //       return Container();
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SquareTile extends StatelessWidget {
  final String imageUrl;
  final Function loginMethod;

  const _SquareTile(
      {super.key, required this.imageUrl, required this.loginMethod});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => loginMethod(),
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white70,
        ),
        child: Image.asset(
          imageUrl,
          height: 40,
        ),
      ),
    );
  }
}

class _MyButton extends StatelessWidget {
  final Function()? onTap;

  const _MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Iniciar Sesión',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
    super.key,
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
        obscureText: _isObscure,
        controller: widget.controller,
        decoration: InputDecoration(
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                        _isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
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
