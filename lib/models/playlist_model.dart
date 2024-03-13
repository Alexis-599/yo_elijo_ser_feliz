// import 'song_model.dart';

// class Playlist {
//   final String title;
//   final List<Song> songs;
//   final String imageUrl;
//   final String authorImageUrl;

//   Playlist({
//     required this.title,
//     required this.songs,
//     required this.imageUrl,
//     required this.authorImageUrl,
//   });

//   // static List<Playlist> playlists = [
//   //   Playlist(
//   //     title: 'Mujer, madre y amante',
//   //     songs: Song.songs,
//   //     imageUrl: 'assets/images/yo_elijo_ser_feliz.jpg',
//   //     authorImageUrl: 'assets/images/adriana_carreon.jpg',
//   //   ),
//   //   Playlist(
//   //     title: 'Espiritualidad día a día',
//   //     songs: Song.songs,
//   //     imageUrl: 'assets/images/yo_elijo_ser_feliz.jpg',
//   //     authorImageUrl: 'assets/images/ruben_carreon.jpg',
//   //   ),
//   //   Playlist(
//   //     title: 'Rituales Lulú Kuri',
//   //     songs: Song.songs,
//   //     imageUrl: 'assets/images/yo_elijo_ser_feliz.jpg',
//   //     authorImageUrl: 'assets/images/yo_elijo_ser_feliz.jpg',
//   //   ),
//   // ];
// }
import 'package:podcasts_ruben/models/youtube_video.dart';

class PlaylistModel {
  String? kind;
  String? etag;
  String? nextPageToken;
  List<YouTubeVideo>? videos;
  PageInfo? pageInfo;

  PlaylistModel(
      {this.kind, this.etag, this.nextPageToken, this.videos, this.pageInfo});

  PlaylistModel.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    nextPageToken = json['nextPageToken'];
    if (json['items'] != null) {
      videos = <YouTubeVideo>[];
      json['items'].forEach((v) {
        videos!.add(YouTubeVideo.fromJson(v));
      });
    }
    pageInfo =
        json['pageInfo'] != null ? PageInfo.fromJson(json['pageInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kind'] = kind;
    data['etag'] = etag;
    data['nextPageToken'] = nextPageToken;
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    if (pageInfo != null) {
      data['pageInfo'] = pageInfo!.toJson();
    }
    return data;
  }
}

class PageInfo {
  int? totalResults;
  int? resultsPerPage;

  PageInfo({this.totalResults, this.resultsPerPage});

  PageInfo.fromJson(Map<String, dynamic> json) {
    totalResults = json['totalResults'];
    resultsPerPage = json['resultsPerPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalResults'] = totalResults;
    data['resultsPerPage'] = resultsPerPage;
    return data;
  }
}
