// import 'package:podcasts_ruben/services/auth.dart';

class AppData {
  static final AppData _instance = AppData._internal();
  late bool isAdmin;
  late bool hasUserAuthData;

  factory AppData() {
    return _instance;
  }

  AppData._internal() {
    isAdmin = false;
    hasUserAuthData = false;
  }
}