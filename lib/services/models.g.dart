// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist _$PlaylistFromJson(Map<String, dynamic> json) => Playlist(
      id: json['id'] as String? ?? "",
      title: json['title'] as String? ?? "",
      img: json['img'] as String? ?? "",
      author: json['author'] as String? ?? "",
      authorImg: json['authorImg'] as String? ?? "",
      description: json['description'] as String? ?? "",
      videos: (json['videos'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PlaylistToJson(Playlist instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'img': instance.img,
      'author': instance.author,
      'authorImg': instance.authorImg,
      'description': instance.description,
      'videos': instance.videos,
    };

Podcasts _$PodcastsFromJson(Map<String, dynamic> json) => Podcasts(
      playlists: (json['playlists'] as List<dynamic>?)
              ?.map((e) => Playlist.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PodcastsToJson(Podcasts instance) => <String, dynamic>{
      'playlists': instance.playlists,
    };

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      id: json['id'] as String? ?? "",
      title: json['title'] as String? ?? "",
      podcast: json['podcast'] as String? ?? "",
      date: json['date'] as String? ?? "",
      img: json['img'] as String? ?? "",
      path: json['path'] as String? ?? "",
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'podcast': instance.podcast,
      'date': instance.date,
      'img': instance.img,
      'path': instance.path,
    };
