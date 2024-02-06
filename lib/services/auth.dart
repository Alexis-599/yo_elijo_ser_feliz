import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:podcasts_ruben/services/firestore.dart';

// final authProvider = Provider<AuthService>((ref) => AuthService());

class AuthService extends ChangeNotifier {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  /// Anonymous Firebase Login
  Future<void> anonLogin() async {
    await FirebaseAuth.instance.signInAnonymously().catchError((e) {
      Fluttertoast.showToast(msg: 'An unknown error occured');
      return e;
    }).whenComplete(
        () => Fluttertoast.showToast(msg: 'Annonymous login successfully'));
  }

  /// Email & Password Login
  Future<void> emailPasswordLogin(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      Fluttertoast.showToast(msg: 'An unknown error occured');
      return e;
    }).whenComplete(() => Fluttertoast.showToast(msg: 'Login successfully'));
  }

  /// Reset Password via Email
  Future passwordReset(String email) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .catchError((e) {
      Fluttertoast.showToast(msg: 'An unknown error occured');
      return e;
    }).whenComplete(
            () => Fluttertoast.showToast(msg: 'Email sent successfully'));
  }

  // Email & Password Register
  Future<void> emailPasswordRegister(
      String email, String password, String name) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {
              FirestoreService().postDetailsToFirestore(
                email: email,
                name: name,
                imageUrl: '',
              )
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: 'An unknown error occured');
      return e;
    }).whenComplete(() => Fluttertoast.showToast(msg: 'Register successfully'));
  }

  /// Google Login
  Future<void> googleLogin() async {
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final authCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);
    if (userCredential.user != null) {
      FirestoreService().postDetailsToFirestore(
        email: userCredential.user!.email!,
        name: userCredential.user!.displayName!,
        imageUrl: userCredential.user!.photoURL!,
      );
    }
  }

  /// Apple Login
  // /// Generates a cryptographically secure random nonce, to be included in a
  // /// credential request.
  // String generateNonce([int length = 32]) {
  //   const charset =
  //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
  //       .join();
  // }
  //
  // /// Returns the sha256 hash of [input] in hex notation.
  // String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }
  //
  // Future<UserCredential> signInWithApple() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //
  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );
  //
  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );
  //
  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut().catchError((e) {
      Fluttertoast.showToast(msg: 'An unknown error occured');
      return e;
    }).whenComplete(() => Fluttertoast.showToast(msg: 'Logout successfully'));
  }
}

final authService = ChangeNotifierProvider<AuthService>((ref) => AuthService());
