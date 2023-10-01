// import 'package:podcasts_ruben/services/auth.dart';

import 'package:podcasts_ruben/services/firebase_api.dart';

class AppData {
  static final AppData _instance = AppData._internal();
  late bool isAdmin;
  late bool hasUserAuthData;
  late List<dynamic> recentVideos;
  late List<dynamic> playlistMedia;

  factory AppData() {
    return _instance;
  }

  AppData._internal() {
    isAdmin = false;
    hasUserAuthData = false;
    recentVideos = [];
    playlistMedia = [];
  }

  Future<void> loadData() async {
    recentVideos = await FirebaseApi.getRecentVideosMedia();
    playlistMedia = await FirebaseApi.getPlaylistMedia();
  }
}