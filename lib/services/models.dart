import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Playlist {
  final String id;
  final String title;
  final String img;
  final String author;
  final String authorImg;
  final String description;
  final List<Map> videos;

  Playlist({
    this.id = "",
    this.title = "",
    this.img = "assets/images/yo_elijo_ser_feliz.jpg",
    this.author = "",
    this.authorImg = "assets/images/yo_elijo_ser_feliz.jpg",
    this.description = "",
    this.videos = const [],
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => _$PlaylistFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}

@JsonSerializable()
class Podcasts {
  final List<Playlist> playlists;
  Podcasts({this.playlists = const []});

  factory Podcasts.fromJson(Map<String, dynamic> json) => _$PodcastsFromJson(json);
  Map<String, dynamic> toJson() => _$PodcastsToJson(this);
}

@JsonSerializable()
class Video {
  final String id;
  final String title;
  final String podcast;
  final String date;
  final String img;
  final String path;

  Video({
    this.id = "",
    this.title = "",
    this.podcast = "",
    this.date = "",
    this.img = "assets/images/yo_elijo_ser_feliz.jpg",
    this.path = "",
  });

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}