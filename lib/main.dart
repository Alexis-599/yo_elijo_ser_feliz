import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:podcasts_ruben/bottom_bar_navigation.dart';
import 'package:podcasts_ruben/data.dart';
import 'package:podcasts_ruben/firebase_options.dart';
import 'package:podcasts_ruben/screens/home_screen.dart';
import 'package:podcasts_ruben/services/auth.dart';
import 'package:podcasts_ruben/services/firestore.dart';
import 'package:podcasts_ruben/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = AppData.stripeLivePublishableKey;
  // AppData().fetchPodcasts();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return MultiProvider(
          providers: [
            StreamProvider.value(
              value: FirestoreService().currentUserData,
              initialData: null,
              catchError: (context, error) {
                log(error.toString());
                return null;
              },
            ),
            ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
            ChangeNotifierProvider<DashboardProvider>(
                create: (_) => DashboardProvider()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Podcasts App',
            theme: appTheme(context),
            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}
