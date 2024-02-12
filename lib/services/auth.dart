import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:podcasts_ruben/screens/home_screen.dart';
import 'package:podcasts_ruben/screens/login_or_register_screen.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService extends ChangeNotifier {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  String errorMessage = '';
  bool isSigningIn = false;

  toggleSigning(bool value) {
    isSigningIn = value;
    notifyListeners();
  }

  Stream<User?> get userChanges => userStream;

  /// Anonymous Firebase Login
  Future<void> anonLogin() async {
    toggleSigning(true);
    try {
      await FirebaseAuth.instance.signInAnonymously().then((value) {
        Get.offAll(() => const HomeScreen());
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'An unknown error occured');
    } finally {
      toggleSigning(false);
    }
  }

  /// Email & Password Login
  Future<void> emailPasswordLogin(String email, String password) async {
    toggleSigning(true);
    try {
      final user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (user.user != null) {
        Get.offAll(() => const HomeScreen());
        Fluttertoast.showToast(msg: 'Login successfully');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Fluttertoast.showToast(msg: 'El correo electrónico no está registrado');
        errorMessage = 'El correo electrónico no está registrado';
      } else if (e.code == 'wrong-password') {
        // Fluttertoast.showToast(msg: 'Contraseña incorrecta');
        errorMessage = 'Contraseña incorrecta';
      } else {
        // Fluttertoast.showToast(msg: 'An unknown error occured');
        errorMessage = 'An unknown error occured';
      }
      notifyListeners();
    } finally {
      toggleSigning(false);
    }
  }

  /// Reset Password via Email
  Future passwordReset(String email) async {
    try {
      toggleSigning(true);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: 'Email sent successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'An unknown error occured');
    } finally {
      toggleSigning(false);
    }
  }

  /// Email & Password Register
  Future<void> emailPasswordRegister(
      String email, String password, String name) async {
    try {
      toggleSigning(true);
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        value.user!.updateDisplayName(name);
        FirestoreService().postDetailsToFirestore(
          name: name.trim(),
          loginUser: value.user,
        );
      }).whenComplete(() {
        Get.offAll(() => const HomeScreen());
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occured');
    } finally {
      toggleSigning(false);
    }
  }

  /// Google Login
  Future<void> googleLogin() async {
    try {
      toggleSigning(true);
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
          loginUser: userCredential.user,
        );
        Get.offAll(() => const HomeScreen());
      }
    } on FirebaseAuthException catch (e) {
      toggleSigning(false);

      Fluttertoast.showToast(msg: 'Please enter ${e.message}');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Google Login cancelled');
    } finally {
      toggleSigning(false);
    }
  }

  /// Apple Login
  Future<void> callAppleSignIn() async {
    toggleSigning(true);

    String generateNonce([int length = 32]) {
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(
          length, (_) => charset[random.nextInt(charset.length)]).join();
    }

    /// Returns the sha256 hash of [input] in hex notation.
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      await FirebaseAuth.instance
          .signInWithCredential(oauthCredential)
          .then((userCredential) async {
        await FirestoreService().postDetailsToFirestore(
          loginUser: userCredential.user,
        );
        // print(userCredential.user);
        Get.offAll(() => const HomeScreen());
      });
    } on FirebaseAuthException catch (e) {
      toggleSigning(false);

      Fluttertoast.showToast(msg: 'Please enter ${e.message}');
    } catch (e) {
      toggleSigning(false);

      Fluttertoast.showToast(msg: 'Apple login cancelled');
    } finally {
      toggleSigning(false);
    }
  }

  //signout
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance
          .signOut()
          .then((value) => Get.offAll(() => const LoginOrRegisterScreen()));
    } catch (e) {
      Fluttertoast.showToast(msg: 'An unknown error occured');
    } finally {
      isSigningIn = false;
      errorMessage = '';
      notifyListeners();
    }
  }
}

// final authService = ChangeNotifierProvider<AuthService>((ref) => AuthService());
