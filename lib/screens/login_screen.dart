import 'package:flutter/material.dart';
import 'package:podcasts_ruben/services/auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
                ]
            )
        ),
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
                    backgroundImage: const AssetImage('assets/images/yo_elijo_ser_feliz.jpg'),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// username text-field
              _CustomTextField(
                controller: usernameController,
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
                onTap: () {},
              ),

              const SizedBox(height: 10),

              /// or continue with
              Row(
                children: const [
                  Expanded(
                    child: Divider(),
                  ),
                  Text('O continuar con'),
                  Expanded(
                    child: Divider(),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              /// google + apple sign in button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SquareTile(
                      imageUrl: 'assets/images/google.png',
                    loginMethod: AuthService().googleLogin,
                  ),
                  // FutureBuilder<Object>(
                  //   future: SignInWithApple.isAvailable(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.data == true) {
                  //       return Row(
                  //         children: [
                  //           const SizedBox(width: 10),
                  //           _SquareTile(
                  //             imageUrl: 'assets/images/apple.png',
                  //             loginMethod: AuthService().signInWithApple,
                  //           ),
                  //         ],
                  //       );
                  //     } else {
                  //       return Container();
                  //     }
                  //   },
                  // ),
                ],
              ),
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

  const _SquareTile({
    super.key,
    required this.imageUrl,
    required this.loginMethod
  });

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

  const _MyButton({
    super.key,
    required this.onTap
  });

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

class _CustomTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const _CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500])
        ),
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
