import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcasts_ruben/services/auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                image: const AssetImage('assets/images/yo_elijo_ser_feliz.jpg'),
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: LoginButton(
                text: 'Continue as Guest',
                icon: FontAwesomeIcons.userNinja,
                color: Colors.deepPurple,
                loginMethod: AuthService().anonLogin,
              ),
            ),
            LoginButton(
                text: 'Sign in with Google',
                icon: FontAwesomeIcons.google,
                color: Colors.blue,
                loginMethod: AuthService().googleLogin,
            ),
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
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    required this.loginMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: color,
        ),
        onPressed: () => loginMethod(),
        label: Text(text),
      ),
    );
  }
}
