// import 'package:podcasts_ruben/services/auth.dart';

import 'package:podcasts_ruben/models/course_model.dart';
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

  var courses = [
    CourseModel(
      id: '1',
      image: 'assets/images/yo_elijo_ser_feliz.jpg',
      title: 'Course 1',
      subtitle: "flutter course",
      description: 'a new flutter course',
      price: '100',
      courseVideos: [],
    ),
    CourseModel(
      id: '2',
      image: 'assets/images/yo_elijo_ser_feliz.jpg',
      title: 'Course 2',
      subtitle: "dart course",
      description: 'a new dart course',
      price: '100',
      courseVideos: [],
    ),
    CourseModel(
      id: '3',
      image: 'assets/images/yo_elijo_ser_feliz.jpg',
      title: 'Course 3',
      subtitle: "react course",
      description: 'a new react course',
      price: '100',
      courseVideos: [],
    ),
    CourseModel(
      id: '4',
      image: 'assets/images/yo_elijo_ser_feliz.jpg',
      title: 'Course 4',
      subtitle: "next js course",
      description: 'a new next js course',
      price: '100',
      courseVideos: [],
    ),
    CourseModel(
      id: '5',
      image: 'assets/images/yo_elijo_ser_feliz.jpg',
      title: 'Course 5',
      subtitle: "laravel course",
      description: 'a new laravel course',
      price: '100',
      courseVideos: [],
    ),
  ];

  static const stripeLivePublishableKey =
      "pk_live_51O8ULJDTJQhkfNaOpAjAjEvV3iu0gyWgi82v5ujJ7vhuM5ezMzjG5pu35Up3GnP2b3b0AkICfqbiECCnCnlCe4Ak0006HgHMXc";

  static const stripeLiveSecretKey =
      "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";

  static const paypalSandboxClientId =
      "AWXrxroaEM4AFnlesSgy0WdYlBIDnsxXtTt2IvlpZckfU5HTiEl63DNT1w3oPjjgqgDxWKEMewXIsmCa";
  static const paypalLiveClientId =
      "ATm2Du384g73waJwE3gck5NsDWxGSV80HQ-Pc2hSaHMcO96jdp-eHSjoLXGDFvB1IxFMnyZcy6Xo_w67";

  static const paypalSandboxSecretKey =
      'EIWz74SX5rSABqb8tQWH3W6Iyo_gAKgy9LEdN2CGe4IwlhqCZt02UPNMK1x4BM7pJCNLphxzww8CPDuO';
  static const paypalLiveSecretKey =
      'EAoOss-wm7Nf6E8VZCqHc_bd1kYoTRlmckRhRImv-XIN0F7gDOdrc8I0S6pgAP_oEnPmWAonV8Vk1-pr';
}
