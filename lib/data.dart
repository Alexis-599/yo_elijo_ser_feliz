import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:podcasts_ruben/models/course_model.dart';
import 'package:http/http.dart' as http;
import 'package:podcasts_ruben/models/user_model.dart';
import 'package:podcasts_ruben/models/youtube_playlist_model.dart';
import 'package:podcasts_ruben/models/youtube_video.dart';

class AppData {
  List<CourseModel> courses = [];

  static List socialLinks = [
    {
      'image': "assets/images/spotify.png",
      'height': 65,
      'url':
          "https://open.spotify.com/show/7tOTZ5RF7DQWMUEw36DOa9?si=WkPtS0zgTCue2qX0ljo2qg",
    },
    {
      'image': "assets/images/youtube.png",
      'height': 60,
      'url': "https://youtube.com/@YoElijoSerFeliz?si=u0G4g0UOJRkg6ghy",
    },
    {
      'image': "assets/images/facebook.png",
      'height': 60,
      'url': "https://www.facebook.com/yoelijoserfelizmx?mibextid=dGKdO6",
    },
    {
      'image': "assets/images/instagram.svg.webp",
      'height': 58,
      'url':
          "https://www.instagram.com/yoelijoserfelizmx?igsh=MWJuZGszdzg5djQzaQ==",
    },
  ];

  // static const apiKey = "AIzaSyDkLezImcsSOnjPTab6TUUwOAY6GvoO8Lo";
  static const iosGCPKEy = "AIzaSyCThNjrESvKYMQGM7XkyoO50UZFWwG2y3g";
  static const apiKey = 'AIzaSyBn0_R3mF5J1Xx7LYD7pMhdoCgvz-RNZMQ';

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

  static const List playListIds = [
    'PLDsYoS8mDh35-cVTB1JKGRiUxkc6XChMv',
    'PLDsYoS8mDh37EQZ6cXaI3eNc8ytA78h3p',
    'PLDsYoS8mDh36n7K_v4rA36Gq_TzArKy58',
    'PLDsYoS8mDh34-aP2h54cruBMNMKpDNW1G',
    'PLDsYoS8mDh34svq2_P5gWOaicRCxveccA',
    'PLDsYoS8mDh35fuPbBb51AAeOJV0wq7NRc',
    'PLDsYoS8mDh35Pc1tG4BCRNcdG66F-VNhv',
    'PLDsYoS8mDh35nvBqEWIcWAsiGStWDE-RW',
    'PLDsYoS8mDh34l_bqTKnh7Bvjm2Ovmcr_K',
  ];

  Future<void> sendEmail(
    UserModel reciever,
    CourseModel courseModel,
  ) async {
    final ref = await FirebaseFirestore.instance
        .collection('utils')
        .doc('eSWZNRST680fbO91WsAP')
        .get();

    if (ref.exists) {
      final data = ref.data()!;
      final smtpServer = SmtpServer(
        data['smtpServerName'],
        username: data['smtpUsername'],
        password: data['smtpPassword'],
      );

      final message = Message()
        ..from = Address(data['senderEmail'], data['senderName'])
        ..recipients.add(reciever.email)
        ..subject = 'Gracias por comprar en Yo elijo ser feliz'
        ..text = '''
HI ${reciever.name},

${data['message']}

Link => ${courseModel.videoLink}
'''
        ..html = '<h1>Gracias por comprar en Yo elijo ser feliz</h1>';

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ${sendReport.mail}');
      } catch (e) {
        print('Error occurred while sending email: $e');
      }
    }
  }

  Future<YouTubePlaylist> fetchPlaylistDetails(playlistId) async {
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/playlists?part=snippet,contentDetails&id=$playlistId&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> playlistData = data['items'][0];
      return YouTubePlaylist.fromJson(playlistData);
    } else {
      throw Exception(
          'No se pudieron cargar los detalles de la lista de reproducción');
    }
  }

  Future<List<YouTubeVideo>> fetchPlaylistItems(playlistId) async {
    String baseUrl =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlistId&key=$apiKey';

    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['items'];

      return items.map((e) {
        Map<String, dynamic> thumbnail =
            e['snippet']['thumbnails'] as Map<String, dynamic>;
        if (thumbnail.isNotEmpty) {
          return YouTubeVideo.fromJson(e);
        } else {
          throw Exception(
              'No se pudieron cargar los detalles de la lista de reproducción');
        }
      }).toList();

      // return
    } else {
      throw Exception(
          'No se pudieron cargar los detalles de la lista de reproducción');
    }
  }

  Future<List<YouTubeVideo>> fetchAllPlaylistItems(
      {playlistId, maxResults, String? text}) async {
    String baseUrl =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlistId&key=$apiKey&maxResults=$maxResults';
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
          Map<String, dynamic> thumbnail =
              item['snippet']['thumbnails'] as Map<String, dynamic>;
          if (thumbnail.isNotEmpty) {
            allVideos.add(YouTubeVideo.fromJson(item));
          }
        }

        pageToken = data['nextPageToken'];
      } else {
        throw Exception(
            'No se pudieron cargar elementos de la lista de reproducción');
      }
    } while (pageToken != null);

    if (text == null) {
      return allVideos;
    } else {
      return allVideos
          .where((element) =>
              element.title.toLowerCase().contains(text.trim().toLowerCase()))
          .toList();
    }
  }

  Future<List<YouTubeVideo>> fetchRecentPodcastVideosFromChannels(
      List<String> playlistIds) async {
    List<YouTubeVideo> recentVideos = [];

    // Fetch recent videos from each playlist
    for (String playlistId in playlistIds) {
      List<YouTubeVideo> playlistVideos = await fetchPlaylistItems(playlistId);
      recentVideos
          .add(playlistVideos.first); // Take top 5 videos from each playlist
    }

    // Sort combined list of recent videos by publication date
    recentVideos.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    return recentVideos
        .take(5)
        .toList(); // Take top 5 videos from the combined list
  }
}
