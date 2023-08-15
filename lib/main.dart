import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:podcasts_ruben/firebase_options.dart';
import 'package:podcasts_ruben/routes.dart';
import 'package:podcasts_ruben/theme.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Podcasts App',
      theme: appTheme(context),
      // home: const PlaylistScreen(),
      getPages: appRoutes,
    );
  }
}