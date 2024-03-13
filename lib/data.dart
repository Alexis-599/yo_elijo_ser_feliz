import 'dart:convert';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:http/http.dart' as http;
import 'package:podcasts_ruben/models/playlist_model.dart';
import 'package:podcasts_ruben/models/youtube_video.dart';

class AppData {
  static final AppData _instance = AppData._internal();
  late bool isAdmin;
  // late bool hasUserAuthData;
  // late List<dynamic> recentVideos;
  // late List<dynamic> playlistMedia;

  factory AppData() {
    return _instance;
  }

  AppData._internal() {
    isAdmin = false;
    // hasUserAuthData = false;
    // recentVideos = [];
    // playlistMedia = [];
  }

  // Future<void> loadData() async {
  //   recentVideos = await FirebaseApi.getRecentVideosMedia();
  //   playlistMedia = await FirebaseApi.getPlaylistMedia();
  // }

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

  static const androidGCPKEy = "AIzaSyDkLezImcsSOnjPTab6TUUwOAY6GvoO8Lo";
  static const iosGCPKEy = "AIzaSyCThNjrESvKYMQGM7XkyoO50UZFWwG2y3g";
  static const String apiKey = 'AIzaSyBn0_R3mF5J1Xx7LYD7pMhdoCgvz-RNZMQ';

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

  // Future<String> fetchPodcasts() async {
  //   const sha1 = "40:0b:57:28:bd:09:0e:d1:f8:12:d3:2c:0e:5f:55:d7:4c:8d:bc:23";
  //   const packageName = "com.alexis599apps.podcasts_ruben";
  //   const hEADERS = {
  //     'Content-Type': 'application/json',
  //     'X-Android-Package': packageName,
  //     'X-Android-Cert': sha1,
  //   };
  //   const String apiUrl =
  //       'https://www.googleapis.com/youtube/v3/playlists?part=PLDsYoS8mDh35-cVTB1JKGRiUxkc6XChMv&key=AIzaSyBn0_R3mF5J1Xx7LYD7pMhdoCgvz-RNZMQ';

  //   final response = await http.get(Uri.parse(apiUrl), headers: hEADERS);
  //   return response.body;

  //   // if (response.statusCode == 200) {
  //   //   log(response.body.toString());
  //   //   return response.statusCode;
  //   // } else {
  //   //   throw Exception('Failed to load podcasts');
  //   // }
  // }

  static const List playListIds = [
    'PLDsYoS8mDh35-cVTB1JKGRiUxkc6XChMv',
    // 'PLDsYoS8mDh37EQZ6cXaI3eNc8ytA78h3p',
    // 'PLDsYoS8mDh36n7K_v4rA36Gq_TzArKy58',
    'PLDsYoS8mDh34-aP2h54cruBMNMKpDNW1G',
    'PLDsYoS8mDh34svq2_P5gWOaicRCxveccA',
    'PLDsYoS8mDh35fuPbBb51AAeOJV0wq7NRc',
    'PLDsYoS8mDh35Pc1tG4BCRNcdG66F-VNhv',
    'PLDsYoS8mDh35nvBqEWIcWAsiGStWDE-RW',
    'PLDsYoS8mDh34l_bqTKnh7Bvjm2Ovmcr_K',
  ];

  Future<PlaylistModel> fetchPlaylistItems(playlistId) async {
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlistId&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return PlaylistModel.fromJson(data);
    } else {
      throw Exception('Failed to load playlist items');
    }
  }

  Future<List<YouTubeVideo>> fetchAllPlaylistItems(playlistId) async {
    String baseUrl =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlistId&key=$apiKey';

    List<YouTubeVideo> allVideos = [];
    String? pageToken;

    do {
      String apiUrl = baseUrl;
      if (pageToken != null) {
        apiUrl += '&pageToken=$pageToken';
      }

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> items = data['items'];

        for (var item in items) {
          allVideos.add(YouTubeVideo.fromJson(item));
        }

        pageToken = data['nextPageToken'];
      } else {
        throw Exception('Failed to load playlist items');
      }
    } while (pageToken != null);

    return allVideos;
  }
}
